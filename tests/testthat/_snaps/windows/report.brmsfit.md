# report.brms

    Code
      report(model, verbose = FALSE)
    Message
      Start sampling
    Output
      We fitted a Bayesian linear model (estimated using MCMC sampling with 4 chains
      of 300 iterations and a warmup of 150) to predict mpg with qsec and wt
      (formula: mpg ~ qsec + wt). Priors over parameters were set as student_t
      (location = 19.20, scale = 5.40) distributions. The model's explanatory power
      is substantial (R2 = 0.82, 95% CI [0.75, 0.85], adj. R2 = 0.79).  Within this
      model:
      
        - The effect of b Intercept (Median = 19.74, 95% CI [9.45, 32.02]) has a 99.83%
      probability of being positive (> 0), 99.83% of being significant (> 0.30), and
      99.67% of being large (> 1.81). The estimation successfully converged (Rhat =
      1.000) but the indices are unreliable (ESS = 522)
        - The effect of b qsec (Median = 0.92, 95% CI [0.34, 1.47]) has a 99.83%
      probability of being positive (> 0), 98.17% of being significant (> 0.30), and
      0.17% of being large (> 1.81). The estimation successfully converged (Rhat =
      1.002) but the indices are unreliable (ESS = 521)
        - The effect of b wt (Median = -5.09, 95% CI [-6.06, -4.09]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). The estimation successfully converged
      (Rhat = 0.997) but the indices are unreliable (ESS = 543)
      
      Following the Sequential Effect eXistence and sIgnificance Testing (SEXIT)
      framework, we report the median of the posterior distribution and its 95% CI
      (Highest Density Interval), along the probability of direction (pd), the
      probability of significance and the probability of being large. The thresholds
      beyond which the effect is considered as significant (i.e., non-negligible) and
      large are |0.30| and |1.81| (corresponding respectively to 0.05 and 0.30 of the
      outcome's SD). Convergence and stability of the Bayesian sampling has been
      assessed using R-hat, which should be below 1.01 (Vehtari et al., 2019), and
      Effective Sample Size (ESS), which should be greater than 1000 (Burkner,
      2017)., We fitted a Bayesian linear model (estimated using MCMC sampling with 4
      chains of 300 iterations and a warmup of 150) to predict mpg with qsec and wt
      (formula: mpg ~ qsec + wt). Priors over parameters were set as uniform
      (location = , scale = ) distributions. The model's explanatory power is
      substantial (R2 = 0.82, 95% CI [0.75, 0.85], adj. R2 = 0.79).  Within this
      model:
      
        - The effect of b Intercept (Median = 19.74, 95% CI [9.45, 32.02]) has a 99.83%
      probability of being positive (> 0), 99.83% of being significant (> 0.30), and
      99.67% of being large (> 1.81). The estimation successfully converged (Rhat =
      1.000) but the indices are unreliable (ESS = 522)
        - The effect of b qsec (Median = 0.92, 95% CI [0.34, 1.47]) has a 99.83%
      probability of being positive (> 0), 98.17% of being significant (> 0.30), and
      0.17% of being large (> 1.81). The estimation successfully converged (Rhat =
      1.002) but the indices are unreliable (ESS = 521)
        - The effect of b wt (Median = -5.09, 95% CI [-6.06, -4.09]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). The estimation successfully converged
      (Rhat = 0.997) but the indices are unreliable (ESS = 543)
      
      Following the Sequential Effect eXistence and sIgnificance Testing (SEXIT)
      framework, we report the median of the posterior distribution and its 95% CI
      (Highest Density Interval), along the probability of direction (pd), the
      probability of significance and the probability of being large. The thresholds
      beyond which the effect is considered as significant (i.e., non-negligible) and
      large are |0.30| and |1.81| (corresponding respectively to 0.05 and 0.30 of the
      outcome's SD). Convergence and stability of the Bayesian sampling has been
      assessed using R-hat, which should be below 1.01 (Vehtari et al., 2019), and
      Effective Sample Size (ESS), which should be greater than 1000 (Burkner,
      2017)., We fitted a Bayesian linear model (estimated using MCMC sampling with 4
      chains of 300 iterations and a warmup of 150) to predict mpg with qsec and wt
      (formula: mpg ~ qsec + wt). Priors over parameters were set as uniform
      (location = , scale = ) distributions. The model's explanatory power is
      substantial (R2 = 0.82, 95% CI [0.75, 0.85], adj. R2 = 0.79).  Within this
      model:
      
        - The effect of b Intercept (Median = 19.74, 95% CI [9.45, 32.02]) has a 99.83%
      probability of being positive (> 0), 99.83% of being significant (> 0.30), and
      99.67% of being large (> 1.81). The estimation successfully converged (Rhat =
      1.000) but the indices are unreliable (ESS = 522)
        - The effect of b qsec (Median = 0.92, 95% CI [0.34, 1.47]) has a 99.83%
      probability of being positive (> 0), 98.17% of being significant (> 0.30), and
      0.17% of being large (> 1.81). The estimation successfully converged (Rhat =
      1.002) but the indices are unreliable (ESS = 521)
        - The effect of b wt (Median = -5.09, 95% CI [-6.06, -4.09]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). The estimation successfully converged
      (Rhat = 0.997) but the indices are unreliable (ESS = 543)
      
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
      (formula: mpg ~ qsec + wt). Priors over parameters were set as student_t
      (location = 0.00, scale = 5.40) distributions. The model's explanatory power is
      substantial (R2 = 0.82, 95% CI [0.75, 0.85], adj. R2 = 0.79).  Within this
      model:
      
        - The effect of b Intercept (Median = 19.74, 95% CI [9.45, 32.02]) has a 99.83%
      probability of being positive (> 0), 99.83% of being significant (> 0.30), and
      99.67% of being large (> 1.81). The estimation successfully converged (Rhat =
      1.000) but the indices are unreliable (ESS = 522)
        - The effect of b qsec (Median = 0.92, 95% CI [0.34, 1.47]) has a 99.83%
      probability of being positive (> 0), 98.17% of being significant (> 0.30), and
      0.17% of being large (> 1.81). The estimation successfully converged (Rhat =
      1.002) but the indices are unreliable (ESS = 521)
        - The effect of b wt (Median = -5.09, 95% CI [-6.06, -4.09]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). The estimation successfully converged
      (Rhat = 0.997) but the indices are unreliable (ESS = 543)
      
      Following the Sequential Effect eXistence and sIgnificance Testing (SEXIT)
      framework, we report the median of the posterior distribution and its 95% CI
      (Highest Density Interval), along the probability of direction (pd), the
      probability of significance and the probability of being large. The thresholds
      beyond which the effect is considered as significant (i.e., non-negligible) and
      large are |0.30| and |1.81| (corresponding respectively to 0.05 and 0.30 of the
      outcome's SD). Convergence and stability of the Bayesian sampling has been
      assessed using R-hat, which should be below 1.01 (Vehtari et al., 2019), and
      Effective Sample Size (ESS), which should be greater than 1000 (Burkner, 2017).

