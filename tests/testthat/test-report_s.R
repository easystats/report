test_that("report_s", {
  expect_snapshot(report_s(s = 4.2), variant = "windows")
  expect_snapshot(report_s(p = 0.06), variant = "windows")
})

test_that("report_s, arguments", {
  expect_error(report_s())
  expect_error(report_s(s = 1:2), "single value")
})
