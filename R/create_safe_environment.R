append_symbol <- function(env, x, package) {
  env[[x]] <- eval(parse(text = paste0(package, "::`", x, "`")))
}

#' Create a safe environment
#'
#' Creates an environment where the safe expressions are to be evaluated.
#'
#' @param dplyr Load a collections of `dplyr` functions in the environment.
#' @param plot Load a collection of `graphics` and `ggplot2` functions in the
#'   environment.
#'
#' @return An environment that uses the empty environment (`emptyenv()`) as
#'   its parent. The environment serves as a "whitelist" to prevent users
#'   of [evaluator]`$eval()` to invoke malicious operations.
#'
#' @examples
#' safe_env <- create_safe_environment()
#' eval(parse(text = "2 + 2"), safe_env)
#'
#' \dontrun{
#' ## trigger an error
#' eval(parse(text = "system('mkdir(test)')"), safe_env)
#' }
#'
#' @export
create_safe_environment <- function(dplyr = FALSE, plot = FALSE) {
  safe_env <- new.env(parent = emptyenv())
  append_base_operations(safe_env)
  if (dplyr)
    append_dplyr_operations(safe_env)
  if (plot)
    append_plot(safe_env)
  safe_env
}
