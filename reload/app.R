.GlobalEnv$count <- get0("count", envir = .GlobalEnv, ifnotfound = 0) + 1
msg <- paste("=== RELOAD", count)
message("register ", count)
shiny:::autoReloadCallbacks$register(function() {
  message(msg)
})

shinyApp(
  ui = "Hello!",
  server = function(input, output) {}
)
