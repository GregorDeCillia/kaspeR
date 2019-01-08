appendSymbol <- function(env, x, package) {
  env[[x]] <- get(x, paste0("package:", package))
}

createSafeEnvironment <- function(dplyr = FALSE) {
  safe_env <- new.env(parent = emptyenv())
  appendBaseOperations(safe_env)
  if (dplyr)
    appendDplyrOperations(safe_env)
  safe_env
}
