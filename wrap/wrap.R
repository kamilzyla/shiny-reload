message("=== wrap.R ===")

wrap <- function(f) {
  function(...) f(...)
}

fix <- function(server) {
  reparse(curly_wrap(server))
}

reparse <- function(f) {
  eval(parse(text = deparse(f)), envir = environment(f))
}

curly_wrap <- function(f) {
  wrapped <- function() {
    do.call(f, as.list(match.call())[-1])
  }
  formals(wrapped) <- formals(f)
  wrapped
}
