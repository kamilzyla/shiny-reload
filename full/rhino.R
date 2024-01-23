message("=== rhino.R ===")

load_main <- function() {
  app_env <- new.env(parent = baseenv())
  local(box::use(./main), app_env)

  clear_callback <- get0("clear_callback", envir = .GlobalEnv)
  if (!is.null(clear_callback)) {
    message("@ Clearing previous callback")
    clear_callback()
  }
  message("@ Registering callback")
  .GlobalEnv$clear_callback <- shiny:::autoReloadCallbacks$register(function() {
    message("@ Callback")
    local(box::reload(main), app_env)
  })

  wrap(app_env)
}

wrap <- function(app_env) {
  # The reloading works, because both UI and server are functions
  # which retrieve the main module from `app_env`.
  list(
    ui = function(request) app_env$main$ui,
    server = function(input, output) {
      app_env$main$server()
    }
  )
}

app <- function() {
  main <- load_main()
  shiny::shinyApp(
    ui = main$ui,
    server = main$server
  )
}
