test_that("report.htest-chi2 report", {
  m <- as.table(rbind(c(762, 327, 468), c(484, 239, 477)))
  dimnames(m) <- list(gender = c("F", "M"), party = c("Democrat", "Independent", "Republican"))
  x <- chisq.test(m)

  expect_snapshot(
    variant = "windows",
    report(x)
  )

  # Rules
  expect_snapshot(
    variant = "windows",
    report(x, rules = "funder2019")
  )

  expect_snapshot(
    variant = "windows",
    report(x, rules = "gignac2016")
  )

  expect_snapshot(
    variant = "windows",
    report(x, rules = "cohen1988")
  )

  expect_snapshot(
    variant = "windows",
    report(x, rules = "evans1996")
  )

  expect_snapshot(
    variant = "windows",
    report(x, rules = "lovakov2021")
  )

  # Types
  expect_snapshot(
    variant = "windows",
    report(x, type = "cramers_v")
  )

  expect_snapshot(
    variant = "windows",
    report(x, type = "pearsons_c")
  )

  expect_snapshot(
    variant = "windows",
    report(x, type = "tschuprows_t", adjust = FALSE)
  )

  expect_snapshot(
    variant = "windows",
    report(x, type = "tschuprows_t")
  )

  expect_snapshot(
    variant = "windows",
    report(x, type = "cohens_w")
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
    report(x, type = "phi")
  )

  expect_snapshot(
    variant = "windows",
    report(x, type = "cohens_h", rules = "sawilowsky2009")
  )

  expect_snapshot(
    variant = "windows",
    report(x, type = "riskratio")
  ) # riskratio has no interpretation in effectsize
  # Watch carefully in case effectsize adds support

  # Mattan example comparison
  x <- suppressWarnings(chisq.test(mtcars$cyl, mtcars$am))

  expect_snapshot(
    variant = "windows",
    report(x)
  )
})

test_that("report.htest-chi2 for given probabilities", {
  # Mattan example comparison
  x <- suppressWarnings(chisq.test(table(mtcars$cyl), p = c(0.1, 0.3, 0.6)))

  expect_snapshot(
    variant = "windows",
    report(x)
  )
})
