evaluator$set(
  "private", "output_handler",
  function() {
    evaluate::new_output_handler(
      graphics = function(x) {
        last_plot <- ggplot2::last_plot()
        if (is.null(last_plot)) {
          private$last_plot <- x
        } else {
          private$last_plot <- last_plot
          ggplot2::set_last_plot(NULL)
        }
        return(NULL)
      }
    )
  }
)
