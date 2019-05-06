context("report.merMod")

test_that("report.merMod", {

  r <- report(insight::download_model("lmerMod_1"))
  testthat::expect_equal(r$values$parameters$cyl$beta, 0.404, tol = 0.01)
  testthat::expect_equal(ncol(to_table(r)), 7)

  # Probblem with singular fits
  # r <- report(insight::download_model("lmerMod_1"), bootstrap = TRUE, n = 50)
  # testthat::expect_equal(r$values$parameters$cyl$Median, 0.404, tol = 0.25)

  r <- report(insight::download_model("merMod_1"))
  testthat::expect_equal(r$values$parameters$cyl$beta, -2.13265, tol = 0.01)
  testthat::expect_equal(ncol(to_table(r)), 7)

  r <- report(insight::download_model("merMod_2"))
  testthat::expect_equal(nrow(to_table(r)), 6)
  testthat::expect_is(capture.output(to_table(r)), "character")
  testthat::expect_equal(r$values$parameters$cyl$beta, -4.77, tol = 0.01)

  # rename bayes 2
})
