#' evaluate strings
#'
#' @importFrom ggplot2 is.ggplot
#' @export
evaluator <- R6::R6Class(
  "evaluator",
  public = list(
    initialize = function(...) {
      private$safe_env <- create_safe_environment(...)
    },
    eval = function(str, new_device = FALSE, reset_env = TRUE) {
      str <- expr_to_string(substitute(str))
      if (reset_env || is.null(private$user_env))
        private$user_env <- new.env(emptyenv(), parent = private$safe_env)
      paste(
        capture.output(
          private$res <- evaluate::evaluate(
            str,
            envir = private$user_env,
            output_handler = private$output_handler(),
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
    },
    hadError = function() {
      !is.null(private$last_error)
    },
    hadWarning = function() {
      !is.null(private$last_warning)
    },
    getUserEnv = function() {
      env_table <- data.frame(
        name = names(private$user_env),
        class = sapply(private$user_env, class),
        stringsAsFactors = FALSE
      )
      row.names(env_table) <- NULL
      env_table
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
    safe_env = NULL, user_env = NULL,
    last_plot = NULL, last_warning = NULL, last_error = NULL
  )
)
