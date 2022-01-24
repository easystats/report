if (require("testthat") && require("report") && require("ivreg")) {
  test_that("report-survreg", {
    data("CigaretteDemand", package = "ivreg")


    # model
    set.seed(123)
    ivr <-
      ivreg(log(packs) ~ log(rprice) + log(rincome) | salestax + log(rincome),
        data = CigaretteDemand
      )

    expect_snapshot(variant = .Platform$OS.type, report(ivr))
  })
}
