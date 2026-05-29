test_that("report.htest-kruskal report", {
  x <- kruskal.test(airquality$Ozone ~ as.factor(airquality$Month))

  set.seed(100)
  expect_snapshot(
    variant = "windows",
    report(x, verbose = FALSE)
  )
})

test_that("report.htest-kruskal degenerate case (one observation per group)", {
  # Test case from issue #454: one observation per group causes CI calculation to fail
  n <- 10
  set.seed(123)
  df <- data.frame(a = as.factor(1:n), b = rnorm(n))
  # Use the formula interface to allow effectsize to retrieve data
  test <- kruskal.test(b ~ a, data = df)
  
  # Should not fail and should complete quickly - provide data manually
  expect_no_error({
    result <- report(test, data = df, verbose = FALSE)
  })
  
  # Result should contain effect size but no CI due to degenerate case
  result <- report(test, data = df, verbose = FALSE)
  result_text <- as.character(result)
  expect_true(grepl("Epsilon squared \\(rank\\) = 1\\.00", result_text))
  expect_false(grepl("95% CI", result_text))  # No CI should be present
})
