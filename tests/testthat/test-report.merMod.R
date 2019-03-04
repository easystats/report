context("report.merMod")

test_that("report.merMod", {
  library(circus)

  r <- report(circus::download_model("lmerMod_1"))
  testthat::expect_equal(r$values$parameters$cyl$beta, 0.404, tol = 0.01)
  testthat::expect_equal(ncol(to_table(r)), 7)

  r <- report(circus::download_model("lmerMod_1"), bootstrap = TRUE, n = 50)
  testthat::expect_equal(r$values$parameters$cyl$Median, 0.404, tol = 0.25)

  # r <- report(circus::download_model("merMod_1"))
  # testthat::expect_equal(r$values$parameters$cyl$beta, 0.404, tol = 0.01)
  # testthat::expect_equal(ncol(to_table(r)), 7)
  #
  # r <- report(circus::download_model("merMod_2"))
  # testthat::expect_equal(nrow(to_table(r)), 4)
  # testthat::expect_is(capture.output(to_table(r)), "character")
  # testthat::expect_equal(r$values$parameters$wt$beta, -3.19, tol = 0.01)

  # rename bayes 2
})
