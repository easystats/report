skip_if_not_or_load_if_installed("ivreg")
test_that("report-survreg", {
  data("CigaretteDemand", package = "ivreg")

  # model
  set.seed(123)
  ivr <-
    ivreg(log(packs) ~ log(rprice) + log(rincome) | salestax + log(rincome),
      data = CigaretteDemand
    )

  expect_snapshot(variant = "windows", report(ivr))
})
