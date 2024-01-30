message("=== app.R ===")

source("wrap.R", keep.source = FALSE)

server <- function(input, output) {
  output$message <- renderText("Hello!")
}

options(shiny.autoreload = TRUE)

shinyApp(
  ui = textOutput("message"),
  server = server |> wrap() |> fix()
)
