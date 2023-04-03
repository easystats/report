test_that("report-survreg", {
  skip_if_not_installed("survival")
  require("survival", quietly = TRUE)

  # TODO: Use namespace when https://github.com/easystats/datawizard/issues/401 is resolved
  set.seed(123)
  mod_survreg <- survreg(
    formula = Surv(futime, fustat) ~ ecog.ps + rx,
    data = ovarian,
    dist = "logistic"
  )

  expect_snapshot(variant = "windows", report(mod_survreg))

  unloadNamespace("rstanarm")
  unloadNamespace("multcomp")
  unloadNamespace("TH.data")
  unloadNamespace("survival")
})
