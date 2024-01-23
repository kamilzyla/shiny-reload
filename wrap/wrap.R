message("=== wrap.R ===")

wrap <- function(server) {
  function(...) { server(...) }
}
