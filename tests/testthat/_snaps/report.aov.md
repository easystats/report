# report.aov

    Code
      suppressWarnings(report(model))
    Message <simpleMessage>
      For one-way between subjects designs, partial eta squared is equivalent to eta squared.
      Returning eta squared.
    Output
      The ANOVA suggests that:
      
        - The main effect of Species is statistically significant and large (F(2, 147) = 49.16, p < .001; Eta2 = 0.40, 90% CI [0.30, 0.48])
      
      Effect sizes were labelled following Field's (2013) recommendations.

---

    Code
      suppressWarnings(report(model))
    Output
      The repeated-measures ANOVA (formula: wt ~ cyl + Error(gear)) suggests that:
      
        - The main effect of cyl is statistically NA and large (F(1, 29) = 27.94, p < .001; Eta2 (partial) = 0.49, 90% CI [0.27, 0.64])
        - The main effect of cyl is statistically significant and large (F(1, 29) = 27.94, p < .001; Eta2 (partial) = 0.49, 90% CI [0.27, 0.64])
      
      Effect sizes were labelled following Field's (2013) recommendations.

