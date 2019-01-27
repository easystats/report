context("format_text_collapse")

test_that("format_text_collapse", {
  testthat::expect_equal(format_text_collapse(c("A", "B", "C")), "A, B and C", tol = 0)
})




context("format_text_collapse")

test_that("format_text_collapse", {
  x <- paste(rep("a very long string", 50), collapse=" \n")
  testthat::expect_equal(nchar(format_text_wrap(x, width=25)), 999, tol = 0)
})
