# report.htest-correlation

    Code
      report(cor.test(mtcars$wt, mtcars$mpg))
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Pearson's product-moment correlation between mtcars$wt and mtcars$mpg is
      negative, statistically significant, and very large (r = -0.87, 95% CI [-0.93,
      -0.74], t(30) = -9.56, p < .001)

---

    Code
      report(suppressWarnings(cor.test(mtcars$wt, mtcars$mpg, method = "spearman")))
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Spearman's rank correlation rho between mtcars$wt and mtcars$mpg is
      negative, statistically significant, and very large (rho = -0.89, S = 10292.32,
      p < .001)

---

    Code
      report(suppressWarnings(cor.test(mtcars$wt, mtcars$mpg, method = "kendall")))
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Kendall's rank correlation tau between mtcars$wt and mtcars$mpg is
      negative, statistically significant, and very large (tau = -0.73, z = -5.80, p
      < .001)

