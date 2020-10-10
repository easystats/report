if (require("testthat") &&
  require("report") &&
  require("lme4")) {
  data(sleepstudy)
  set.seed(123)
  sleepstudy$mygrp <- sample(1:5, size = 180, replace = TRUE)
  sleepstudy$mysubgrp <- NA
  for (i in 1:5) {
    filter_group <- sleepstudy$mygrp == i
    sleepstudy$mysubgrp[filter_group] <-
      sample(1:30, size = sum(filter_group), replace = TRUE)
  }

  m1 <- lme4::lmer(Reaction ~ Days + (1 + Days | Subject),
    data = sleepstudy
  )

  m2 <- lme4::lmer(Reaction ~ Days + (1 | mygrp / mysubgrp) + (1 | Subject),
    data = sleepstudy
  )

  test_that("report-lmer-1", {
    r <- report(m1)
    expect_equal(nchar(r$texts$text_short), 566)
    expect_equal(nchar(r$texts$text_long), 871)
    expect_equal(nrow(r$tables$table_short), 5)
    expect_equal(nrow(r$tables$table_long), 9)
    expect_equal(r$tables$table_long$Coefficient, c(251.4051, 10.46729, NA, NA, NA, NA, NA, NA, NA), tolerance = 1e-3)
    expect_equal(r$tables$table_long$Parameter, c(
      "(Intercept)", "Days", NA, "AIC", "BIC", "R2 (conditional)",
      "R2 (marginal)", "ICC", "RMSE"
    ))
  })

  test_that("report-lmer-2", {
    r <- report(m2)
    expect_equal(nchar(r$texts$text_short), 516)
    expect_equal(nchar(r$texts$text_long), 878)
    expect_equal(nrow(r$tables$table_short), 4)
    expect_equal(nrow(r$tables$table_long), 7)
    expect_equal(r$tables$table_long$Coefficient, c(252.09404, 10.35368, NA, NA, NA, NA, NA), tolerance = 1e-3)
    expect_equal(r$tables$table_long$Parameter, c("(Intercept)", "Days", NA, "AIC", "BIC", "R2 (marginal)", "RMSE"))
  })
}
