if (require("testthat") && require("report")) {

  m <- lm(formula = Sepal.Length ~ Species * Petal.Width, data = iris)

  test_that("model_table-refit", {
    mt <- model_table(m, standardize = "refit")
    expect_equal(
      mt$table_short$Std_Coefficient,
      c(0.05969, -0.16597, 0.18986, 0.85623, 0.45675, -0.25714, NA, NA, NA),
      tolerance = 1e-3
    )
    expect_equal(
      mt$table_short$Coefficient,
      c(4.77718, -0.73254, 0.49224, 0.93017, 0.49619, -0.27934, NA, NA, NA),
      tolerance = 1e-3
    )
  })

  test_that("model_table-no std", {
    mt <- model_table(m, standardize = NULL)
    expect_null(mt$table_short$Std_Coefficient)
    expect_equal(
      mt$table_short$Coefficient,
      c(4.77718, -0.73254, 0.49224, 0.93017, 0.49619, -0.27934, NA, NA, NA),
      tolerance = 1e-3
    )
  })

  test_that("model_table-posthoc", {
    mt <- model_table(m, standardize = "posthoc")
    expect_equal(
      mt$table_short$Std_Coefficient,
      c(0, -0.88464, 0.59444, 0.85623, 0.45675, -0.25714, NA, NA, NA),
      tolerance = 1e-3
    )
    expect_equal(
      mt$table_short$Coefficient,
      c(4.77718, -0.73254, 0.49224, 0.93017, 0.49619, -0.27934, NA, NA, NA),
      tolerance = 1e-3
    )
  })

}