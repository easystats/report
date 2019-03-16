context("report.stanreg_lm")

test_that("report.stanreg_lm", {
  library(rstanarm)
  library(circus)

  r <- report(circus::download_model("stanreg_lm_1"))
  testthat::expect_equal(r$values$parameters$wt$Median, -5.34, tol = 0.2)
  testthat::expect_equal(ncol(to_table(r)), 7)

  r <- report(circus::download_model("stanreg_lm_1"), bootstrap = TRUE, n = 10)
  testthat::expect_equal(r$values$parameters$wt$Median, -5.34, tol = 0.2)

  r <- report(circus::download_model("stanreg_lm_1"), effsize = "cohen1988", standardize = TRUE, parameters_estimate = "Mean")
  testthat::expect_equal(r$values$parameters$wt$Mean, -5.3397, tol = 0.2)

  r <- report(circus::download_model("stanreg_lm_1"), effsize = "cohen1988", standardize = TRUE, parameters_estimate = "MAP")
  testthat::expect_equal(r$values$parameters$wt$MAP, -5.22, tol = 0.2)

  r <- report(circus::download_model("stanreg_lm_1"), effsize = "cohen1988", rope_full=FALSE, standardize = TRUE, parameters_estimate = c("Mean", "Median", "MAP"))
  testthat::expect_equal(r$values$parameters$wt$Median, -5.336, tol = 0.2)

  testthat::expect_warning(report(circus::download_model("stanreg_lm_1"), ci=c(0.8, 0.9)))
  testthat::expect_error(report(circus::download_model("stanreg_lm_1"), rope_range=c(0.1, 0.2, 0.3)))

  # testthat::expect_equal(nrow(to_table(r)), 4)
  # testthat::expect_is(capture.output(to_table(r)), "character")
  # testthat::expect_equal(r$values$parameters$wt$beta, -3.19, tol = 0.01)
  #
  # testthat::expect_warning(report(circus::download_model("stanreg_lm_3"), standardize = FALSE, effsize="cohen1988"))
})


context("report.stanreg_glm")

test_that("report.stanreg_glm", {
  r <- report(circus::download_model("stanreg_glm_1"), effsize = "cohen1988", standardize = TRUE)
  testthat::expect_equal(r$values$parameters$wt$Median, -1.93, tol = 0.2)
  testthat::expect_equal(ncol(to_table(r)), 8)

  r <- report(circus::download_model("stanreg_glm_2"))
  testthat::expect_equal(r$values$parameters$wt$Median, 0.759, tol = 0.2)
  testthat::expect_equal(ncol(to_table(r)), 7)
})


context("report.stanreg_lmer")

test_that("report.stanreg_lmer", {
  r <- report(circus::download_model("stanreg_lmerMod_1"), effsize = "cohen1988", standardize = TRUE)
  testthat::expect_equal(r$values$parameters$cyl$Median, 0.406, tol = 0.2)
  testthat::expect_equal(ncol(to_table(r)), 8)

  r <- report(circus::download_model("stanreg_merMod_1"), effsize = "chen2010", standardize = TRUE)
  testthat::expect_equal(r$values$parameters$cyl$Median, -1.72, tol = 0.2)
  testthat::expect_equal(ncol(to_table(r)), 8)
})
