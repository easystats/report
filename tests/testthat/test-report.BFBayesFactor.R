skip_if_not_installed("BayesFactor")

test_that("report.BFBayesFactor - t-test", {
  # Test BFBayesFactor objects from BayesFactor package
  set.seed(123)
  rez <- BayesFactor::ttestBF(iris$Sepal.Width, iris$Sepal.Length)
  
  r <- report(rez)
  expect_s3_class(r, "character")
  expect_true(nchar(r) > 0)
  expect_true(grepl("There is", r))
  
  # Test report_statistics
  stats <- report_statistics(rez)
  expect_s3_class(stats, "character") 
  expect_true(grepl("BF", stats))
})

test_that("report.BFBayesFactor - correlation", {
  skip_if_not_installed("BayesFactor")
  
  set.seed(123)
  rez <- BayesFactor::correlationBF(iris$Sepal.Width, iris$Sepal.Length)
  
  r <- report(rez)
  expect_s3_class(r, "character")
  expect_true(nchar(r) > 0)
  expect_true(grepl("There is", r))
  
  # Test report_statistics
  stats <- report_statistics(rez)
  expect_s3_class(stats, "character")
  expect_true(grepl("BF", stats))
})

test_that("report.BFBayesFactor - custom hypotheses names", {
  skip_if_not_installed("BayesFactor")
  
  set.seed(123)
  rez <- BayesFactor::ttestBF(iris$Sepal.Width, iris$Sepal.Length)
  
  r <- report(rez, h0 = "the null hypothesis", h1 = "the alternative")
  expect_s3_class(r, "character")
  expect_true(grepl("the null hypothesis", r) || grepl("the alternative", r))
})