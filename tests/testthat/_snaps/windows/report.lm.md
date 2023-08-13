# report.lm - glm

    Code
      report(glm(vs ~ disp, data = mtcars, family = binomial(link = "probit")))
    Output
      We fitted a probit model (estimated using ML) to predict vs with disp (formula:
      vs ~ disp). The model's explanatory power is substantial (Nagelkerke's R2 =
      0.66). The model's intercept, corresponding to disp = 0, is at 2.51 (95% CI
      [1.13, 4.28], p = 0.001). Within this model:
      
        - The effect of disp is statistically significant and negative (beta = -0.01,
      95% CI [-0.02, -6.45e-03], p < .001; Std. beta = -1.62, 95% CI [-2.79, -0.80])
      
      Standardized parameters were obtained by fitting the model on a standardized
      version of the dataset. 95% Confidence Intervals (CIs) and p-values were
      computed using a Wald z-distribution approximation.

---

    Code
      report(glm(vs ~ mpg, data = mtcars, family = "poisson"))
    Output
      We fitted a poisson model (estimated using ML) to predict vs with mpg (formula:
      vs ~ mpg). The model's explanatory power is substantial (Nagelkerke's R2 =
      0.39). The model's intercept, corresponding to mpg = 0, is at -3.27 (95% CI
      [-5.46, -1.36], p = 0.002). Within this model:
      
        - The effect of mpg is statistically significant and positive (beta = 0.11, 95%
      CI [0.03, 0.19], p = 0.007; Std. beta = 0.66, 95% CI [0.18, 1.15])
      
      Standardized parameters were obtained by fitting the model on a standardized
      version of the dataset. 95% Confidence Intervals (CIs) and p-values were
      computed using a Wald z-distribution approximation.

# report.lm - lm intercept-only

    Code
      out
    Output
      We fitted a constant (intercept-only) linear model (estimated using OLS) to
      predict d_wide$group0 - d_wide$group1 (formula: d_wide$group0 - d_wide$group1 ~
      1). The model's intercept is at -1.58 (95% CI [-2.46, -0.70], t(9) = -4.06, p =
      0.003).
      
      Standardized parameters were obtained by fitting the model on a standardized
      version of the dataset. 95% Confidence Intervals (CIs) and p-values were
      computed using a Wald t-distribution approximation.

