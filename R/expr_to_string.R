#' @importFrom dplyr %>%
expr_to_string <- function(expr) {
  assign(".", NULL)
  if (is.character(expr))
    return(expr)
  res <- deparse(expr)
  if (res[1][1] == "{")
    res <- res[2:(length(res) - 1)] %>%
      sapply(substr, 5, 1000)
  res %>%
    sub("    ", "  ", .) %>%
    paste(sep = "\n")
}
