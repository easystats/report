context("report.")


test_that("report", {
  r <- report(seq(0, 1, length.out = 100))
  testthat::expect_is(print(r), "character")
  testthat::expect_is(r$text_full, "character")
  testthat::expect_true(is.report(r))
})

