skip_if_not_or_load_if_installed("lme4")

test_that("report-lmer", {
  df <- lme4::sleepstudy
  set.seed(123)
  df$mygrp <- sample(1:5, size = 180, replace = TRUE)
  df$mysubgrp <- NA
  for (i in 1:5) {
    filter_group <- df$mygrp == i
    df$mysubgrp[filter_group] <-
      sample(1:30, size = sum(filter_group), replace = TRUE)
  }

  set.seed(123)
  m1 <- lme4::lmer(Reaction ~ Days + (1 + Days | Subject), data = df)

  set.seed(123)
  m2 <- lme4::lmer(Reaction ~ Days + (1 | mygrp / mysubgrp) + (1 | Subject), data = df)

  expect_snapshot(variant = "windows", report(m1))

  expect_snapshot(variant = "windows", report(m2))
})
