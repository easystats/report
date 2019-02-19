context("interpret")
test_that("interpret", {
  rules_grid <- rules(c(0.01, 0.05), c("very significant", "significant", "not significant"))
  testthat::expect_equal(interpret(0.001, rules_grid), "very significant")
  testthat::expect_equal(interpret(0.021, rules_grid), "significant")
  testthat::expect_equal(interpret(0.08, rules_grid), "not significant")
  testthat::expect_equal(interpret(c(0.01, 0.005, 0.08), rules_grid), c("significant", "very significant", "not significant"))
  testthat::expect_error(interpret_r(0.6, rules = rules(c(0.5), c("A", "B", "C"))))
  testthat::expect_error(interpret_r(0.6, rules = rules(c(0.5, 0.2, 0.7), c("A", "B", "C", "D"))))
})


context("interpret_r")
test_that("interpret_r", {
  testthat::expect_equal(interpret_r(0.21), "positive and small")
  testthat::expect_equal(interpret_r(0.7, rules = "evans1996"), "positive and strong")
  testthat::expect_equal(interpret_r(c(0.5, -0.08)), c("positive and large", "negative and very small"))
  testthat::expect_equal(interpret_r(0.6, rules = rules(c(0.5), c("A", "B"))), "B")
  testthat::expect_error(interpret_r(0.6, rules = "DUPA"))
})



context("interpret_p")
test_that("interpret_p", {
  testthat::expect_equal(interpret_p(0.021), "significant")
  testthat::expect_equal(interpret_p(0.08), "not significant")
  testthat::expect_equal(interpret_p(c(0.01, 0.08)), c("significant", "not significant"))
  testthat::expect_equal(interpret_p(0.6, rules = rules(c(0.5), c("A", "B"))), "B")
  testthat::expect_error(interpret_p(0.6, rules = "DUPA"))
})


context("interpret_direction")
test_that("interpret_direction", {
  testthat::expect_equal(interpret_direction(c(0.01, -0.08)), c("positive", "negative"))
})


context("interpret_d")
test_that("interpret_d", {
  testthat::expect_equal(interpret_d(0.021), "very small")
  testthat::expect_equal(interpret_d(0.6), "medium")
  testthat::expect_equal(interpret_d(1.3, rules = "sawilowsky2009"), "very large")
  testthat::expect_equal(interpret_d(c(0.45, 0.85)), c("small", "large"))
  testthat::expect_equal(interpret_d(0.6, rules = rules(c(0.5), c("A", "B"))), "B")
  testthat::expect_error(interpret_d(0.6, rules = "DUPA"))
})



context("interpret_rope")
test_that("interpret_rope", {
  testthat::expect_equal(interpret_rope(0, ci = 0.9), "significant")
  testthat::expect_equal(interpret_rope(c(50, 100), ci = 0.9), c("not significant", "negligible"))
  testthat::expect_equal(interpret_rope(c(98, 99.1), ci = 1), c("probably negligible", "negligible"))
  testthat::expect_equal(interpret_rope(0.6, rules = rules(c(0.5), c("A", "B"))), "B")
  testthat::expect_error(interpret_rope(0.6, rules = "DUPA"))
})


context("interpret_odds")
test_that("interpret_odds", {
  testthat::expect_equal(interpret_odds(2), "small")
  testthat::expect_equal(interpret_odds(c(1, 3)), c("very small", "small"))
  testthat::expect_equal(interpret_odds(c(1, 3), rules = "cohen1988"), c("very small", "medium"))
  testthat::expect_equal(interpret_odds(0.6, rules = rules(c(0.5), c("A", "B"))), "B")
  testthat::expect_error(interpret_odds(0.6, rules = "DUPA"))
})


context("interpret_r2")
test_that("interpret_r2", {
  testthat::expect_equal(interpret_r2(0.4), "substantial")
  testthat::expect_equal(interpret_r2(c(0, 0.4), rules = "falk1992"), c("negligible", "adequate"))
  testthat::expect_equal(interpret_r2(c(0.1, 0.4), rules = "chin1998"), c("very weak", "moderate"))
  testthat::expect_equal(interpret_r2(c(0.1, 0.4), rules = "hair2011"), c("very weak", "weak"))
  testthat::expect_equal(interpret_r2(0.6, rules = rules(c(0.5), c("A", "B"))), "B")
  testthat::expect_error(interpret_r2(0.6, rules = "DUPA"))
})
