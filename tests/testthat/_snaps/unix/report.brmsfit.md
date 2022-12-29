# report.brms

    Code
      report(model)
    Warning <simpleWarning>
      Response residuals not available to calculate mean square error. (R)MSE
        is probably not reliable.
      longer object length is not a multiple of shorter object length
      longer object length is not a multiple of shorter object length
    Message <simpleMessage>
      Start sampling
    Warning <simpleWarning>
      Response residuals not available to calculate mean square error. (R)MSE
        is probably not reliable.
    Output
      We fitted a Bayesian linear model (estimated using MCMC sampling with 4 chains
      of 300 iterations and a warmup of 150) to predict mpg with qsec and wt
      (formula: mpg ~ qsec + wt). Priors over parameters were set as student_t
      (location = 19.20, scale = 5.40) distributions. The model's explanatory power
      is substantial (R2 = 0.82, 95% CI [0.76, 0.85], adj. R2 = 0.80).  Within this
      model:
      
        - The effect of b Intercept (Median = 19.88, 95% CI [8.94, 30.59]) has a
      100.00% probability of being positive (> 0), 100.00% of being significant (>
      0.30), and 100.00% of being large (> 1.81). The estimation successfully
      converged (Rhat = 1.000) but the indices are unreliable (ESS = 528)
        - The effect of b qsec (Median = 0.92, 95% CI [0.38, 1.53]) has a 100.00%
      probability of being positive (> 0), 98.33% of being significant (> 0.30), and
      0.00% of being large (> 1.81). The estimation successfully converged (Rhat =
      1.003) but the indices are unreliable (ESS = 526)
        - The effect of b wt (Median = -5.05, 95% CI [-5.94, -4.05]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). The estimation successfully converged
      (Rhat = 1.000) but the indices are unreliable (ESS = 538)
        - NANAThe estimation successfully converged (Rhat = 1.000) but the indices are
      unreliable (ESS = 528)
      
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
      substantial (R2 = 0.82, 95% CI [0.76, 0.85], adj. R2 = 0.80).  Within this
      model:
      
        - The effect of b Intercept (Median = 19.88, 95% CI [8.94, 30.59]) has a
      100.00% probability of being positive (> 0), 100.00% of being significant (>
      0.30), and 100.00% of being large (> 1.81). The estimation successfully
      converged (Rhat = 1.000) but the indices are unreliable (ESS = 528)
        - The effect of b qsec (Median = 0.92, 95% CI [0.38, 1.53]) has a 100.00%
      probability of being positive (> 0), 98.33% of being significant (> 0.30), and
      0.00% of being large (> 1.81). The estimation successfully converged (Rhat =
      1.003) but the indices are unreliable (ESS = 526)
        - The effect of b wt (Median = -5.05, 95% CI [-5.94, -4.05]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). The estimation successfully converged
      (Rhat = 1.000) but the indices are unreliable (ESS = 538)
        - NANAThe estimation successfully converged (Rhat = 1.000) but the indices are
      unreliable (ESS = 528)
      
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
      substantial (R2 = 0.82, 95% CI [0.76, 0.85], adj. R2 = 0.80).  Within this
      model:
      
        - The effect of b Intercept (Median = 19.88, 95% CI [8.94, 30.59]) has a
      100.00% probability of being positive (> 0), 100.00% of being significant (>
      0.30), and 100.00% of being large (> 1.81). The estimation successfully
      converged (Rhat = 1.000) but the indices are unreliable (ESS = 528)
        - The effect of b qsec (Median = 0.92, 95% CI [0.38, 1.53]) has a 100.00%
      probability of being positive (> 0), 98.33% of being significant (> 0.30), and
      0.00% of being large (> 1.81). The estimation successfully converged (Rhat =
      1.003) but the indices are unreliable (ESS = 526)
        - The effect of b wt (Median = -5.05, 95% CI [-5.94, -4.05]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). The estimation successfully converged
      (Rhat = 1.000) but the indices are unreliable (ESS = 538)
        - NANAThe estimation successfully converged (Rhat = 1.000) but the indices are
      unreliable (ESS = 528)
      
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
      substantial (R2 = 0.82, 95% CI [0.76, 0.85], adj. R2 = 0.80).  Within this
      model:
      
        - The effect of b Intercept (Median = 19.88, 95% CI [8.94, 30.59]) has a
      100.00% probability of being positive (> 0), 100.00% of being significant (>
      0.30), and 100.00% of being large (> 1.81). The estimation successfully
      converged (Rhat = 1.000) but the indices are unreliable (ESS = 528)
        - The effect of b qsec (Median = 0.92, 95% CI [0.38, 1.53]) has a 100.00%
      probability of being positive (> 0), 98.33% of being significant (> 0.30), and
      0.00% of being large (> 1.81). The estimation successfully converged (Rhat =
      1.003) but the indices are unreliable (ESS = 526)
        - The effect of b wt (Median = -5.05, 95% CI [-5.94, -4.05]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). The estimation successfully converged
      (Rhat = 1.000) but the indices are unreliable (ESS = 538)
        - NANAThe estimation successfully converged (Rhat = 1.000) but the indices are
      unreliable (ESS = 528)
      
      Following the Sequential Effect eXistence and sIgnificance Testing (SEXIT)
      framework, we report the median of the posterior distribution and its 95% CI
      (Highest Density Interval), along the probability of direction (pd), the
      probability of significance and the probability of being large. The thresholds
      beyond which the effect is considered as significant (i.e., non-negligible) and
      large are |0.30| and |1.81| (corresponding respectively to 0.05 and 0.30 of the
      outcome's SD). Convergence and stability of the Bayesian sampling has been
      assessed using R-hat, which should be below 1.01 (Vehtari et al., 2019), and
      Effective Sample Size (ESS), which should be greater than 1000 (Burkner, 2017).

