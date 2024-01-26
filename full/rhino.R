message("=== rhino.R ===")

app <- function() {
  app_env <- load_app()

  # There are two key components to make automatic reloading work:
  # 1. When app files are modified, the reload callback refreshes the `main` module in `app_env`.
  # 2. UI and server are functions which retrieve `main` from `app_env` each time they are called.
  #
  # If we retrieved the `main` module once before the functions are defined below,
  # or if we passed `main$ui` and `main$server` directly to `shinyApp()`,
  # reloading wouldn't work.
  shiny::shinyApp(
    ui = function(request) app_env$main$ui,
    server = function(...) {
      app_env$main$server(...)
    }
  )
}

load_app <- function() {
  app_env <- new.env(parent = baseenv())
  load_main <- function() {
    # We could also use box::reload().
    # Purge box cache so that changes to code take effect when calling `shiny::runApp()` multiple times in the same R session.
    box::purge_cache()
    # If box::use() fails during reload, the main module won't be replaced in `app_env`
    # and the app will continue to work.
    local(box::use(./main), app_env)
  }

  load_main()
  # We always register an auto-reload callback.
  # Shiny just won't call it if the `shiny.autoreload` option is not set.
  register_reload_callback(load_main)

  app_env
}

register_reload_callback <- function(callback) {
  # We need to clear the previous callback, as otherwise we'd register a new callback each time
  # rhino::app() is called.
  # This happens when calling `shiny::runApp()` multiple times in the same session
  # and after refreshing the app page after `app.R` was touched (this happens even without shiny.autoreload).
  # We'd end up with multiple reload callbacks thus leading to a resource leak.
  clear_callback <- get0("clear_callback", envir = .GlobalEnv)
  if (!is.null(clear_callback)) {
    message("@ Clearing callback")
    clear_callback()
  }
  message("@ Registering callback")
  # We use global environment here. We'd use package environment in the package.
  .GlobalEnv$clear_callback <- shiny:::autoReloadCallbacks$register(
    function() {
      message("@ Callback")
      # If we allowed the error to propagate, reloading would stop working in the current session.
      tryCatch(
        callback(),
        error = function(cond) message(conditionMessage(cond))
      )
    }
  )
}
