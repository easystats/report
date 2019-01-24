context("report.")


test_that("report", {
  r <- report(seq(0, 1, length.out = 100))
  testthat::expect_is(print(r), "character")
  testthat::expect_is(to_text(r), "character")
  testthat::expect_is(to_fulltext(r), "character")
  testthat::expect_true(is.report(r))

  testthat::expect_is(to_table(r), "data.frame")
  testthat::expect_is(to_fulltable(r), "data.frame")
  testthat::expect_is(as.data.frame(r), "data.frame")
  testthat::expect_is(summary(r), "data.frame")
})
