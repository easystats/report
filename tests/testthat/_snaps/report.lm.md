# report.lm - lm

    Code
      report(lm(Sepal.Width ~ Species, data = iris))
    Output
      We fitted a linear model (estimated using OLS) to predict Sepal.Width with Species (formula: Sepal.Width ~ Species). The model explains a significant and substantial proportion of variance (R2 = 0.40, F(2, 147) = 49.16, p < .001, adj. R2 = 0.39). The model's intercept, corresponding to Species = setosa, is at 3.43 (95% CI [3.33, 3.52], t(147) = 71.36, p < .001). Within this model:
      
        - The effect of Species [versicolor] is significantly negative (beta = -0.66, 95% CI [-0.79, -0.52], t(147) = -9.69, p < .001; Std. beta = -1.51, 95% CI [-1.82, -1.20])
        - The effect of Species [virginica] is significantly negative (beta = -0.45, 95% CI [-0.59, -0.32], t(147) = -6.68, p < .001; Std. beta = -1.04, 95% CI [-1.35, -0.73])
      
      Standardized parameters were obtained by fitting the model on a standardized version of the dataset.

# report.lm - glm

    Code
      report(glm(vs ~ disp, data = mtcars, family = binomial(link = "probit")))
    Output
      We fitted a probit model (estimated using ML) to predict vs with disp (formula: vs ~ disp). The model's explanatory power is substantial (Nagelkerke's R2 = 0.66). The model's intercept, corresponding to disp = 0, is at 2.51 (95% CI [1.13, 4.28], p < .01). Within this model:
      
        - The effect of disp is significantly negative (beta = -0.01, 95% CI [-0.02, -6.45e-03], p < .001; Std. beta = -1.62, 95% CI [-2.79, -0.80])
      
      Standardized parameters were obtained by fitting the model on a standardized version of the dataset. 95% Confidence Intervals (CIs) and p-values were computed using 

---

    Code
      report(glm(vs ~ mpg, data = mtcars, family = "poisson"))
    Output
      We fitted a poisson model (estimated using ML) to predict vs with mpg (formula: vs ~ mpg). The model's explanatory power is substantial (Nagelkerke's R2 = 0.39). The model's intercept, corresponding to mpg = 0, is at -3.27 (95% CI [-5.46, -1.36], p < .01). Within this model:
      
        - The effect of mpg is significantly positive (beta = 0.11, 95% CI [0.03, 0.19], p < .01; Std. beta = 0.66, 95% CI [0.18, 1.15])
      
      Standardized parameters were obtained by fitting the model on a standardized version of the dataset. 95% Confidence Intervals (CIs) and p-values were computed using 

