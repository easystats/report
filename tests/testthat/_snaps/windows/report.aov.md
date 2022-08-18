# report.aov

    Code
      suppressWarnings(report(anova(lm(Sepal.Width ~ Species, data = iris))))
    Output
      The ANOVA suggests that:
      
        - The main effect of Species is statistically significant and large (F(2, 147)
      = 49.16, p < .001; Eta2 = 0.40, 95% CI [0.30, 1.00])
      
      Effect sizes were labelled following Field's (2013) recommendations.

---

    Code
      suppressWarnings(report(anova(lm(wt ~ as.factor(am) * as.factor(cyl), data = mtcars))))
    Output
      The ANOVA suggests that:
      
        - The main effect of as.factor(am) is statistically significant and large (F(1,
      26) = 45.39, p < .001; Eta2 (partial) = 0.64, 95% CI [0.43, 1.00])
        - The main effect of as.factor(cyl) is statistically significant and large
      (F(2, 26) = 11.53, p < .001; Eta2 (partial) = 0.47, 95% CI [0.21, 1.00])
        - The interaction between as.factor(am) and as.factor(cyl) is statistically not
      significant and very small (F(2, 26) = 0.11, p = 0.899; Eta2 (partial) =
      8.13e-03, 95% CI [0.00, 1.00])
      
      Effect sizes were labelled following Field's (2013) recommendations.

---

    Code
      suppressWarnings(report(aov(wt ~ cyl + Error(gear), data = mtcars)))
    Output
      The repeated-measures ANOVA (formula: wt ~ cyl + Error(gear)) suggests that:
      
        - The main effect of cyl is statistically significant and large (F(1, 29) =
      27.94, p < .001; Eta2 (partial) = 1.00, 95% CI [, 1.00])
        - The main effect of cyl is statistically significant and large (F(1, 29) =
      27.94, p < .001; Eta2 (partial) = 0.49, 95% CI [0.27, 1.00])
      
      Effect sizes were labelled following Field's (2013) recommendations.

