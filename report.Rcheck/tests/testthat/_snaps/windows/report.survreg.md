# report-survreg

    Code
      report(mod_survreg)
    Output
      Can't calculate log-loss.
    Message
      Can't calculate proper scoring rules for models without integer response
        values.
    Output
      `performance_pcp()` only works for models with binary response values.
      Can't calculate log-loss.
    Message
      Can't calculate proper scoring rules for models without integer response
        values.
    Output
      `performance_pcp()` only works for models with binary response values.
      We fitted a logistic model to predict survival::Surv(futime, fustat) with
      ecog.ps and rx (formula: survival::Surv(futime, fustat) ~ ecog.ps + rx). The
      model's explanatory power is weak (Nagelkerke's R2 = 0.07). The model's
      intercept, corresponding to ecog.ps = 0 and rx = 0, is at 667.43 (95% CI
      [-415.59, 1750.45], p = 0.227). Within this model:
      
        - The effect of ecog ps is statistically non-significant and negative (beta =
      -210.59, 95% CI [-726.18, 305.01], p = 0.423; Std. beta = -107.06, 95% CI
      [-369.19, 155.07])
        - The effect of rx is statistically non-significant and positive (beta =
      320.10, 95% CI [-194.11, 834.32], p = 0.222; Std. beta = 163.22, 95% CI
      [-98.98, 425.42])
        - The effect of Log(scale) is statistically significant and positive (beta =
      5.82, 95% CI [5.35, 6.29], p < .001; Std. beta = 5.82, 95% CI [5.35, 6.29])
      
      Standardized parameters were obtained by fitting the model on a standardized
      version of the dataset. 95% Confidence Intervals (CIs) and p-values were
      computed using a Wald z-distribution approximation.

