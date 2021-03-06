% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/evaluator.R
\name{evaluator}
\alias{evaluator}
\title{Class for safe evaluation}
\description{
This R6 Class can be used to evaluate R expressions or R strings in a safe
environment.
}
\section{Usage}{

\preformatted{
evt <- evaluator$new(...)
evt$eval(str, new_device = FALSE, reset_env = TRUE)
evt$replay()
# -------------------------------------------------- #
evt$appendSymbol(x, package)
evt$plot
evt$getUserEnv()
# -------------------------------------------------- #
evt$hasPlot()
evt$hadError()
evt$hadWarning()
}
}

\section{Arguments}{

\itemize{
\item \code{...} Passed down to \link{create_safe_environment}
\item \code{str} A string or expression to evaluate
\item \code{new_device} Whether to open an new graphics device for plots.
See \link[evaluate:evaluate]{evaluate::evaluate}
\item \code{reset_env} Should the user environment be reset?
\item \code{x} A string representing a symbol. Can be a function name or
an infix operator like \code{\%>\%}.
\item \code{package} The package where the symbol comes from.
}
}

\section{Methods}{

\itemize{
\item \code{new()} initializes a new \code{evaluator} object.
\item \code{eval()} evaluates a string or expression in a safe environment.
\item \code{replay()} uses \code{\link[evaluate:replay]{evaluate::replay()}} to show the result of the
last \code{evaluate()} call.
\item \code{appendSymbol()} extends the safe environment by a function or
operator.
\item \code{getUserEnv()} Returns a tabular representation of the environment
created by the call to \code{$eval()}
\item \code{hasPlot()}, \code{hadError()} and \code{hadWarning()} are flags that can be used to
check whether the expression in \code{eval} produced a plot, error or warning.
}
}

\section{Fields}{

\itemize{
\item \code{plot} is an active binding that replays the last plot using
\code{\link[grDevices:replayPlot]{grDevices::replayPlot()}}. In case of a \code{gplot}, a \code{ggplot} object
is returned.
}
}

\examples{
## create a new object
evt <- evaluator$new()

# evaluate a string and "replay" the result
evt$eval("2 + 2")
evt$replay()

# evaluate an expression. Useful if code spans several lines
evt$eval({
  x <- 2 + 1
  y <- x + 1
  cat(x, y, sep = " ")
})
evt$replay()
}
