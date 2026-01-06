# Report a descriptive table

Creates tables to describe different objects (see list of supported
objects in
[`report()`](https://easystats.github.io/report/reference/report.md)).

## Usage

``` r
report_table(x, ...)
```

## Arguments

- x:

  The R object that you want to report (see list of of supported objects
  above).

- ...:

  Arguments passed to or from other methods.

## Value

An object of class `report_table()`.

## Examples

``` r
# \donttest{
# Miscellaneous
r <- report_table(sessionInfo())
r
#> Package     |    Version |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Reference
#> --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#> BayesFactor | 0.9.12.4.7 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Morey R, Rouder J (2024). _BayesFactor: Computation of Bayes Factors for Common Designs_. R package version 0.9.12-4.7, <https://richarddmorey.github.io/BayesFactor/>.
#> Matrix      |      1.7.4 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                Bates D, Maechler M, Jagan M (2025). _Matrix: Sparse and Dense Matrix Classes and Methods_. doi:10.32614/CRAN.package.Matrix <https://doi.org/10.32614/CRAN.package.Matrix>, R package version 1.7-4, <https://CRAN.R-project.org/package=Matrix>.
#> R           |      4.5.2 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             R Core Team (2025). _R: A Language and Environment for Statistical Computing_. R Foundation for Statistical Computing, Vienna, Austria. <https://www.R-project.org/>.
#> Rcpp        |      1.1.0 | Eddelbuettel D, Francois R, Allaire J, Ushey K, Kou Q, Russell N, Ucar I, Bates D, Chambers J (2025). _Rcpp: Seamless R and C++ Integration_. R package version 1.1.0, <https://www.rcpp.org>. Eddelbuettel D, François R (2011). “Rcpp: Seamless R and C++ Integration.” _Journal of Statistical Software_, *40*(8), 1-18. doi:10.18637/jss.v040.i08 <https://doi.org/10.18637/jss.v040.i08>. Eddelbuettel D (2013). _Seamless R and C++ Integration with Rcpp_. Springer, New York. doi:10.1007/978-1-4614-6868-4 <https://doi.org/10.1007/978-1-4614-6868-4>, ISBN 978-1-4614-6867-7. Eddelbuettel D, Balamuta J (2018). “Extending R with C++: A Brief Introduction to Rcpp.” _The American Statistician_, *72*(1), 28-36. doi:10.1080/00031305.2017.1375990 <https://doi.org/10.1080/00031305.2017.1375990>.
#> bayestestR  |     0.17.0 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Makowski D, Ben-Shachar M, Lüdecke D (2019). “bayestestR: Describing Effects and their Uncertainty, Existence and Significance within the Bayesian Framework.” _Journal of Open Source Software_, *4*(40), 1541. doi:10.21105/joss.01541 <https://doi.org/10.21105/joss.01541>, <https://joss.theoj.org/papers/10.21105/joss.01541>.
#> brms        |     2.23.0 |                                                                                                                                                                                                                  Bürkner P (2017). “brms: An R Package for Bayesian Multilevel Models Using Stan.” _Journal of Statistical Software_, *80*(1), 1-28. doi:10.18637/jss.v080.i01 <https://doi.org/10.18637/jss.v080.i01>. Bürkner P (2018). “Advanced Bayesian Multilevel Modeling with the R Package brms.” _The R Journal_, *10*(1), 395-411. doi:10.32614/RJ-2018-017 <https://doi.org/10.32614/RJ-2018-017>. Bürkner P (2021). “Bayesian Item Response Modeling in R with brms and Stan.” _Journal of Statistical Software_, *100*(5), 1-54. doi:10.18637/jss.v100.i05 <https://doi.org/10.18637/jss.v100.i05>.
#> coda        |   0.19.4.1 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        Plummer M, Best N, Cowles K, Vines K (2006). “CODA: Convergence Diagnosis and Output Analysis for MCMC.” _R News_, *6*(1), 7-11. <https://journal.r-project.org/archive/>.
#> dplyr       |      1.1.4 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Wickham H, François R, Henry L, Müller K, Vaughan D (2023). _dplyr: A Grammar of Data Manipulation_. R package version 1.1.4, <https://dplyr.tidyverse.org>.
#> lavaan      |     0.6.21 |                                                                                                                                                                                                                                                                                                                                                                            Rosseel Y, Jorgensen T, De Wilde L (2025). _lavaan: Latent Variable Analysis_. doi:10.32614/CRAN.package.lavaan <https://doi.org/10.32614/CRAN.package.lavaan>, R package version 0.6-20, <https://CRAN.R-project.org/package=lavaan>. Rosseel Y (2012). “lavaan: An R Package for Structural Equation Modeling.” _Journal of Statistical Software_, *48*(2), 1-36. doi:10.18637/jss.v048.i02 <https://doi.org/10.18637/jss.v048.i02>.
#> lme4        |     1.1.38 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Bates D, Mächler M, Bolker B, Walker S (2015). “Fitting Linear Mixed-Effects Models Using lme4.” _Journal of Statistical Software_, *67*(1), 1-48. doi:10.18637/jss.v067.i01 <https://doi.org/10.18637/jss.v067.i01>.
#> modelbased  |     0.13.1 |                                                                                                                                                                                                                                                                                                                                                                                                                 Makowski D, Ben-Shachar M, Wiernik B, Patil I, Thériault R, Lüdecke D (2025). “modelbased: An R package to make the most out of your statistical models through marginal means, marginal effects, and model predictions.” _Journal of Open Source Software_, *10*(109), 7969. doi:10.21105/joss.07969 <https://doi.org/10.21105/joss.07969>, <https://joss.theoj.org/papers/10.21105/joss.07969>.
#> performance |     0.15.3 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Lüdecke D, Ben-Shachar M, Patil I, Waggoner P, Makowski D (2021). “performance: An R Package for Assessment, Comparison and Testing of Statistical Models.” _Journal of Open Source Software_, *6*(60), 3139. doi:10.21105/joss.03139 <https://doi.org/10.21105/joss.03139>.
#> report      |    0.6.2.1 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Makowski D, Lüdecke D, Patil I, Thériault R, Ben-Shachar M, Wiernik B (2023). “Automated Results Reporting as a Practical Tool to Improve Reproducibility and Methodological Best Practices Adoption.” _CRAN_. doi:10.32614/CRAN.package.report <https://doi.org/10.32614/CRAN.package.report>, <https://easystats.github.io/report/>.
#> rstanarm    |     2.32.2 |                                                                                                                                                                                                                                                                                                                                                                                                     Goodrich B, Gabry J, Ali I, Brilleman S (2025). “rstanarm: Bayesian applied regression modeling via Stan.” R package version 2.32.2, <https://mc-stan.org/rstanarm/>. Brilleman S, Crowther M, Moreno-Betancur M, Buros Novik J, Wolfe R (2018). “Joint longitudinal and time-to-event models via Stan.” StanCon 2018. 10-12 Jan 2018. Pacific Grove, CA, USA., <https://github.com/stan-dev/stancon_talks/>.
summary(r)
#> Package     |    Version
#> ------------------------
#> BayesFactor | 0.9.12.4.7
#> Matrix      |      1.7.4
#> R           |      4.5.2
#> Rcpp        |      1.1.0
#> bayestestR  |     0.17.0
#> brms        |     2.23.0
#> coda        |   0.19.4.1
#> dplyr       |      1.1.4
#> lavaan      |     0.6.21
#> lme4        |     1.1.38
#> modelbased  |     0.13.1
#> performance |     0.15.3
#> report      |    0.6.2.1
#> rstanarm    |     2.32.2

# Data
report_table(iris$Sepal.Length)
#> Mean |   SD | Median |  MAD |  Min |  Max | n_Obs | Skewness | Kurtosis | percentage_Missing
#> --------------------------------------------------------------------------------------------
#> 5.84 | 0.83 |   5.80 | 1.04 | 4.30 | 7.90 |   150 |     0.31 |    -0.55 |                  0
report_table(as.character(round(iris$Sepal.Length, 1)))
#> n_Entries | n_Obs | n_Missing | percentage_Missing
#> --------------------------------------------------
#> 35        |   150 |         0 |                  0
report_table(iris$Species)
#> Level      | n_Obs | percentage_Obs
#> -----------------------------------
#> setosa     |    50 |          33.33
#> versicolor |    50 |          33.33
#> virginica  |    50 |          33.33
report_table(iris)
#> Variable     |      Level | n_Obs | percentage_Obs | Mean |   SD | Median
#> -------------------------------------------------------------------------
#> Sepal.Length |            |   150 |                | 5.84 | 0.83 |   5.80
#> Sepal.Width  |            |   150 |                | 3.06 | 0.44 |   3.00
#> Petal.Length |            |   150 |                | 3.76 | 1.77 |   4.35
#> Petal.Width  |            |   150 |                | 1.20 | 0.76 |   1.30
#> Species      |     setosa |    50 |          33.33 |      |      |       
#> Species      | versicolor |    50 |          33.33 |      |      |       
#> Species      |  virginica |    50 |          33.33 |      |      |       
#> 
#> Variable     |  MAD |  Min |  Max | Skewness | Kurtosis | percentage_Missing
#> ----------------------------------------------------------------------------
#> Sepal.Length | 1.04 | 4.30 | 7.90 |     0.31 |    -0.55 |                  0
#> Sepal.Width  | 0.44 | 2.00 | 4.40 |     0.32 |     0.23 |                  0
#> Petal.Length | 1.85 | 1.00 | 6.90 |    -0.27 |    -1.40 |                  0
#> Petal.Width  | 1.04 | 0.10 | 2.50 |    -0.10 |    -1.34 |                  0
#> Species      |      |      |      |          |          |                   
#> Species      |      |      |      |          |          |                   
#> Species      |      |      |      |          |          |                   

# h-tests
report_table(t.test(mtcars$mpg ~ mtcars$am))
#> Welch Two Sample t-test
#> 
#> Parameter  |     Group | Mean_Group1 | Mean_Group2 | Difference
#> ---------------------------------------------------------------
#> mtcars$mpg | mtcars$am |       17.15 |       24.39 |      -7.24
#> 
#> Parameter  |          95% CI | t(18.33) |     p | Cohen's d |  Cohen's d  CI
#> ----------------------------------------------------------------------------
#> mtcars$mpg | [-11.28, -3.21] |    -3.77 | 0.001 |     -1.41 | [-2.26, -0.53]
#> 
#> Alternative hypothesis: two.sided

# ANOVAs
report_table(aov(Sepal.Length ~ Species, data = iris))
#> Parameter | Sum_Squares |  df | Mean_Square |      F |      p | Eta2 |  Eta2 95% CI
#> -----------------------------------------------------------------------------------
#> Species   |       63.21 |   2 |       31.61 | 119.26 | < .001 | 0.62 | [0.54, 1.00]
#> Residuals |       38.96 | 147 |        0.27 |        |        |      |             

# GLMs
report_table(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#> Parameter                           | Coefficient |         95% CI | t(144)
#> ---------------------------------------------------------------------------
#> (Intercept)                         |        4.21 | [ 3.41,  5.02] |  10.34
#> Petal Length                        |        0.54 | [ 0.00,  1.09] |   1.96
#> Species [versicolor]                |       -1.81 | [-2.99, -0.62] |  -3.02
#> Species [virginica]                 |       -3.15 | [-4.41, -1.90] |  -4.97
#> Petal Length × Species [versicolor] |        0.29 | [-0.30,  0.87] |   0.97
#> Petal Length × Species [virginica]  |        0.45 | [-0.12,  1.03] |   1.56
#>                                     |             |                |       
#> AIC                                 |             |                |       
#> AICc                                |             |                |       
#> BIC                                 |             |                |       
#> R2                                  |             |                |       
#> R2 (adj.)                           |             |                |       
#> Sigma                               |             |                |       
#> 
#> Parameter                           |      p | Std. Coef. | Std. Coef. 95% CI |    Fit
#> --------------------------------------------------------------------------------------
#> (Intercept)                         | < .001 |       0.49 |    [-1.03,  2.01] |       
#> Petal Length                        | 0.052  |       1.16 |    [-0.01,  2.32] |       
#> Species [versicolor]                | 0.003  |      -0.88 |    [-2.41,  0.65] |       
#> Species [virginica]                 | < .001 |      -1.75 |    [-3.32, -0.18] |       
#> Petal Length × Species [versicolor] | 0.334  |       0.61 |    [-0.63,  1.85] |       
#> Petal Length × Species [virginica]  | 0.120  |       0.97 |    [-0.26,  2.19] |       
#>                                     |        |            |                   |       
#> AIC                                 |        |            |                   | 106.77
#> AICc                                |        |            |                   | 107.56
#> BIC                                 |        |            |                   | 127.84
#> R2                                  |        |            |                   |   0.84
#> R2 (adj.)                           |        |            |                   |   0.83
#> Sigma                               |        |            |                   |   0.34
report_table(glm(vs ~ disp, data = mtcars, family = "binomial"))
#> Parameter   | Coefficient |         95% CI |     z |     p | Std. Coef.
#> -----------------------------------------------------------------------
#> (Intercept) |        4.14 | [ 1.81,  7.44] |  2.98 | 0.003 |      -0.85
#> disp        |       -0.02 | [-0.04, -0.01] | -3.03 | 0.002 |      -2.68
#>             |             |                |       |       |           
#> AIC         |             |                |       |       |           
#> AICc        |             |                |       |       |           
#> BIC         |             |                |       |       |           
#> Tjur's R2   |             |                |       |       |           
#> Sigma       |             |                |       |       |           
#> Log_loss    |             |                |       |       |           
#> 
#> Parameter   | Std. Coef. 95% CI |   Fit
#> ---------------------------------------
#> (Intercept) |    [-2.42,  0.27] |      
#> disp        |    [-4.90, -1.27] |      
#>             |                   |      
#> AIC         |                   | 26.70
#> AICc        |                   | 27.11
#> BIC         |                   | 29.63
#> Tjur's R2   |                   |  0.53
#> Sigma       |                   |  1.00
#> Log_loss    |                   |  0.35
# }

# \donttest{
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
report_table(model)
#> Parameter        | Coefficient |       95% CI | t(146) |      p | Effects
#> -------------------------------------------------------------------------
#> (Intercept)      |        2.50 | [1.19, 3.82] |   3.75 | < .001 |   fixed
#> Petal Length     |        0.89 | [0.76, 1.01] |  13.93 | < .001 |   fixed
#>                  |        1.08 |              |        |        |  random
#>                  |        0.34 |              |        |        |  random
#>                  |             |              |        |        |        
#> AIC              |             |              |        |        |        
#> AICc             |             |              |        |        |        
#> BIC              |             |              |        |        |        
#> R2 (conditional) |             |              |        |        |        
#> R2 (marginal)    |             |              |        |        |        
#> Sigma            |             |              |        |        |        
#> 
#> Parameter        |    Group | Std. Coef. | Std. Coef. 95% CI |    Fit
#> ---------------------------------------------------------------------
#> (Intercept)      |          |  -1.46e-13 |     [-1.49, 1.49] |       
#> Petal Length     |          |       1.89 |     [ 1.63, 2.16] |       
#>                  |  Species |            |                   |       
#>                  | Residual |            |                   |       
#>                  |          |            |                   |       
#> AIC              |          |            |                   | 127.79
#> AICc             |          |            |                   | 128.07
#> BIC              |          |            |                   | 139.84
#> R2 (conditional) |          |            |                   |   0.97
#> R2 (marginal)    |          |            |                   |   0.66
#> Sigma            |          |            |                   |   0.34
# }
# \donttest{
# Bayesian models
library(rstanarm)
model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
report_table(model, effectsize_method = "basic")
#> Parameter         | Median |       95% CI |   pd |  Rhat |  ESS
#> ---------------------------------------------------------------
#> (Intercept)       |   5.01 | [4.86, 5.15] | 100% | 0.998 |  980
#> Speciesversicolor |   0.93 | [0.72, 1.13] | 100% | 0.999 |  911
#> Speciesvirginica  |   1.58 | [1.37, 1.78] | 100% | 0.998 | 1119
#>                   |        |              |      |       |     
#> ELPD              |        |              |      |       |     
#> LOOIC             |        |              |      |       |     
#> WAIC              |        |              |      |       |     
#> R2                |        |              |      |       |     
#> R2 (adj.)         |        |              |      |       |     
#> Sigma             |        |              |      |       |     
#> 
#> Parameter         |                 Prior | Std. Median | Std_Median 95% CI |     Fit
#> -------------------------------------------------------------------------------------
#> (Intercept)       | Normal (5.84 +- 2.07) |        0.00 |      [0.00, 0.00] |        
#> Speciesversicolor | Normal (0.00 +- 4.38) |        0.53 |      [0.41, 0.65] |        
#> Speciesvirginica  | Normal (0.00 +- 4.38) |        0.90 |      [0.78, 1.02] |        
#>                   |                       |             |                   |        
#> ELPD              |                       |             |                   | -115.96
#> LOOIC             |                       |             |                   |  231.92
#> WAIC              |                       |             |                   |  231.88
#> R2                |                       |             |                   |    0.62
#> R2 (adj.)         |                       |             |                   |    0.61
#> Sigma             |                       |             |                   |    0.52
# }
# \donttest{
# Structural Equation Models (SEM)
library(lavaan)
structure <- "ind60 =~ x1 + x2 + x3
              dem60 =~ y1 + y2 + y3
              dem60 ~ ind60"
model <- lavaan::sem(structure, data = PoliticalDemocracy)
suppressWarnings(report_table(model))
#> Parameter     | Coefficient |       95% CI |     z |      p |  Component |     Fit
#> ----------------------------------------------------------------------------------
#> ind60 =~ x1   |        1.00 | [1.00, 1.00] |       | < .001 |    Loading |        
#> ind60 =~ x2   |        2.18 | [1.91, 2.45] | 15.59 | < .001 |    Loading |        
#> ind60 =~ x3   |        1.82 | [1.52, 2.12] | 11.96 | < .001 |    Loading |        
#> dem60 =~ y1   |        1.00 | [1.00, 1.00] |       | < .001 |    Loading |        
#> dem60 =~ y2   |        1.04 | [0.66, 1.43] |  5.33 | < .001 |    Loading |        
#> dem60 =~ y3   |        0.98 | [0.65, 1.30] |  5.89 | < .001 |    Loading |        
#> dem60 ~ ind60 |        1.37 | [0.53, 2.21] |  3.20 | 0.001  | Regression |        
#>               |             |              |       |        |            |        
#> Chi2          |             |              |       |        |            |    7.98
#> Chi2_df       |             |              |       |        |            |    8.00
#> p_Chi2        |             |              |       |        |            |    0.44
#> p_Baseline    |             |              |       |        |            |    0.00
#> GFI           |             |              |       |        |            |    0.97
#> AGFI          |             |              |       |        |            |    0.91
#> NFI           |             |              |       |        |            |    0.97
#> NNFI          |             |              |       |        |            |    1.00
#> CFI           |             |              |       |        |            |    1.00
#> RMSEA         |             |              |       |        |            |    0.00
#> RMSEA_CI_low  |             |              |       |        |            |    0.00
#> RMSEA_CI_high |             |              |       |        |            |    0.14
#> p_RMSEA       |             |              |       |        |            |    0.57
#> RMR           |             |              |       |        |            |    0.10
#> SRMR          |             |              |       |        |            |    0.03
#> RFI           |             |              |       |        |            |    0.95
#> PNFI          |             |              |       |        |            |    0.52
#> IFI           |             |              |       |        |            |    1.00
#> RNI           |             |              |       |        |            |    1.00
#> Loglikelihood |             |              |       |        |            | -778.27
#> AIC           |             |              |       |        |            | 1582.54
#> BIC           |             |              |       |        |            | 1612.67
#> BIC (adj.)    |             |              |       |        |            | 1571.69
# }
```
