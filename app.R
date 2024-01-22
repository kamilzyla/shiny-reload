source("wrap.R", keep.source = TRUE)

server <- function(input, output) {
  output$message <- renderText("Hello!")
}

shinyApp(
  ui = textOutput("message"),
  server = wrap(server)
)
