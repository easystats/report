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
    Output
      Running MCMC with 4 parallel chains...
      
      Chain 1 Iteration:   1 / 300 [  0%]  (Warmup) 
      Chain 1 Iteration: 100 / 300 [ 33%]  (Warmup) 
      Chain 1 Iteration: 151 / 300 [ 50%]  (Sampling) 
      Chain 1 Iteration: 250 / 300 [ 83%]  (Sampling) 
      Chain 1 Iteration: 300 / 300 [100%]  (Sampling) 
      Chain 2 Iteration:   1 / 300 [  0%]  (Warmup) 
      Chain 2 Iteration: 100 / 300 [ 33%]  (Warmup) 
      Chain 2 Iteration: 151 / 300 [ 50%]  (Sampling) 
      Chain 2 Iteration: 250 / 300 [ 83%]  (Sampling) 
      Chain 2 Iteration: 300 / 300 [100%]  (Sampling) 
      Chain 3 Iteration:   1 / 300 [  0%]  (Warmup) 
      Chain 3 Iteration: 100 / 300 [ 33%]  (Warmup) 
      Chain 3 Iteration: 151 / 300 [ 50%]  (Sampling) 
      Chain 3 Iteration: 250 / 300 [ 83%]  (Sampling) 
      Chain 3 Iteration: 300 / 300 [100%]  (Sampling) 
      Chain 1 finished in 0.0 seconds.
      Chain 2 finished in 0.0 seconds.
      Chain 3 finished in 0.0 seconds.
      Chain 4 Iteration:   1 / 300 [  0%]  (Warmup) 
      Chain 4 Iteration: 100 / 300 [ 33%]  (Warmup) 
      Chain 4 Iteration: 151 / 300 [ 50%]  (Sampling) 
      Chain 4 Iteration: 250 / 300 [ 83%]  (Sampling) 
      Chain 4 Iteration: 300 / 300 [100%]  (Sampling) 
      Chain 4 finished in 0.0 seconds.
      
      All 4 chains finished successfully.
      Mean chain execution time: 0.0 seconds.
      Total execution time: 0.4 seconds.
      
    Warning <simpleWarning>
      Response residuals not available to calculate mean square error. (R)MSE
        is probably not reliable.
    Output
      We fitted a Bayesian linear model (estimated using MCMC sampling with 4 chains
      of 300 iterations and a warmup of 150) to predict mpg with qsec and wt
      (formula: mpg ~ qsec + wt). Priors over parameters were set as student_t
      (location = 19.20, scale = 5.40) distributions. The model's explanatory power
      is substantial (R2 = 0.82, 95% CI [0.75, 0.85], adj. R2 = 0.79).  Within this
      model:
      
        - The effect of b Intercept (Median = 19.23, 95% CI [6.80, 31.02]) has a 99.67%
      probability of being positive (> 0), 99.67% of being significant (> 0.30), and
      99.33% of being large (> 1.81). The estimation successfully converged (Rhat =
      0.999) but the indices are unreliable (ESS = 343)
        - The effect of b qsec (Median = 0.95, 95% CI [0.41, 1.56]) has a 100.00%
      probability of being positive (> 0), 99.17% of being significant (> 0.30), and
      0.33% of being large (> 1.81). The estimation successfully converged (Rhat =
      0.999) but the indices are unreliable (ESS = 345)
        - The effect of b wt (Median = -5.02, 95% CI [-6.06, -4.09]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). The estimation successfully converged
      (Rhat = 0.999) but the indices are unreliable (ESS = 586)
        - NANAThe estimation successfully converged (Rhat = 0.999) but the indices are
      unreliable (ESS = 343)
      
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
      
        - The effect of b Intercept (Median = 19.23, 95% CI [6.80, 31.02]) has a 99.67%
      probability of being positive (> 0), 99.67% of being significant (> 0.30), and
      99.33% of being large (> 1.81). The estimation successfully converged (Rhat =
      0.999) but the indices are unreliable (ESS = 343)
        - The effect of b qsec (Median = 0.95, 95% CI [0.41, 1.56]) has a 100.00%
      probability of being positive (> 0), 99.17% of being significant (> 0.30), and
      0.33% of being large (> 1.81). The estimation successfully converged (Rhat =
      0.999) but the indices are unreliable (ESS = 345)
        - The effect of b wt (Median = -5.02, 95% CI [-6.06, -4.09]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). The estimation successfully converged
      (Rhat = 0.999) but the indices are unreliable (ESS = 586)
        - NANAThe estimation successfully converged (Rhat = 0.999) but the indices are
      unreliable (ESS = 343)
      
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
      
        - The effect of b Intercept (Median = 19.23, 95% CI [6.80, 31.02]) has a 99.67%
      probability of being positive (> 0), 99.67% of being significant (> 0.30), and
      99.33% of being large (> 1.81). The estimation successfully converged (Rhat =
      0.999) but the indices are unreliable (ESS = 343)
        - The effect of b qsec (Median = 0.95, 95% CI [0.41, 1.56]) has a 100.00%
      probability of being positive (> 0), 99.17% of being significant (> 0.30), and
      0.33% of being large (> 1.81). The estimation successfully converged (Rhat =
      0.999) but the indices are unreliable (ESS = 345)
        - The effect of b wt (Median = -5.02, 95% CI [-6.06, -4.09]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). The estimation successfully converged
      (Rhat = 0.999) but the indices are unreliable (ESS = 586)
        - NANAThe estimation successfully converged (Rhat = 0.999) but the indices are
      unreliable (ESS = 343)
      
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
      
        - The effect of b Intercept (Median = 19.23, 95% CI [6.80, 31.02]) has a 99.67%
      probability of being positive (> 0), 99.67% of being significant (> 0.30), and
      99.33% of being large (> 1.81). The estimation successfully converged (Rhat =
      0.999) but the indices are unreliable (ESS = 343)
        - The effect of b qsec (Median = 0.95, 95% CI [0.41, 1.56]) has a 100.00%
      probability of being positive (> 0), 99.17% of being significant (> 0.30), and
      0.33% of being large (> 1.81). The estimation successfully converged (Rhat =
      0.999) but the indices are unreliable (ESS = 345)
        - The effect of b wt (Median = -5.02, 95% CI [-6.06, -4.09]) has a 100.00%
      probability of being negative (< 0), 100.00% of being significant (< -0.30),
      and 100.00% of being large (< -1.81). The estimation successfully converged
      (Rhat = 0.999) but the indices are unreliable (ESS = 586)
        - NANAThe estimation successfully converged (Rhat = 0.999) but the indices are
      unreliable (ESS = 343)
      
      Following the Sequential Effect eXistence and sIgnificance Testing (SEXIT)
      framework, we report the median of the posterior distribution and its 95% CI
      (Highest Density Interval), along the probability of direction (pd), the
      probability of significance and the probability of being large. The thresholds
      beyond which the effect is considered as significant (i.e., non-negligible) and
      large are |0.30| and |1.81| (corresponding respectively to 0.05 and 0.30 of the
      outcome's SD). Convergence and stability of the Bayesian sampling has been
      assessed using R-hat, which should be below 1.01 (Vehtari et al., 2019), and
      Effective Sample Size (ESS), which should be greater than 1000 (Burkner, 2017).

