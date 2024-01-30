message("=== app.R ===")

options(shiny.autoreload = TRUE)

shinyApp(
  ui = tagList(
    paste("UI:", ui_text),
    textOutput("message")
  ),
  server = function(input, output) {
    output$message <- renderText(paste("Server:", server_text))
  }
)
