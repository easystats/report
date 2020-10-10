context("report")


# test_that("report", {
#   r <- report(seq(0, 1, length.out = 100))
#   testthat::expect_equal(nchar(print(r, width = 10)), 50)
#   testthat::expect_is(print(r), "character")
#   testthat::expect_is(to_text(r), "character")
#   testthat::expect_is(to_fulltext(r), "character")
#   testthat::expect_true(is.report(r))
#
#   testthat::expect_is(to_table(r), "report_table")
#   testthat::expect_is(to_fulltable(r), "report_table")
#   testthat::expect_is(as.data.frame(r), "report_table")
#   testthat::expect_is(summary(r), "report_table")
#   testthat::expect_is(summary(r, digits = 2), "report_table")
#   testthat::expect_is(summary(report(iris))$n_Obs, "integer")
#
#   testthat::expect_is(as.list(r), "list")
#   testthat::expect_is(to_values(r), "list")
# })
