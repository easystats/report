skip_if_not_installed("BayesFactor")

test_that("report.BFBayesFactor - t-test", {
  # Test BFBayesFactor objects from BayesFactor package
  set.seed(123)
  rez <- BayesFactor::ttestBF(iris$Sepal.Width, iris$Sepal.Length)

  r <- report(rez)
  expect_type(r, "character")
  expect_true(nzchar(r))
  expect_true(grepl("There is", r, fixed = TRUE))

  # Test report_statistics
  stats <- report_statistics(rez)
  expect_type(stats, "character")
  expect_true(grepl("BF", stats, fixed = TRUE))
})

test_that("report.BFBayesFactor - correlation", {
  skip_if_not_installed("BayesFactor")

  set.seed(123)
  rez <- BayesFactor::correlationBF(iris$Sepal.Width, iris$Sepal.Length)

  r <- report(rez)
  expect_type(r, "character")
  expect_true(nzchar(r))
  expect_true(grepl("There is", r, fixed = TRUE))

  # Test report_statistics
  stats <- report_statistics(rez)
  expect_type(stats, "character")
  expect_true(grepl("BF", stats, fixed = TRUE))
})

test_that("report.BFBayesFactor - custom hypotheses names", {
  skip_if_not_installed("BayesFactor")

  set.seed(123)
  rez <- BayesFactor::ttestBF(iris$Sepal.Width, iris$Sepal.Length)

  r <- report(rez, h0 = "the null hypothesis", h1 = "the alternative")
  expect_type(r, "character")
  expect_true(grepl("the null hypothesis", r, fixed = TRUE) || grepl("the alternative", r, fixed = TRUE))
})
