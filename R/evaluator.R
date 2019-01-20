#' evaluate strings
#'
#' @export
evaluator <- R6::R6Class(
  "evaluator",
  public = list(
    initialize = function(...) {
      private$safe_env <- create_safe_environment(...)
    },
    eval = function(str, new_device = FALSE) {
      str <- expr_to_string(substitute(str))
      ggplot2::set_last_plot(NULL)
      private$user_env <- new.env(emptyenv(), parent = private$safe_env)
      private$last_plot <- NULL
      paste(
        capture.output(
          private$res <- evaluate::evaluate(
            str,
            envir = private$user_env,
            output_handler = evaluate::new_output_handler(
              graphics = function(x) {
                if (is.null(x))
                  return(x)
                last_plot <- ggplot2::last_plot()
                if (is.null(last_plot)) {
                  private$last_plot <- x
                } else {
                  private$last_plot <- last_plot
                  ggplot2::set_last_plot(NULL)
                }
                return(NULL)
              }
            ),
            new_device = new_device
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
    },
    hasPlot = function() {
      !is.null(private$last_plot)
    }
  ),
  active = list(
    plot = function() {
      last_plot <- private$last_plot
      if (is.null(last_plot))
        return(NULL)
      if (is.ggplot(last_plot))
        return(last_plot)
      replayPlot(last_plot)
      return(invisible(NULL))
    }
  ),
  private = list(
    res = NULL,
    safe_env = NULL,
    last_plot = NULL,
    user_env = NULL
  )
)
