if (require("testthat") && require("report") && require("AER")) {
  test_that("report-survreg", {
    data("CigarettesSW", package = "AER")

    # model
    set.seed(123)
    ivr <-
      AER::ivreg(
        formula = log(packs) ~ income | population,
        data = CigarettesSW
      )

    expect_snapshot(report(ivr))
  })
}
