# report.brms

    Code
      report(model, verbose = FALSE)
    Message
      Start sampling
      Chain 1 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
      Chain 1 Exception: normal_id_glm_lpdf: Scale vector is 0, but must be positive finite! (in 'C:/Users/DL/AppData/Local/Temp/RtmpERRA9z/model-12d437f47a61.stan', line 35, column 4 to column 62)
      Chain 1 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
      Chain 1 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
      Chain 1 
      Chain 2 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
      Chain 2 Exception: normal_id_glm_lpdf: Scale vector is inf, but must be positive finite! (in 'C:/Users/DL/AppData/Local/Temp/RtmpERRA9z/model-12d437f47a61.stan', line 35, column 4 to column 62)
      Chain 2 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
      Chain 2 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
      Chain 2 
      Chain 2 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
      Chain 2 Exception: normal_id_glm_lpdf: Scale vector is inf, but must be positive finite! (in 'C:/Users/DL/AppData/Local/Temp/RtmpERRA9z/model-12d437f47a61.stan', line 35, column 4 to column 62)
      Chain 2 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
      Chain 2 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
      Chain 2 
      Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
      Chain 3 Exception: normal_id_glm_lpdf: Scale vector is inf, but must be positive finite! (in 'C:/Users/DL/AppData/Local/Temp/RtmpERRA9z/model-12d437f47a61.stan', line 35, column 4 to column 62)
      Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
      Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
      Chain 3 
      Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
      Chain 3 Exception: normal_id_glm_lpdf: Scale vector is inf, but must be positive finite! (in 'C:/Users/DL/AppData/Local/Temp/RtmpERRA9z/model-12d437f47a61.stan', line 35, column 4 to column 62)
      Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
      Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
      Chain 3 
      Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
      Chain 3 Exception: normal_id_glm_lpdf: Scale vector is inf, but must be positive finite! (in 'C:/Users/DL/AppData/Local/Temp/RtmpERRA9z/model-12d437f47a61.stan', line 35, column 4 to column 62)
      Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
      Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
      Chain 3 
      Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
      Chain 3 Exception: normal_id_glm_lpdf: Scale vector is inf, but must be positive finite! (in 'C:/Users/DL/AppData/Local/Temp/RtmpERRA9z/model-12d437f47a61.stan', line 35, column 4 to column 62)
      Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
      Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
      Chain 3 
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
      
      Following the Sequential Effect eXistence and sIgnificance Testing (SEXIT)
      framework, we report the median of the posterior distribution and its 95% CI
      (Highest Density Interval), along the probability of direction (pd), the
      probability of significance and the probability of being large. The thresholds
      beyond which the effect is considered as significant (i.e., non-negligible) and
      large are |0.30| and |1.81| (corresponding respectively to 0.05 and 0.30 of the
      outcome's SD). Convergence and stability of the Bayesian sampling has been
      assessed using R-hat, which should be below 1.01 (Vehtari et al., 2019), and
      Effective Sample Size (ESS), which should be greater than 1000 (Burkner, 2017).

