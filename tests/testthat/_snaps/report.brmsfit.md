# report.brms

    Code
      report(model)
    Warning <simpleWarning>
      Note that the default rope range for linear models might change in future versions (see https://github.com/easystats/bayestestR/issues/364).Please set it explicitly to preserve current results.
      Can't extract 'deviance' residuals. Returning response residuals.
    Output
      Model was fitted with uninformative (flat) priors!
    Warning <simpleWarning>
      Note that the default rope range for linear models might change in future versions (see https://github.com/easystats/bayestestR/issues/364).Please set it explicitly to preserve current results.
    Message <simpleMessage>
      Start sampling
    Warning <simpleWarning>
      Can't extract 'deviance' residuals. Returning response residuals.
    Output
      We fitted a Bayesian linear model (estimated using MCMC sampling with 4 chains of 300 iterations and a warmup of 150) to predict mpg with qsec and wt (formula: mpg ~ qsec + wt). . The model's explanatory power is substantial (R2 = 0.82, 89% CI [0.78, 0.85], adj. R2 = 0.78).  Within this model:
      
        - The effect of b_Intercept (Median = 19.86, 0.95% CI [9.29, 30.02]) has a 100.00% probability of being positive (> 0), 100.00% of being significant (> 0.30), and 100.00% of being large (> 1.81). The estimation successfully converged (Rhat = 1.007) but the indices are unreliable (ESS = 486)
        - The effect of b_qsec (Median = 0.93, 0.95% CI [0.44, 1.51]) has a 100.00% probability of being positive (> 0), 99.00% of being significant (> 0.30), and 0.00% of being large (> 1.81). The estimation successfully converged (Rhat = 1.007) but the indices are unreliable (ESS = 502)
        - The effect of b_wt (Median = -5.06, 0.95% CI [-5.97, -4.08]) has a 100.00% probability of being negative (< 0), 100.00% of being significant (< -0.30), and 100.00% of being large (< -1.81). The estimation successfully converged (Rhat = 0.998) but the indices are unreliable (ESS = 627)
      
      Following the Sequential Effect eXistence and sIgnificance Testing (SEXIT) framework, we report the median of the posterior distribution and its 95% CI (Highest Density Interval), along the probability of direction (pd), the probability of significance and the probability of being large. The thresholds beyond which the effect is considered as significant (i.e., non-negligible) and large are |0.30| and |1.81| (corresponding respectively to 0.05 and 0.30 of the outcome's SD). Convergence and stability of the Bayesian sampling has been assessed using R-hat, which should be below 1.01 (Vehtari et al., 2019), and Effective Sample Size (ESS), which should be greater than 1000 (Burkner, 2017).

