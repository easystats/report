test_that("report-survreg", {
  skip_if_not_installed("survival")
  set.seed(123)
  mod_survreg <- survival::survreg(
    formula = survival::Surv(futime, fustat) ~ ecog.ps + rx,
    data = survival::ovarian,
    dist = "logistic"
  )

  expect_snapshot(variant = "windows", report(mod_survreg))

  unloadNamespace("rstanarm")
  unloadNamespace("multcomp")
  unloadNamespace("TH.data")
  unloadNamespace("survival")
})
