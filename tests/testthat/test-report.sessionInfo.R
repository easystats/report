
test_that("report.sessionInfo - High level", {
  x <- sessionInfo()
  r <- report(x)

  expect_true(is.character(r))
  expect_true(is.character(summary(r)))
  expect_true(as.report_text(r) == r)
  expect_true(as.report_text(r, summary = TRUE) == summary(r))

  expect_equal(ncol(as.data.frame(r)), 3)
  expect_equal(ncol(as.report_table(r)), 3)
  expect_equal(ncol(summary(as.data.frame(r))), 2)
  expect_equal(ncol(as.report_table(r, summary = TRUE)), 2)
})


test_that("report.sessionInfo - Core", {
  x <- sessionInfo()

  r <- report_table(x)
  expect_equal(ncol(r), 3)
  expect_equal(ncol(summary(r)), 2)

  r <- report_parameters(x)
  expect_true(is.character(r))
  expect_equal(length(as.character(r)), 1)
  expect_equal(length(as.character(r, prefix = "")), 1)
  expect_equal(length(as.character(summary(r))), 1)

  r <- report_text(x)
  expect_true(is.character(r))
  expect_true(is.character(summary(r)))
})


test_that("report.sessionInfo - Aliases", {
  x <- sessionInfo()
  expect_true(is.character(cite_packages(x)))
  expect_true(is.character(cite_packages(x, prefix = "")))

  expect_true(is.character(report_system(x)))
  expect_true(is.character(summary(report_system(x))))

  expect_true(is.character(report_packages(x)))
  expect_true(is.character(summary(report_packages(x))))
})
