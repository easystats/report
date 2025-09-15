skip_if_not_installed("performance")

test_that("report.compare_performance", {
  # Create test models
  m1 <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
  m2 <- lm(Sepal.Length ~ Petal.Length + Species, data = iris)
  m3 <- lm(Sepal.Length ~ Petal.Length, data = iris)
  
  x <- performance::compare_performance(m1, m2, m3)
  
  # Test main report function
  r <- report(x)
  expect_s3_class(r, "report")
  expect_s3_class(summary(r), "character")
  expect_s3_class(as.data.frame(r), c("report_table", "data.frame"))
  
  # Test report_table
  rt <- report_table(x)
  expect_s3_class(rt, c("report_table", "data.frame"))
  expect_true(nrow(rt) == 3)
  
  # Test report_statistics
  rs <- report_statistics(x)
  expect_s3_class(rs, "character")
  expect_true(nchar(rs[[1]]) > 0)
  
  # Test report_parameters
  rp <- report_parameters(x)
  expect_s3_class(rp, "character")
  expect_true(nchar(rp[[1]]) > 0)
  
  # Test report_text
  rt <- report_text(x)
  expect_s3_class(rt, c("report_text", "character"))
  expect_true(nchar(rt) > 0)
  expect_true(grepl("compared", rt))
})