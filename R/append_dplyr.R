appendDplyrOperations <- function(env) {
  safe_f <- c(
    ## basic verbs
    "%>%", "mutate", "select", "recode", "filter", "arrange", "rename",
    "transmute", "summarize", "sample_n", "sample_frac",
    ## join
    "inner_join", "left_join", "right_join", "full_join", "semi_join", "anti_join"
  )
  for (f in safe_f) {
    appendSymbol(env, f, "dplyr")
  }
}
