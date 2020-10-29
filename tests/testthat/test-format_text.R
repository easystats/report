context("format_text")

test_that("format_text", {
  testthat::expect_equal(text_concatenate(c("A", "B", "C")), "A, B and C", tol = 0)

  x <- paste(rep("a very long string", 50), collapse = " \n")
  testthat::expect_equal(nchar(text_wrap(x, width = 25)), 999, tol = 0)
})
