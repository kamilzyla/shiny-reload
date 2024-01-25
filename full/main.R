message("=== main.R ===")

box::use(
  shiny,
  ./module,
)

ui <- shiny$tagList(
  paste("UI:", module$ui_text),
  shiny$textOutput("message")
)

server <- function(input, output) {
  output$message <- shiny$renderText(paste("Server:", module$server_text))
}
