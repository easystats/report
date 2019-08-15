context("report.lm")

test_that("report.lm", {
  r <- report(insight::download_model("lm_0"))
  testthat::expect_equal(c(ncol(to_table(r)), nrow(to_table(r))), c(7, 4))
  testthat::expect_is(capture.output(to_table(r)), "character")

  r <- report(insight::download_model("lm_1"))
  testthat::expect_equal(r$values$wt$Coefficient, -5.344, tol = 0.01)
  testthat::expect_equal(ncol(to_table(r)), 7)

  r <- report(insight::download_model("lm_1"), bootstrap = TRUE, n = 500)
  testthat::expect_equal(r$values$wt$Coefficient, -5.35, tol = 0.2)

  r <- report(insight::download_model("lm_2"), effsize = NULL)
  testthat::expect_equal(c(ncol(to_table(r)), nrow(to_table(r))), c(7, 6))
  testthat::expect_is(capture.output(to_table(r)), "character")
  testthat::expect_equal(r$values$wt$Coefficient, -3.19, tol = 0.01)

  r <- report(insight::download_model("lm_3"), standardize = FALSE)
  testthat::expect_equal(c(ncol(to_table(r)), nrow(to_table(r))), c(6, 7))
  testthat::expect_is(capture.output(to_table(r)), "character")
  testthat::expect_equal(r$values$wt$Coefficient, -8.6555, tol = 0.01)

  r <- report(insight::download_model("lm_4"))
  testthat::expect_equal(c(ncol(to_table(r)), nrow(to_table(r))), c(7, 7))
  testthat::expect_is(capture.output(to_table(r)), "character")

  r <- report(insight::download_model("lm_5"))
  testthat::expect_equal(c(ncol(to_table(r)), nrow(to_table(r))), c(7, 7))
  testthat::expect_is(capture.output(to_table(r)), "character")
  testthat::expect_equal(r$values$wt$Coefficient, -3.2056, tol = 0.01)
})


context("report.glm")

test_that("report.glm", {
  r <- report(insight::download_model("glm_1"))
  testthat::expect_equal(r$values$wt$Coefficient, -1.91, tol = 0.01)
  testthat::expect_equal(c(ncol(to_table(r)), nrow(to_table(r))), c(7, 4))

  r <- report(insight::download_model("glm_1"), bootstrap = TRUE, iterations = 499)
  testthat::expect_equal(r$values$wt$Coefficient, -2.08, tol = 0.8)
  testthat::expect_equal(c(ncol(to_table(r)), nrow(to_table(r))), c(7, 4))

  r <- report(insight::download_model("glm_2"))
  testthat::expect_equal(c(ncol(to_table(r)), nrow(to_table(r))), c(7, 5))
  testthat::expect_is(capture.output(to_table(r)), "character")
  testthat::expect_equal(r$values$wt$Coefficient, 2.1, tol = 0.1)

  testthat::expect_warning(report(insight::download_model("glm_2"), ci = c(0.5, 0.9)))
})
