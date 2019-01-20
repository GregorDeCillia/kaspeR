context("initialize")

test_that("initialize", {
  myEvaluator <- evaluator$new()
  testthat::expect_true(inherits(
    myEvaluator, "evaluator"
  ))
})

context("eval")

test_that("eval string", {
  myEvaluator <- evaluator$new()
  myEvaluator$eval({
    x <- 1; x <- x + 1; x; x - 1
  })
  testthat::expect_output(myEvaluator$replay(), "[1] 2", fixed = TRUE)
})

context("error")

test_that("system error", {
  myEvaluator$eval({ system('mkdir testdir') })
  capture.output(
    testthat::expect_message(myEvaluator$replay(), "Error", fixed = TRUE)
  )
})
