# report-survreg

    Code
      report(ivr)
    Message <simpleMessage>
      Formula contains log- or sqrt-terms. See help("standardize") for how such terms are standardized.
      Formula contains log- or sqrt-terms. See help("standardize") for how such terms are standardized.
    Output
      We fitted a linear model to predict packs with income and population (formula: log(packs) ~ income). The model's explanatory power is weak (R2 = 0.11, adj. R2 = 0.10). The model's intercept, corresponding to income = 0, is at 4.71 (95% CI [4.65, 4.77], t(94) = 150.96, p < .001). Within this model:
      
        - The effect of income is statistically significant and negative (beta = -4.76e-10, 95% CI [-8.78e-10, -7.36e-11], t(94) = -2.32, p < .05; Std. beta = -0.08, 95% CI [-0.14, -0.01])
      
      Standardized parameters were obtained by fitting the model on a standardized version of the dataset.

