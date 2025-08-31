skip_if_not_installed("lme4")

test_that("report-lmer", {
  df <- lme4::sleepstudy
  set.seed(123)
  df$mygrp <- sample.int(5, size = 180, replace = TRUE)
  df$mysubgrp <- NA
  for (i in 1:5) {
    filter_group <- df$mygrp == i
    df$mysubgrp[filter_group] <-
      sample.int(30, size = sum(filter_group), replace = TRUE)
  }

  set.seed(123)
  m1 <- lme4::lmer(Reaction ~ Days + (1 + Days | Subject), data = df)

  set.seed(123)
  m2 <- lme4::lmer(Reaction ~ Days + (1 | mygrp / mysubgrp) + (1 | Subject), data = df)

  expect_snapshot(variant = "windows", report(m1))

  expect_snapshot(variant = "windows", report(m2))
})

test_that("report-lmerTest-anova includes denominator df", {
  skip_if_not_installed("lmerTest")
  
  # Test case for issue #453: lmerTest ANOVA should include denominator degrees of freedom
  m <- lmerTest::lmer(mpg ~ wt + (1 | gear), data = mtcars)
  anova_result <- anova(m)
  report_output <- report(anova_result)
  
  # The report should include denominator df in F-statistic
  # Should be F(1, 21.92) not just F(1)
  expect_match(as.character(report_output), "F\\(1, [0-9.]+\\)")
  
  # Should not have the old pattern without denominator df
  expect_no_match(as.character(report_output), "F\\(1\\) =")
})
