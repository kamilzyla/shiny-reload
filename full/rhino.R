message("=== rhino.R ===")

clear_callback <- NULL

load_main <- function() {
  env = new.env(parent = baseenv())
  local(box::use(./main), env)

  if (!is.null(clear_callback)) {
    clear_callback()
  }
  clear_callback <<- shiny:::autoReloadCallbacks$register(function() {
    local(box::reload(main), env)
  })

  env
}

app <- function() {
  env <- load_main()
  shiny::shinyApp(
    ui = env$main$ui,
    server = env$main$server
  )
}
