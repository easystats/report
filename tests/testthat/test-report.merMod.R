context("report.merMod")

test_that("report.merMod", {
  library(lme4)

  r <- report(insight::download_model("lmerMod_1"))
  testthat::expect_equal(r$values$cyl$Coefficient, 0.404, tol = 0.01)
  testthat::expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(5, 7))

  r <- report(insight::download_model("lmerMod_1"), bootstrap = TRUE, iterations = 50)
  testthat::expect_equal(r$values$cyl$Coefficient, 0.404, tol = 0.25)
  testthat::expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(5, 7))

  r <- report(insight::download_model("merMod_1"))
  testthat::expect_equal(r$values$cyl$Coefficient, -2.13265, tol = 0.01)
  testthat::expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(5, 7))

  r <- report(insight::download_model("merMod_2"))
  testthat::expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(6, 7))
  testthat::expect_is(capture.output(to_table(r)), "character")
  testthat::expect_equal(r$values$cyl$Coefficient, -4.77, tol = 0.01)
})
