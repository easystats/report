# report.htest-wilcox

    Code
      report(wilcox.test(x, y, paired = TRUE, data = mtcars))
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Wilcoxon signed rank exact test testing the difference in ranks between x
      and y suggests that the effect is positive, statistically significant, and very
      large (W = 40.00, p = 0.039; r (rank biserial) = 0.78, 95% CI [0.30, 0.94])

---

    Code
      report(wilcox.test(x, y, paired = TRUE, data = mtcars, alternative = "l"))
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Wilcoxon signed rank exact test testing the difference in ranks between x
      and y suggests that the effect is positive, statistically not significant, and
      very large (W = 40.00, p = 0.986; r (rank biserial) = 0.78, 95% CI [-1.00,
      0.93])

---

    Code
      report(wilcox.test(x, y, paired = TRUE, data = mtcars, alternative = "g"))
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Wilcoxon signed rank exact test testing the difference in ranks between x
      and y suggests that the effect is positive, statistically significant, and very
      large (W = 40.00, p = 0.020; r (rank biserial) = 0.78, 95% CI [0.40, 1.00])

---

    Code
      report(wilcox.test(mtcars$am, mtcars$wt, exact = FALSE))
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Wilcoxon rank sum test with continuity correction testing the difference in
      ranks between mtcars$am and mtcars$wt suggests that the effect is negative,
      statistically significant, and very large (W = 0.00, p < .001; r (rank
      biserial) = -1.00, 95% CI [-1.00, -1.00])

---

    Code
      report(wilcox.test(mtcars$am, mtcars$wt, alternative = "l", exact = FALSE))
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Wilcoxon rank sum test with continuity correction testing the difference in
      ranks between mtcars$am and mtcars$wt suggests that the effect is negative,
      statistically significant, and very large (W = 0.00, p < .001; r (rank
      biserial) = -1.00, 95% CI [-1.00, -1.00])

---

    Code
      report(wilcox.test(mtcars$am, mtcars$mpg, exact = FALSE, correct = FALSE))
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Wilcoxon rank sum test testing the difference in ranks between mtcars$am
      and mtcars$mpg suggests that the effect is negative, statistically significant,
      and very large (W = 0.00, p < .001; r (rank biserial) = -1.00, 95% CI [-1.00,
      -1.00])

---

    Code
      report(wilcox.test(depression$change, mu = 1))
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Wilcoxon signed rank exact test testing the difference in rank for
      depression$change and true location of 0 suggests that the effect is negative,
      statistically significant, and very large (W = 0.00, p = 0.004; r (rank
      biserial) = -1.00, 95% CI [-1.00, -1.00])

