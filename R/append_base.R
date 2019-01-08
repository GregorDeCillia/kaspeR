#' @importFrom methods getGroupMembers
appendBaseOperations <- function(env) {
  safe_f <- c(
    ## operations and math
    getGroupMembers("Math"),
    getGroupMembers("Arith"),
    getGroupMembers("Compare"),
    ## misc
    "<-", "{", "(", "ls", "function", "c", ":", "letters", "LETTERS",
    ## types
    "numeric", "integer", "character", "logical", "data.frame",
    ## indexing
    "list", "[[", "[", "[.data.frame",
    ## generics
    "print", "subset"
  )
  for (f in safe_f) {
    appendSymbol(env, f, "base")
  }
}
