# model-stanreg detailed

    Code
      report(model)
    Output
      We fitted a Bayesian linear model (estimated using MCMC sampling with 4 chains
      of 300 iterations and a warmup of 150) to predict mpg with qsec and wt
      (formula: mpg ~ qsec + wt). Priors over parameters were set as normal (mean =
      0.00, SD = 8.43) distributions. The model's explanatory power is substantial
      (R2 = 0.81, 95% CI [0.70, 0.90], adj. R2 = 0.80). The model's intercept,
      corresponding to qsec = 0 and wt = 0, is at 19.71 (95% CI [9.04, 30.18]).
      Within this model:
      
        - The effect of qsec (Median = 0.92, 95% CI [0.40, 1.47]) has a 99.83%
      probability of being positive (> 0), 99.00% of being significant (> 0.30), and
      0.33% of being large (> 1.81). The estimation successfully converged (Rhat =
      0.999) but the indices are unreliable (ESS = 451)
        - The effect of wt (Median = -5.06, 95% CI [-6.02, -4.18]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). However, the estimation might not have
      successfuly converged (Rhat = 1.013) and the indices are unreliable (ESS = 478)
      
      Following the Sequential Effect eXistence and sIgnificance Testing (SEXIT)
      framework, we report the median of the posterior distribution and its 95% CI
      (Highest Density Interval), along the probability of direction (pd), the
      probability of significance and the probability of being large. The thresholds
      beyond which the effect is considered as significant (i.e., non-negligible) and
      large are |0.30| and |1.81| (corresponding respectively to 0.05 and 0.30 of the
      outcome's SD). Convergence and stability of the Bayesian sampling has been
      assessed using R-hat, which should be below 1.01 (Vehtari et al., 2019), and
      Effective Sample Size (ESS), which should be greater than 1000 (Burkner, 2017).
      and We fitted a Bayesian linear model (estimated using MCMC sampling with 4
      chains of 300 iterations and a warmup of 150) to predict mpg with qsec and wt
      (formula: mpg ~ qsec + wt). Priors over parameters were set as normal (mean =
      0.00, SD = 15.40) distributions. The model's explanatory power is substantial
      (R2 = 0.81, 95% CI [0.70, 0.90], adj. R2 = 0.80). The model's intercept,
      corresponding to qsec = 0 and wt = 0, is at 19.71 (95% CI [9.04, 30.18]).
      Within this model:
      
        - The effect of qsec (Median = 0.92, 95% CI [0.40, 1.47]) has a 99.83%
      probability of being positive (> 0), 99.00% of being significant (> 0.30), and
      0.33% of being large (> 1.81). The estimation successfully converged (Rhat =
      0.999) but the indices are unreliable (ESS = 451)
        - The effect of wt (Median = -5.06, 95% CI [-6.02, -4.18]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). However, the estimation might not have
      successfuly converged (Rhat = 1.013) and the indices are unreliable (ESS = 478)
      
      Following the Sequential Effect eXistence and sIgnificance Testing (SEXIT)
      framework, we report the median of the posterior distribution and its 95% CI
      (Highest Density Interval), along the probability of direction (pd), the
      probability of significance and the probability of being large. The thresholds
      beyond which the effect is considered as significant (i.e., non-negligible) and
      large are |0.30| and |1.81| (corresponding respectively to 0.05 and 0.30 of the
      outcome's SD). Convergence and stability of the Bayesian sampling has been
      assessed using R-hat, which should be below 1.01 (Vehtari et al., 2019), and
      Effective Sample Size (ESS), which should be greater than 1000 (Burkner, 2017).

