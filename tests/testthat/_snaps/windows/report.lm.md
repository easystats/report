# report.lm - lm

    Code
      report(lm(Sepal.Width ~ Species, data = iris))
    Output
      We fitted a linear model (estimated using OLS) to predict Sepal.Width with
      Species (formula: Sepal.Width ~ Species). The model explains a statistically
      significant and substantial proportion of variance (R2 = 0.40, F(2, 147) =
      49.16, p < .001, adj. R2 = 0.39). The model's intercept, corresponding to
      Species = setosa, is at 3.43 (95% CI [3.33, 3.52], t(147) = 71.36, p < .001).
      Within this model:
      
        - The effect of Species [versicolor] is statistically significant and negative
      (beta = -0.66, 95% CI [-0.79, -0.52], t(147) = -9.69, p < .001; Std. beta =
      -1.51, 95% CI [-1.82, -1.20])
        - The effect of Species [virginica] is statistically significant and negative
      (beta = -0.45, 95% CI [-0.59, -0.32], t(147) = -6.68, p < .001; Std. beta =
      -1.04, 95% CI [-1.35, -0.73])
      
      Standardized parameters were obtained by fitting the model on a standardized
      version of the dataset. 95% Confidence Intervals (CIs) and p-values were
      computed using a Wald t-distribution approximation.

---

    Code
      report(lm(wt ~ as.factor(am) * as.factor(cyl), data = mtcars))
    Output
      We fitted a linear model (estimated using OLS) to predict wt with am and cyl
      (formula: wt ~ as.factor(am) * as.factor(cyl)). The model explains a
      statistically significant and substantial proportion of variance (R2 = 0.73,
      F(5, 26) = 13.73, p < .001, adj. R2 = 0.67). The model's intercept,
      corresponding to am = 0 and cyl = 0, is at 2.94 (95% CI [2.27, 3.60], t(26) =
      9.08, p < .001). Within this model:
      
        - The effect of am [1] is statistically significant and negative (beta = -0.89,
      95% CI [-1.67, -0.11], t(26) = -2.36, p = 0.026; Std. beta = -0.91, 95% CI
      [-1.71, -0.12])
        - The effect of cyl [6] is statistically non-significant and positive (beta =
      0.45, 95% CI [-0.43, 1.33], t(26) = 1.06, p = 0.298; Std. beta = 0.46, 95% CI
      [-0.43, 1.36])
        - The effect of cyl [8] is statistically significant and positive (beta = 1.17,
      95% CI [0.43, 1.91], t(26) = 3.23, p = 0.003; Std. beta = 1.19, 95% CI [0.44,
      1.95])
        - The effect of am [1] × as cyl6 is statistically non-significant and positive
      (beta = 0.26, 95% CI [-0.92, 1.43], t(26) = 0.45, p = 0.654; Std. beta = 0.26,
      95% CI [-0.94, 1.47])
        - The effect of am [1] × as cyl8 is statistically non-significant and positive
      (beta = 0.16, 95% CI [-1.02, 1.33], t(26) = 0.28, p = 0.783; Std. beta = 0.16,
      95% CI [-1.04, 1.36])
      
      Standardized parameters were obtained by fitting the model on a standardized
      version of the dataset. 95% Confidence Intervals (CIs) and p-values were
      computed using a Wald t-distribution approximation.

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

