#' @importFrom methods getGroupMembers
append_base_operations <- function(env) {
  safe_f <- c(
    ## operations and math
    getGroupMembers("Math"),
    getGroupMembers("Arith"),
    getGroupMembers("Compare"),
    ## misc
    "<-", "{", "(", "ls", "function", "c", ":", "letters", "LETTERS",
    "cat", "dim", "nrow", "ncol",
    ## types
    "numeric", "integer", "character", "logical", "data.frame",
    ## indexing
    "list", "[[", "[", "[.data.frame",
    ## generics
    "print", "subset"
  )
  for (f in safe_f) {
    append_symbol(env, f, "base")
  }
}
