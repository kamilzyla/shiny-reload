message("=== app.R ===")

.GlobalEnv$count <- get0("count", envir = .GlobalEnv, ifnotfound = 0) + 1
msg <- paste("@ reload", count)
message("@ register callback ", count)
shiny:::autoReloadCallbacks$register(function() {
  message(msg)
})

shinyApp(
  ui = "Hello!",
  server = function(input, output) {}
)
