#' evaluate strings
#'
#' @export
evaluator <- R6::R6Class(
  "evaluator",
  public = list(
    initialize = function() {
      private$save_env <- createSafeEnvironment()
    },
    eval = function(str) {
      if (is.expression(str))
        str <- deparse(str)
       paste(
        capture.output(
          private$res <-evaluate::evaluate(str, envir = private$save_env)
        ),
        sep = "\n"
      )
      return(invisible(NULL))
    },
    replay = function() {
      evaluate::replay(private$res)
    },
    getWhiteList = function() {
      names(private$save_env)
    }
  ),
  private = list(
    res = NULL,
    save_env = NULL
  )
)
