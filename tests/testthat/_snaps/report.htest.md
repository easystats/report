# report.htest

    Code
      report(cor.test(iris$Sepal.Width, iris$Sepal.Length))
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Pearson's product-moment correlation between iris$Sepal.Width and iris$Sepal.Length is negative, not significant and small (r = -0.12, 95% CI [-0.27, 0.04], t(148) = -1.44, p = 0.152)

---

    Code
      report(t.test(iris$Sepal.Width, mu = 1))
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The One Sample t-test testing the difference between iris$Sepal.Width (mean = 3.06) and mu = 1 suggests that the effect is positive, significant and large (difference = 2.06, 95% CI [2.99, 3.13], t(149) = 57.81, p < .001; Cohen's d = 4.72, 95% CI [4.17, 5.29])

