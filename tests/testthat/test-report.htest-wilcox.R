# skip for now
test_that("report.htest-wilcox", {
  # paired wilcox test ---------------------

  x <<- c(1.83, 0.50, 1.62, 2.48, 1.68, 1.88, 1.55, 3.06, 1.30)
  y <<- c(0.878, 0.647, 0.598, 2.05, 1.06, 1.29, 1.06, 3.14, 1.29)
  expect_snapshot(variant = "windows", report(wilcox.test(x, y, paired = TRUE, data = mtcars)))

  expect_snapshot(variant = "windows", report(wilcox.test(x, y, paired = TRUE, data = mtcars, alternative = "l")))

  expect_snapshot(variant = "windows", report(wilcox.test(x, y, paired = TRUE, data = mtcars, alternative = "g")))

  # unpaired wilcox test ---------------------

  expect_snapshot(variant = "windows", report(wilcox.test(mtcars$am, mtcars$wt, exact = FALSE)))

  expect_snapshot(variant = "windows", report(wilcox.test(mtcars$am, mtcars$wt, alternative = "l", exact = FALSE)))

  expect_snapshot(variant = "windows", report(wilcox.test(mtcars$am, mtcars$mpg, exact = FALSE, correct = FALSE)))

  # one-sample wilcox test ---------------------

  depression <<- data.frame(first = x, second = y, change = y - x)
  expect_snapshot(variant = "windows", report(wilcox.test(depression$change, mu = 1)))
})
