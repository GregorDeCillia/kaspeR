append_plot <- function(env) {
  append_symbol(env, "plot", "graphics")
  append_symbol(env, "ggplot", "ggplot2")
  append_symbol(env, "aes", "ggplot2")
  append_symbol(env, "geom_point", "ggplot2")

}
