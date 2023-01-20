test_that("report.sessionInfo - High level", {
  x <- sessionInfo()
  r <- report(x)

  expect_type(r, "character")
  expect_type(summary(r), "character")
  expect_equal(as.report_text(r), r, ignore_attr = TRUE)
  expect_identical(as.report_text(r, summary = TRUE), summary(r))

  expect_equal(ncol(as.data.frame(r)), 3, ignore_attr = TRUE)
  expect_equal(ncol(as.report_table(r)), 3, ignore_attr = TRUE)
  expect_equal(ncol(summary(as.data.frame(r))), 2, ignore_attr = TRUE)
  expect_equal(ncol(as.report_table(r, summary = TRUE)), 2, ignore_attr = TRUE)
})


test_that("report.sessionInfo - Core", {
  x <- sessionInfo()

  r <- report_table(x)
  expect_equal(ncol(r), 3, ignore_attr = TRUE)
  expect_equal(ncol(summary(r)), 2, ignore_attr = TRUE)

  r <- report_parameters(x)
  expect_type(r, "character")
  expect_length(as.character(r), 1)
  expect_length(as.character(r), 1)
  expect_length(as.character(summary(r)), 1)

  r <- report_text(x)
  expect_type(r, "character")
  expect_type(summary(r), "character")
})


test_that("report.sessionInfo - Aliases", {
  x <- sessionInfo()
  expect_type(cite_packages(x), "character")
  expect_type(cite_packages(x, prefix = ""), "character")

  expect_type(report_system(x), "character")
  expect_type(summary(report_system(x)), "character")

  expect_type(report_packages(x), "character")
  expect_type(summary(report_packages(x)), "character")
})
