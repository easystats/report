# report-lmer

    Code
      report(m1)
    Output
      We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
      to predict Reaction with Days (formula: Reaction ~ Days). The model included
      Days as random effects (formula: ~1 + Days | Subject). The model's total
      explanatory power is substantial (conditional R2 = 0.80) and the part related
      to the fixed effects alone (marginal R2) is of 0.28. The model's intercept,
      corresponding to Days = 0, is at 251.41 (95% CI [237.94, 264.87], t(174) =
      36.84, p < .001). Within this model:
      
        - The effect of Days is statistically significant and positive (beta = 10.47,
      95% CI [7.42, 13.52], t(174) = 6.77, p < .001; Std. beta = 0.54, 95% CI [0.38,
      0.69])
      
      Standardized parameters were obtained by fitting the model on a standardized
      version of the dataset. 95% Confidence Intervals (CIs) and p-values were
      computed using a Wald t-distribution approximation.

---

    Code
      report(m2)
    Message <simpleMessage>
      boundary (singular) fit: see help('isSingular')
    Output
      Random effect variances not available. Returned R2 does not account for random effects.
    Message <simpleMessage>
      boundary (singular) fit: see help('isSingular')
    Output
      Random effect variances not available. Returned R2 does not account for random effects.
      We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
      to predict Reaction with Days (formula: Reaction ~ Days). The model included
      mysubgrp as random effects (formula: list(~1 | mysubgrp:mygrp, ~1 | mygrp, ~1 |
      Subject)). The model's explanatory power related to the fixed effects alone
      (marginal R2) is 0.49. The model's intercept, corresponding to Days = 0, is at
      252.09 (95% CI [232.50, 271.69], t(174) = 25.39, p < .001). Within this model:
      
        - The effect of Days is statistically significant and positive (beta = 10.35,
      95% CI [8.78, 11.93], t(174) = 12.95, p < .001; Std. beta = 0.53, 95% CI [0.45,
      0.61])
      
      Standardized parameters were obtained by fitting the model on a standardized
      version of the dataset. 95% Confidence Intervals (CIs) and p-values were
      computed using a Wald t-distribution approximation.

