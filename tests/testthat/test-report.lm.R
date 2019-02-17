context("report.lm")

test_that("report.lm", {
  library(circus)

  r <- report(circus::download_model("lm_1"))
  testthat::expect_equal(r$values$parameters$wt$beta, -3.19, tol = 0.01)
  testthat::expect_equal(ncol(to_table(r)), 7)

  r <- report(circus::download_model("lm_1"), bootstrap = TRUE, n=500)
  testthat::expect_equal(r$values$parameters$wt$Median, -3.232, tol = 0.2)

  r <- report(circus::download_model("lm_2"), performance_in_table=FALSE, effsize=NULL)
  testthat::expect_equal(nrow(to_table(r)), 4)
  testthat::expect_is(capture.output(to_table(r)), "character")
  testthat::expect_equal(r$values$parameters$wt$beta, -3.19, tol = 0.01)

  testthat::expect_warning(report(circus::download_model("lm_3"), standardize=FALSE))

})
