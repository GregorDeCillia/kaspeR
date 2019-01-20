evaluator$set(
  "private", "output_handler",
  function() {
    ggplot2::set_last_plot(NULL)
    private$last_plot <- NULL
    private$last_warning <- NULL
    private$last_error <- NULL
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
      },
      warning = function(x) {
        private$last_warning <- x
      },
      error = function(x) {
        private$last_error <- x
      }
    )
  }
)
