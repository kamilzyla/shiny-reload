message("=== rhino.R ===")

app <- function() {
  # There are two key components to make `shiny.autoreload` work:
  # 1. When app files are modified, the reload callback refreshes the `main` module in `app_env`.
  # 2. UI and server are functions which retrieve `main` from `app_env` each time they are called.
  #
  # If we retrieved the `main` module only once before the UI/server functions are defined below,
  # or if we passed `main$ui` and `main$server` directly to `shinyApp()`,
  # reloading wouldn't work.

  app_env <- load_app()
  shiny::shinyApp(
    ui = function(request) app_env$main$ui,
    server = function(...) {
      app_env$main$server(...)
    }
  )
}

load_app <- function() {
  # We use the same method both for loading the main module initially and for reloading it.
  # This guarantees consistent behavior regardless of whether user enables `shiny.autoreload`,
  # or calls `shiny::runApp()` each time they want to see changes.
  #
  # If `box::use()` fails while reloading (e.g. due to a syntax error),
  # the `main` module won't be replaced in `app_env` and the app should continue to work.
  #
  # We always register an auto-reload callback.
  # Shiny just won't call it unless `shiny.autoreload` option is set.

  app_env <- new.env(parent = baseenv())
  load_main <- function() {
    box::purge_cache()
    local(box::use(./main), app_env)
  }

  load_main()
  register_reload_callback(load_main)

  app_env
}

register_reload_callback <- function(callback) {
  # Before installing a new reload callback, we need to clear the previous one:
  # 1. Users might call `shiny::runApp()` multiple times in the same R session.
  # 2. Shiny will source `app.R` again after its timestamp is updated
  #    (this happens even without `shiny.autoreload`).
  #
  # We use `.GlobalEnv` to store `clear_callback` in this example.
  # We'd use package environment inside a package.
  #
  # If the reload callback throws an error, we catch it and print it.
  # Allowing it to propagate would break reloading in the current `shiny::runApp()` call.

  clear_callback <- get0("clear_callback", envir = .GlobalEnv)
  if (!is.null(clear_callback)) {
    message("@ Clearing callback")
    clear_callback()
  }

  message("@ Registering callback")
  .GlobalEnv$clear_callback <- shiny:::autoReloadCallbacks$register(
    function() {
      message("@ Callback")
      tryCatch(
        callback(),
        error = function(cond) message(conditionMessage(cond))
      )
    }
  )
}
