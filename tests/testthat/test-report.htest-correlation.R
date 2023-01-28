test_that("report.htest-correlation", {
  set.seed(123)
  r <- report(cor.test(iris$Sepal.Width, iris$Sepal.Length))
  expect_equal(as.report_table(r)$r, -0.117, tolerance = 0.01)

  set.seed(123)
  r <- cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "spearman", exact = FALSE)
  r <- report(r)
  expect_equal(as.report_table(r)$rho, -0.166, tolerance = 0.01)

  set.seed(123)
  r <- report(cor.test(iris$Sepal.Width, iris$Sepal.Length, method = "kendall"))
  expect_equal(as.report_table(r)$tau, -0.077, tolerance = 0.01)

  # snapshot tests with a different dataset
  set.seed(123)
  expect_snapshot(variant = "windows", report(cor.test(mtcars$wt, mtcars$mpg)))

  set.seed(123)
  expect_snapshot(variant = "windows", report(cor.test(mtcars$wt, mtcars$mpg, method = "spearman")))

  set.seed(123)
  expect_snapshot(variant = "windows", report(cor.test(mtcars$wt, mtcars$mpg, method = "kendall")))
})
