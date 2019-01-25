context("interpret")
test_that("interpret", {
  rules_grid <- rules(c(0.01, 0.05), c("very significant", "significant", "not significant"))
  testthat::expect_equal(interpret(0.001, rules_grid), "very significant")
  testthat::expect_equal(interpret(0.021, rules_grid), "significant")
  testthat::expect_equal(interpret(0.08, rules_grid), "not significant")
  testthat::expect_equal(interpret(c(0.01, 0.005, 0.08), rules_grid), c("significant", "very significant", "not significant"))
})


context("interpret_r")
test_that("interpret_r", {
  testthat::expect_equal(interpret_r(0.21), "positive and small")
  testthat::expect_equal(interpret_r(0.7, rules = "evans1996"), "positive and strong")
  testthat::expect_equal(interpret_r(c(0.5, -0.08)), c("positive and large", "negative and very small"))
})



context("interpret_p")
test_that("interpret_p", {
  testthat::expect_equal(interpret_p(0.021), "significant")
  testthat::expect_equal(interpret_p(0.08), "not significant")
  testthat::expect_equal(interpret_p(c(0.01, 0.08)), c("significant", "not significant"))
})


context("interpret_direction")
test_that("interpret_direction", {
  testthat::expect_equal(interpret_direction(c(0.01, -0.08)), c("positive", "negative"))
})
