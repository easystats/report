skip_if_not_installed("ivreg")

test_that("report-survreg", {
  data("CigaretteDemand", package = "ivreg")

  # model
  set.seed(123)
  ivr <-
    ivreg::ivreg(
      log(packs) ~ log(rprice) + log(rincome) | salestax + log(rincome),
      data = ivreg::CigaretteDemand
    )

  expect_snapshot(variant = "windows", report(ivr))
})
