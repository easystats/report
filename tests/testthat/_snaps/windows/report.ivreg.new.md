# report-survreg

    Code
      report(ivr)
    Message <simpleMessage>
      Formula contains log- or sqrt-terms.
        See help("standardize") for how such terms are standardized.
    Warning <simpleWarning>
      Following elements are no valid metric: `Sargan` and `Wu_Hausman`
    Message <simpleMessage>
      Formula contains log- or sqrt-terms.
        See help("standardize") for how such terms are standardized.
    Warning <simpleWarning>
      Following elements are no valid metric: `Sargan` and `Wu_Hausman`
    Output
      We fitted a linear model to predict packs with rprice, rincome and salestax
      (formula: log(packs) ~ log(rprice) + log(rincome)). The model's explanatory
      power is substantial (R2 = 0.42, adj. R2 = 0.39). The model's intercept,
      corresponding to rprice = 0 and rincome = 0, is at 9.43 (95% CI [6.69, 12.17],
      t(45) = 6.94, p < .001). Within this model:
      
        - The effect of rprice [log] is statistically significant and negative (beta =
      -1.14, 95% CI [-1.87, -0.42], t(45) = -3.18, p = 0.003; Std. beta = -0.53, 95%
      CI [-0.86, -0.20])
        - The effect of rincome [log] is statistically non-significant and positive
      (beta = 0.21, 95% CI [-0.33, 0.76], t(45) = 0.80, p = 0.429; Std. beta = 0.12,
      95% CI [-0.14, 0.39])
      
      Standardized parameters were obtained by fitting the model on a standardized
      version of the dataset. 95% Confidence Intervals (CIs) and p-values were
      computed using a Wald t-distribution approximation.

