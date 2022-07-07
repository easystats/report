if (require("testthat") && require("report") && require("survival")) {
  test_that("report-survreg", {
    # model
    set.seed(123)
    mod_survreg <-
      survival::survreg(
        formula = Surv(futime, fustat) ~ ecog.ps + rx,
        data = ovarian,
        dist = "logistic"
      )

    expect_snapshot(variant = .Platform$OS.type, report(mod_survreg))
  })
}
