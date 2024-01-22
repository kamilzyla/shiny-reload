wrap <- function(server) {
  function(...) { server(...) }
}
