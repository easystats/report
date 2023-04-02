test_that("report-survreg", {
  skip_if_not_or_load_if_installed("survival")
  # skip_if_not_installed("survival")
  # Using namespace instead of loading the package throws an error:
  # Unable to refit the model with standardized data.
  # Try instead to standardize the data (standardize(data)) and refit the
  # model manually.

  Surv <- survival::Surv

  set.seed(123)
  mod_survreg <- survival::survreg(
    formula = Surv(futime, fustat) ~ ecog.ps + rx,
    data = survival::ovarian,
    dist = "logistic"
  )

  expect_snapshot(variant = "windows", report(mod_survreg))

  unloadNamespace("rstanarm")
  unloadNamespace("multcomp")
  unloadNamespace("TH.data")
  unloadNamespace("survival")
})
