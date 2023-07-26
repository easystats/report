test_that("report_s", {
  expect_snapshot(report_s(s = 4.2), variant = "windows")
  expect_snapshot(report_s(p = 0.06), variant = "windows")
})
