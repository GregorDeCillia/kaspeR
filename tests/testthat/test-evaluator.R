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
