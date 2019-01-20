context("initialize")

test_that("initialize", {
  my_evaluator <- evaluator$new()
  expect_true(inherits(
    my_evaluator, "evaluator"
  ))
})

context("eval")

test_that("eval expression", {
  my_evaluator <- evaluator$new()
  my_evaluator$eval({
    x <- 1; x <- x + 1; x; x - 1
  })
  expect_output(my_evaluator$replay(), "[1] 2", fixed = TRUE)
})

test_that("eval string", {
  my_evaluator <- evaluator$new()
  my_evaluator$eval("2 + 2")
  expect_output(my_evaluator$replay(), "[1] 4", fixed = TRUE)
})

test_that("dplyr", {
  library(dplyr)
  my_evaluator <- evaluator$new(dplyr = TRUE)
  my_evaluator$eval({
    data.frame(a = 1:4, b = letters[1:4]) %>%
      filter(a < 3)
  })
  expect_output(my_evaluator$replay(), "2 2 b", fixed = TRUE)
})

context("error")

test_that("system error", {
  my_evaluator <- evaluator$new()
  my_evaluator$eval({
    system("mkdir testdir")
  })
  capture.output(
    expect_message(my_evaluator$replay(), "Error", fixed = TRUE)
  )
})

context("whitelist")

test_that("getWhiteList", {
  my_evaluator <- evaluator$new()
  expect_true("sqrt" %in% my_evaluator$getWhiteList())
  expect_false("system" %in% my_evaluator$getWhiteList())

  my_evaluator$appendSymbol("system", "base")
  expect_true("system" %in% my_evaluator$getWhiteList())
})

context("plot")

test_that("plot", {
  ## use new_device = TRUE because devtools::check() uses some
  ## kind of NULL device which prevents plots from being captured

  library(ggplot2)
  my_evaluator <- evaluator$new(plot = TRUE)
  my_evaluator$appendSymbol("mtcars", "datasets")

  ## ggplot
  my_evaluator$eval(new_device = TRUE, {
    ggplot(mtcars, aes(wt, cyl)) +
      geom_point()
    NULL
  })
  expect_true(my_evaluator$hasPlot())
  expect_true(inherits(my_evaluator$plot, "ggplot"))

  ## no plot
  my_evaluator$eval("2+2", new_device = TRUE)
  expect_false(my_evaluator$hasPlot())
  expect_null(my_evaluator$plot)

  ## base graphics
  my_evaluator$eval(plot(1:10), new_device = TRUE)
  expect_true(my_evaluator$hasPlot())
  expect_false(inherits(my_evaluator$plot, "ggplot"))
})

context("user env")

test_that("user_env", {
  my_evaluator <- evaluator$new()
  my_evaluator$eval("x <- 2")
  expect_identical(dim(my_evaluator$getUserEnv()), c(1L, 2L))
  my_evaluator$eval("a <- 1", reset_env = FALSE)
  expect_identical(my_evaluator$getUserEnv()$name, c("x", "a"))
  my_evaluator$eval("a <- FALSE")
  expect_identical(my_evaluator$getUserEnv()$class, "logical")
})
