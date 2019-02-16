context("report.lm")

test_that("report.lm", {
  library(circus)

  model <- circus::lm_1
  r <- report(model)
  testthat::expect_equal(r$values$parameters$wt$beta, -3.19, tol = 0.01)

  model <- circus::lm_2
  r <- report(model, performance_in_table=FALSE, effsize=NULL)
  testthat::expect_equal(r$values$parameters$wt$beta, -3.19, tol = 0.01)

  model <- circus::lm_3
  testthat::expect_warning(report(model, standardize=FALSE))

})
