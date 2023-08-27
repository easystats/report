test_that("report.htest-friendman report", {
  wb <- aggregate(warpbreaks$breaks,
                  by = list(w = warpbreaks$wool,
                            t = warpbreaks$tension),
                  FUN = mean)
  x <- friedman.test(wb$x, wb$w, wb$t)

  expect_snapshot(
    variant = "windows",
    report(x)
  )

})
