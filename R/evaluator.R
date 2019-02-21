#' Class for safe evaluation
#'
#' This R6 Class can be used to evaluate R expressions or R strings in a safe
#' environment.
#'
#' @section Usage:
#' \preformatted{
#' evt <- evaluator$new(...)
#' evt$eval(str, new_device = FALSE, reset_env = TRUE)
#' evt$replay()
#' # -------------------------------------------------- #
#' evt$appendSymbol(x, package)
#' evt$plot
#' evt$getUserEnv()
#' # -------------------------------------------------- #
#' evt$hasPlot()
#' evt$hadError()
#' evt$hadWarning()
#' }
#' @section Arguments:
#' - `...` Passed down to [create_safe_environment]
#' - `str` A string or expression to evaluate
#' - `new_device` Whether to open an new graphics device for plots.
#'   See [evaluate::evaluate]
#' - `reset_env` Should the user environment be reset?
#' - `x` A string representing a symbol. Can be a function name or
#'   an infix operator like `%>%`.
#' - `package` The package where the symbol comes from.
#' @section Methods:
#' - `new()` initializes a new `evaluator` object.
#' - `eval()` evaluates a string or expression in a safe environment.
#' - `replay()` uses [evaluate::replay()] to show the result of the
#'   last `evaluate()` call.
#' - `appendSymbol()` extends the safe environment by a function or
#'   operator.
#' - `getUserEnv()` Returns a tabular representation of the environment
#'   created by the call to `$eval()`
#' - `hasPlot()`, `hadError()` and `hadWarning()` are flags that can be used to
#'   check whether the expression in `eval` produced a plot, error or warning.
#' @section Fields:
#' - `plot` is an active binding that replays the last plot using
#'   [grDevices::replayPlot()]. In case of a `gplot`, a `ggplot` object
#'   is returned.
#' @name evaluator
#' @examples
#' ## create a new object
#' evt <- evaluator$new()
#'
#' # evaluate a string and "replay" the result
#' evt$eval("2 + 2")
#' evt$replay()
#'
#' # evaluate an expression. Useful if code spans several lines
#' evt$eval({
#'   x <- 2 + 1
#'   y <- x + 1
#'   cat(x, y, sep = " ")
#' })
#' evt$replay()
NULL
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
