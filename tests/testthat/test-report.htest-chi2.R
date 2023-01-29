test_that("report.htest-chi2", {
  M <- as.table(rbind(c(762, 327, 468), c(484, 239, 477)))
  dimnames(M) <- list(gender = c("F", "M"), party = c("Democrat", "Independent", "Republican"))
  x <- chisq.test(M)

  expect_snapshot(
    variant = "windows",
    report_effectsize(x)
  )

  # Rules
  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "funder2019")
  )

  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "gignac2016")
  )

  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "cohen1988")
  )

  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "evans1996")
  )

  expect_snapshot(
    variant = "windows",
    report_effectsize(x, rules = "lovakov2021")
  )

  # Types
  expect_snapshot(
    variant = "windows",
    report_effectsize(x, type = "cramers_v")
  )

  expect_snapshot(
    variant = "windows",
    report_effectsize(x, type = "pearsons_c")
  )

  expect_snapshot(
    variant = "windows",
    report_effectsize(x, type = "tschuprows_t")
  )

  expect_snapshot(
    variant = "windows",
    report_effectsize(x, type = "cohens_w")
  )

  # Change dataset for "Error: Phi is not appropriate for non-2x2 tables."
  dat <- structure(
    c(71, 50, 30, 100),
    dim = c(2L, 2L), dimnames = list(
      Diagnosis = c("Sick", "Recovered"),
      Group = c("Treatment", "Control")
    ),
    class = "table"
  )
  x <- chisq.test(dat)

  expect_snapshot(
    variant = "windows",
    report_effectsize(x, type = "phi")
  )

  expect_snapshot(
    variant = "windows",
    report_effectsize(x, type = "cohens_h", rules = "sawilowsky2009")
  )

  expect_snapshot(
    variant = "windows",
    report_effectsize(x, type = "oddsratio", rules = "chen2010")
  )

  expect_snapshot(
    variant = "windows",
    report_effectsize(x, type = "riskratio")
  ) # riskratio has no interpretation in effectsize
  # Watch carefully in case effectsize adds support
})
