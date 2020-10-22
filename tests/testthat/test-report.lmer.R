if (require("testthat") && require("report") && require("lme4")) {

  df <- lme4::sleepstudy
  set.seed(123)
  df$mygrp <- sample(1:5, size = 180, replace = TRUE)
  df$mysubgrp <- NA
  for (i in 1:5) {
    filter_group <- df$mygrp == i
    df$mysubgrp[filter_group] <-
      sample(1:30, size = sum(filter_group), replace = TRUE)
  }

  m1 <- lme4::lmer(Reaction ~ Days + (1 + Days | Subject), data = df)
  m2 <- lme4::lmer(Reaction ~ Days + (1 | mygrp / mysubgrp) + (1 | Subject), data = df)

  test_that("report-lmer-1", {
    r <- report(m1)
    expect_equal(as.data.frame(r)$Coefficient[1:3], c(251.4051, 10.46729, NA), tolerance = 1e-3)
    expect_equal(as.data.frame(r)$Parameter[1:3], c("(Intercept)", "Days", NA))
  })

  test_that("report-lmer-2", {
    r <- report(m2)
    expect_equal(as.data.frame(r)$Coefficient[1:3], c(252.09404, 10.35368, NA), tolerance = 1e-3)
    expect_equal(as.data.frame(r)$Parameter[1:3], c("(Intercept)", "Days", NA))
  })
}
