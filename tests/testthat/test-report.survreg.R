test_that("report-survreg", {
  skip_if_not_or_load_if_installed("survival")

  set.seed(123)
  mod_survreg <- survival::survreg(
    formula = Surv(futime, fustat) ~ ecog.ps + rx,
    data = ovarian,
    dist = "logistic"
  )

  expect_snapshot(variant = "windows", report(mod_survreg))
})
