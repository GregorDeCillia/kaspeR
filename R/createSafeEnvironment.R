createSafeEnvironment <- function() {
  safe_f <- c(
    getGroupMembers("Math"),
    getGroupMembers("Arith"),
    getGroupMembers("Compare"),
    "<-", "{", "(", "ls", "function"
  )
  safe_env <- new.env(parent = emptyenv())
  for (f in safe_f) {
    safe_env[[f]] <- get(f, "package:base")
  }

  safe_env
}
