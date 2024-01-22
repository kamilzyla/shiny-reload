message("=== app.R ===")

rhino <- new.env(parent = baseenv())
source("rhino.R", local = rhino, keep.source = TRUE)

rhino$app()
