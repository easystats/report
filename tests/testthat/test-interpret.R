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
  testthat::expect_equal(interpret_r(0.21), "medium")
  testthat::expect_equal(interpret_r(0.21, rules = "cohen1988"), "small")
  testthat::expect_equal(interpret_r(0.7, rules = "evans1996"), "strong")
  testthat::expect_equal(interpret_r(c(0.5, -0.08), rules = "cohen1988"), c("large", "very small"))
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
  testthat::expect_equal(interpret_d(0.021), "tiny")
  testthat::expect_equal(interpret_d(1.3, rules = "sawilowsky2009"), "very large")
  testthat::expect_equal(interpret_d(c(0.45, 0.85)), c("medium", "large"), rules = "cohen1988")
  testthat::expect_equal(interpret_d(0.6, rules = rules(c(0.5), c("A", "B"))), "B")
  testthat::expect_error(interpret_d(0.6, rules = "DUPA"))
})



context("interpret_rope")
test_that("interpret_rope", {
  testthat::expect_equal(interpret_rope(0, ci = 0.9), "significant")
  testthat::expect_equal(interpret_rope(c(0.50, 1), ci = 0.9), c("not significant", "negligible"))
  testthat::expect_equal(interpret_rope(c(0.98, 0.991), ci = 1), c("probably negligible", "negligible"))
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


context("interpret_bf")
test_that("interpret_bf", {
  testthat::expect_equal(interpret_bf(-2), "no evidence against")
  testthat::expect_equal(interpret_bf(c(0.8, 3.5), rules = "jeffreys1961"), c("anecdotal evidence against", "moderate evidence in favour of"))
  testthat::expect_equal(interpret_bf(c(0.8, 3.5), rules = "raftery1995"), c("weak evidence against", "positive evidence in favour of"))
  testthat::expect_equal(interpret_bf(2, rules = rules(c(0.5), c("A", "B"))), "B evidence in favour of")
  testthat::expect_error(interpret_bf(2, rules = "DUPA"))
})



context("interpret_omega_squared")
test_that("interpret_omega_squared", {
  testthat::expect_equal(interpret_omega_squared(0.1), "medium")
  testthat::expect_equal(interpret_omega_squared(c(0.1, 0.25)), c("medium", "large"))
  testthat::expect_equal(interpret_omega_squared(0.6, rules = rules(c(0.5), c("A", "B"))), "B")
  testthat::expect_error(interpret_omega_squared(0.6, rules = "DUPA"))
})



context("interpret_rhat")
test_that("interpret_rhat", {
  testthat::expect_equal(interpret_rhat(1), "converged")
  testthat::expect_equal(interpret_rhat(c(1, 1.02)), c("converged", "failed"))
  testthat::expect_equal(interpret_rhat(c(1, 1.02), rules = "gelman1992"), c("converged", "converged"))
  testthat::expect_equal(interpret_rhat(0.6, rules = rules(c(0.5), c("A", "B"))), "B")
  testthat::expect_error(interpret_rhat(0.6, rules = "DUPA"))
})


context("interpret_effective_sample")
test_that("interpret_effective_sample", {
  testthat::expect_equal(interpret_effective_sample(1000), "sufficient")
  testthat::expect_equal(interpret_effective_sample(c(1000, 800)), c("sufficient", "unsufficient"))
  testthat::expect_equal(interpret_effective_sample(0.6, rules = rules(c(0.5), c("A", "B"))), "B")
  testthat::expect_error(interpret_effective_sample(0.6, rules = "DUPA"))
})
