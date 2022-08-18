# report.htest-t-test

    Code
      report(t.test(iris$Sepal.Width, mu = 1))
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The One Sample t-test testing the difference between iris$Sepal.Width (mean =
      3.06) and mu = 1 suggests that the effect is positive, statistically
      significant, and large (difference = 2.06, 95% CI [2.99, 3.13], t(149) = 57.81,
      p < .001; Cohen's d = 4.72, 95% CI [4.15, 5.27])

---

    Code
      report(t.test(iris$Sepal.Width, mu = -1, alternative = "l"))
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The One Sample t-test testing the difference between iris$Sepal.Width (mean =
      3.06) and mu = -1 suggests that the effect is positive, statistically not
      significant, and large (difference = 4.06, 95% CI [-Inf, 3.12], t(149) =
      114.01, p > .999; Cohen's d = 9.31, 95% CI [-Inf, 10.19])

---

    Code
      report(t.test(iris$Sepal.Width, mu = 5, alternative = "g"))
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The One Sample t-test testing the difference between iris$Sepal.Width (mean =
      3.06) and mu = 5 suggests that the effect is negative, statistically not
      significant, and large (difference = -1.94, 95% CI [3.00, Inf], t(149) =
      -54.59, p > .999; Cohen's d = -4.46, 95% CI [-4.89, Inf])

---

    Code
      report(t.test(formula = wt ~ am, data = mtcars))
    Warning <simpleWarning>
      Unable to retrieve data from htest object. Using t_to_d() approximation.
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Welch Two Sample t-test testing the difference of wt by am (mean in group 0
      = 3.77, mean in group 1 = 2.41) suggests that the effect is positive,
      statistically significant, and large (difference = 1.36, 95% CI [0.85, 1.86],
      t(29.23) = 5.49, p < .001; Cohen's d = 2.03, 95% CI [1.13, 2.91])

---

    Code
      report(t.test(formula = wt ~ am, data = mtcars, alternative = "l"))
    Warning <simpleWarning>
      Unable to retrieve data from htest object. Using t_to_d() approximation.
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Welch Two Sample t-test testing the difference of wt by am (mean in group 0
      = 3.77, mean in group 1 = 2.41) suggests that the effect is positive,
      statistically not significant, and large (difference = 1.36, 95% CI [-Inf,
      1.78], t(29.23) = 5.49, p > .999; Cohen's d = 2.03, 95% CI [-Inf, 2.77])

---

    Code
      report(t.test(formula = wt ~ am, data = mtcars, alternative = "g"))
    Warning <simpleWarning>
      Unable to retrieve data from htest object. Using t_to_d() approximation.
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Welch Two Sample t-test testing the difference of wt by am (mean in group 0
      = 3.77, mean in group 1 = 2.41) suggests that the effect is positive,
      statistically significant, and large (difference = 1.36, 95% CI [0.94, Inf],
      t(29.23) = 5.49, p < .001; Cohen's d = 2.03, 95% CI [1.27, Inf])

---

    Code
      report(t.test(x, y, paired = TRUE, data = mtcars))
    Warning <simpleWarning>
      Unable to retrieve data from htest object. Using t_to_d() approximation.
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Paired t-test testing the difference between x and y (mean difference =
      0.43) suggests that the effect is positive, statistically significant, and
      large (difference = 0.43, 95% CI [0.10, 0.76], t(8) = 3.04, p = 0.016; Cohen's
      d = 1.07, 95% CI [0.19, 1.92])

---

    Code
      report(t.test(x, y, paired = TRUE, data = mtcars, alternative = "l"))
    Warning <simpleWarning>
      Unable to retrieve data from htest object. Using t_to_d() approximation.
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Paired t-test testing the difference between x and y (mean difference =
      0.43) suggests that the effect is positive, statistically not significant, and
      large (difference = 0.43, 95% CI [-Inf, 0.70], t(8) = 3.04, p = 0.992; Cohen's
      d = 1.07, 95% CI [-Inf, 1.77])

---

    Code
      report(t.test(x, y, paired = TRUE, data = mtcars, alternative = "g"))
    Warning <simpleWarning>
      Unable to retrieve data from htest object. Using t_to_d() approximation.
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Paired t-test testing the difference between x and y (mean difference =
      0.43) suggests that the effect is positive, statistically significant, and
      large (difference = 0.43, 95% CI [0.17, Inf], t(8) = 3.04, p = 0.008; Cohen's d
      = 1.07, 95% CI [0.32, Inf])

---

    Code
      report(t.test(Pair(extra.1, extra.2) ~ 1, data = sleep2))
    Warning <simpleWarning>
      Unable to retrieve data from htest object. Using t_to_d() approximation.
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Paired t-test testing the difference between Pair(extra.1, extra.2) (mean
      difference = -1.58) suggests that the effect is negative, statistically
      significant, and large (difference = -1.58, 95% CI [-2.46, -0.70], t(9) =
      -4.06, p = 0.003; Cohen's d = -1.35, 95% CI [-2.23, -0.44])

