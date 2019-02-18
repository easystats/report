context("report.stanreg_lm")

test_that("report.stanreg_lm", {
  library(rstanarm)
  library(circus)

  r <- report(circus::download_model("stanreg_lm_1"))
  testthat::expect_equal(r$values$parameters$wt$Median, -3.155, tol = 0.01)
  testthat::expect_equal(ncol(to_table(r)), 7)

  r <- report(circus::download_model("stanreg_lm_1"), bootstrap = TRUE, n = 10)
  testthat::expect_equal(r$values$parameters$wt$Median, -3.155, tol = 0.2)

  testthat::expect_error(report(circus::download_model("stanreg_lm_2"), performance_in_table = FALSE, effsize = NULL))
  # testthat::expect_equal(nrow(to_table(r)), 4)
  # testthat::expect_is(capture.output(to_table(r)), "character")
  # testthat::expect_equal(r$values$parameters$wt$beta, -3.19, tol = 0.01)
  #
  # testthat::expect_warning(report(circus::download_model("stanreg_lm_3"), standardize = FALSE, effsize="cohen1988"))

})


context("report.stanreg_glm")

test_that("report.stanreg_glm", {

  r <- report(circus::download_model("stanreg_glm_1"), effsize="cohen1988", standardize=TRUE)
  testthat::expect_equal(r$values$parameters$wt$Median, 0.791, tol = 0.05)
  testthat::expect_equal(ncol(to_table(r)), 8)

  r <- report(circus::download_model("stanreg_glm_2"))
  testthat::expect_equal(r$values$parameters$wt$Median, 0.987, tol = 0.05)
  testthat::expect_equal(ncol(to_table(r)), 7)

})


context("report.stanreg_lmer")

test_that("report.stanreg_lmer", {

  model <- circus::download_model("stanreg_lmerMod_1")
  r <- report(circus::download_model("stanreg_lmerMod_1"), effsize="cohen1988", standardize=TRUE)
  testthat::expect_equal(r$values$parameters$cyl$Median, 0.4062, tol = 0.05)
  testthat::expect_equal(ncol(to_table(r)), 8)

  r <- report(circus::download_model("stanreg_merMod_1"), effsize="chen2010", standardize=TRUE)
  testthat::expect_equal(r$values$parameters$cyl$Median, -1.72, tol = 0.05)
  testthat::expect_equal(ncol(to_table(r)), 8)

})