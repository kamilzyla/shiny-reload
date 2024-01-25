message("=== rhino.R ===")

app <- function() {
  app_env <- load_app()

  # Reloading works, because both UI and server are functions
  # which retrieve the main module from `app_env`.
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
    box::purge_cache()
    local(box::use(./main), app_env)
  }

  load_main()
  register_reload_callback(load_main)

  app_env
}

register_reload_callback <- function(callback) {
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
