message("=== rhino.R ===")

load_main <- function() {
  env = new.env(parent = baseenv())
  local(box::use(./main), env)

  clear_callback <- get0("clear_callback", envir = .GlobalEnv)
  if (!is.null(clear_callback)) {
    message("@ Clearing previous callback")
    clear_callback()
  }
  message("@ Registering callback")
  .GlobalEnv$clear_callback <- shiny:::autoReloadCallbacks$register(function() {
    message("@ Callback")
    local(box::reload(main), env)
  })

  env
}

wrap <- function(env) {
  list(
    ui = function(request) env$main$ui,
    server = function(input, output) {
      env$main$server()
    }
  )
}

app <- function() {
  main <- wrap(load_main())
  shiny::shinyApp(
    ui = main$ui,
    server = main$server
  )
}
