test_that("report.htest-kruskal report", {
  x <- kruskal.test(airquality$Ozone ~ as.factor(airquality$Month))

  set.seed(100)
  expect_snapshot(
    variant = "windows",
    report(x, verbose = FALSE)
  )
})
