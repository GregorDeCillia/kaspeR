#' evaluate strings
#'
#' @export
evaluator <- R6::R6Class(
  "evaluator",
  public = list(
    initialize = function(...) {
      private$safe_env <- create_safe_environment(...)
    },
    eval = function(str) {
      str <- expr_to_string(substitute(str))
      paste(
        capture.output(
          private$res <- evaluate::evaluate(
            str,
            envir = new.env(emptyenv(), parent = private$safe_env)
          )
        ),
        sep = "\n"
      )
      return(invisible(NULL))
    },
    replay = function() {
      evaluate::replay(private$res)
    },
    getWhiteList = function() {
      names(private$safe_env)
    },
    appendSymbol = function(x, package) {
      append_symbol(private$safe_env, x, package)
    }
  ),
  private = list(
    res = NULL,
    safe_env = NULL
  )
)