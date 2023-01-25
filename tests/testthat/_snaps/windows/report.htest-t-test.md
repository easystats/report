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
      report(t.test(mtcars$wt ~ mtcars$am))
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Welch Two Sample t-test testing the difference of mtcars$wt by mtcars$am
      (mean in group 0 = 3.77, mean in group 1 = 2.41) suggests that the effect is
      positive, statistically significant, and large (difference = 1.36, 95% CI
      [0.85, 1.86], t(29.23) = 5.49, p < .001; Cohen's d = 1.93, 95% CI [1.08, 2.77])

---

    Code
      report(t.test(mtcars$wt ~ mtcars$am, alternative = "l"))
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Welch Two Sample t-test testing the difference of mtcars$wt by mtcars$am
      (mean in group 0 = 3.77, mean in group 1 = 2.41) suggests that the effect is
      positive, statistically not significant, and large (difference = 1.36, 95% CI
      [-Inf, 1.78], t(29.23) = 5.49, p > .999; Cohen's d = 1.93, 95% CI [-Inf, 2.63])

---

    Code
      report(t.test(mtcars$wt ~ mtcars$am, alternative = "g"))
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Welch Two Sample t-test testing the difference of mtcars$wt by mtcars$am
      (mean in group 0 = 3.77, mean in group 1 = 2.41) suggests that the effect is
      positive, statistically significant, and large (difference = 1.36, 95% CI
      [0.94, Inf], t(29.23) = 5.49, p < .001; Cohen's d = 1.93, 95% CI [1.21, Inf])

---

    Code
      report(t.test(x, y, paired = TRUE))
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Paired t-test testing the difference between x and y (mean difference =
      0.43) suggests that the effect is positive, statistically significant, and
      large (difference = 0.43, 95% CI [0.10, 0.76], t(8) = 3.04, p = 0.016; Cohen's
      d = 1.01, 95% CI [0.18, 1.81])

---

    Code
      report(t.test(x, y, paired = TRUE, alternative = "l"))
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Paired t-test testing the difference between x and y (mean difference =
      0.43) suggests that the effect is positive, statistically not significant, and
      large (difference = 0.43, 95% CI [-Inf, 0.70], t(8) = 3.04, p = 0.992; Cohen's
      d = 1.01, 95% CI [-Inf, 1.67])

---

    Code
      report(t.test(x, y, paired = TRUE, alternative = "g"))
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Paired t-test testing the difference between x and y (mean difference =
      0.43) suggests that the effect is positive, statistically significant, and
      large (difference = 0.43, 95% CI [0.17, Inf], t(8) = 3.04, p = 0.008; Cohen's d
      = 1.01, 95% CI [0.30, Inf])

---

    Code
      report(t.test(sleep2$extra.1, sleep2$extra.2, paired = TRUE))
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Paired t-test testing the difference between sleep2$extra.1 and
      sleep2$extra.2 (mean difference = -1.58) suggests that the effect is negative,
      statistically significant, and large (difference = -1.58, 95% CI [-2.46,
      -0.70], t(9) = -4.06, p = 0.003; Cohen's d = -1.28, 95% CI [-2.12, -0.41])

---

    Code
      report_effectsize(x)
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations. 
      
      large (Cohen's d = -1.70, 95% CI [-2.55, -0.82])

---

    Code
      report_effectsize(x, type = "d")
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations. 
      
      large (Cohen's d = -1.70, 95% CI [-2.55, -0.82])

---

    Code
      report_effectsize(x, type = "g")
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations. 
      
      large (Hedges's g = -1.64, 95% CI [-2.46, -0.79])

---

    Code
      report_effectsize(x, rules = "cohen1988")
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations. 
      
      large (Cohen's d = -1.70, 95% CI [-2.55, -0.82])

---

    Code
      report_effectsize(x, rules = "cohen1988", type = "d")
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations. 
      
      large (Cohen's d = -1.70, 95% CI [-2.55, -0.82])

---

    Code
      report_effectsize(x, rules = "cohen1988", type = "g")
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations. 
      
      large (Hedges's g = -1.64, 95% CI [-2.46, -0.79])

---

    Code
      report_effectsize(x, rules = "sawilowsky2009")
    Output
      Effect sizes were labelled following Savilowsky's (2009) recommendations. 
      
      very large (Cohen's d = -1.70, 95% CI [-2.55, -0.82])

---

    Code
      report_effectsize(x, rules = "sawilowsky2009", type = "d")
    Output
      Effect sizes were labelled following Savilowsky's (2009) recommendations. 
      
      very large (Cohen's d = -1.70, 95% CI [-2.55, -0.82])

---

    Code
      report_effectsize(x, rules = "sawilowsky2009", type = "g")
    Output
      Effect sizes were labelled following Savilowsky's (2009) recommendations. 
      
      very large (Hedges's g = -1.64, 95% CI [-2.46, -0.79])

---

    Code
      report_effectsize(x, rules = "gignac2016")
    Output
      Effect sizes were labelled following Gignac's (2016) recommendations. 
      
      large (Cohen's d = -1.70, 95% CI [-2.55, -0.82])

---

    Code
      report_effectsize(x, rules = "gignac2016", type = "d")
    Output
      Effect sizes were labelled following Gignac's (2016) recommendations. 
      
      large (Cohen's d = -1.70, 95% CI [-2.55, -0.82])

---

    Code
      report_effectsize(x, rules = "gignac2016", type = "g")
    Output
      Effect sizes were labelled following Gignac's (2016) recommendations. 
      
      large (Hedges's g = -1.64, 95% CI [-2.46, -0.79])

