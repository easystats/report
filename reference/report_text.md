# Report a textual description of an object

Creates text containing a description of the parameters of R objects
(see list of supported objects in
[`report()`](https://easystats.github.io/report/reference/report.md)).

## Usage

``` r
report_text(x, table = NULL, ...)
```

## Arguments

- x:

  The R object that you want to report (see list of of supported objects
  above).

- table:

  A table obtained via
  [`report_table()`](https://easystats.github.io/report/reference/report_table.md).
  If not provided, will run it.

- ...:

  Arguments passed to or from other methods.

## Value

An object of class `report_text()`.

## Examples

``` r
library(report)

# Miscellaneous
r <- report_text(sessionInfo())
r
#> Analyses were conducted using the R Statistical language (version 4.5.2; R Core
#> Team, 2025) on Ubuntu 24.04.3 LTS, using the packages Matrix (version 1.7.4;
#> Bates D et al., 2025), lme4 (version 1.1.38; Bates D et al., 2015), brms
#> (version 2.23.0; Bürkner P, 2017), Rcpp (version 1.1.1; Eddelbuettel D et al.,
#> 2026), rstanarm (version 2.32.2; Goodrich B et al., 2025), performance (version
#> 0.15.3; Lüdecke D et al., 2021), bayestestR (version 0.17.0; Makowski D et al.,
#> 2019), modelbased (version 0.13.1; Makowski D et al., 2025), report (version
#> 0.6.3; Makowski D et al., 2023), BayesFactor (version 0.9.12.4.7; Morey R,
#> Rouder J, 2024), coda (version 0.19.4.1; Plummer M et al., 2006), lavaan
#> (version 0.6.21; Rosseel Y et al., 2025) and dplyr (version 1.2.0; Wickham H et
#> al., 2026).
#> 
#> References
#> ----------
#>   - Bates D, Maechler M, Jagan M (2025). _Matrix: Sparse and Dense Matrix Classes
#> and Methods_. doi:10.32614/CRAN.package.Matrix
#> <https://doi.org/10.32614/CRAN.package.Matrix>, R package version 1.7-4,
#> <https://CRAN.R-project.org/package=Matrix>.
#>   - Bates D, Mächler M, Bolker B, Walker S (2015). “Fitting Linear Mixed-Effects
#> Models Using lme4.” _Journal of Statistical Software_, *67*(1), 1-48.
#> doi:10.18637/jss.v067.i01 <https://doi.org/10.18637/jss.v067.i01>.
#>   - Bürkner P (2017). “brms: An R Package for Bayesian Multilevel Models Using
#> Stan.” _Journal of Statistical Software_, *80*(1), 1-28.
#> doi:10.18637/jss.v080.i01 <https://doi.org/10.18637/jss.v080.i01>. Bürkner P
#> (2018). “Advanced Bayesian Multilevel Modeling with the R Package brms.” _The R
#> Journal_, *10*(1), 395-411. doi:10.32614/RJ-2018-017
#> <https://doi.org/10.32614/RJ-2018-017>. Bürkner P (2021). “Bayesian Item
#> Response Modeling in R with brms and Stan.” _Journal of Statistical Software_,
#> *100*(5), 1-54. doi:10.18637/jss.v100.i05
#> <https://doi.org/10.18637/jss.v100.i05>.
#>   - Eddelbuettel D, Francois R, Allaire J, Ushey K, Kou Q, Russell N, Ucar I,
#> Bates D, Chambers J (2026). _Rcpp: Seamless R and C++ Integration_. R package
#> version 1.1.1, <https://www.rcpp.org>. Eddelbuettel D, François R (2011).
#> “Rcpp: Seamless R and C++ Integration.” _Journal of Statistical Software_,
#> *40*(8), 1-18. doi:10.18637/jss.v040.i08
#> <https://doi.org/10.18637/jss.v040.i08>. Eddelbuettel D (2013). _Seamless R and
#> C++ Integration with Rcpp_. Springer, New York. doi:10.1007/978-1-4614-6868-4
#> <https://doi.org/10.1007/978-1-4614-6868-4>, ISBN 978-1-4614-6867-7.
#> Eddelbuettel D, Balamuta J (2018). “Extending R with C++: A Brief Introduction
#> to Rcpp.” _The American Statistician_, *72*(1), 28-36.
#> doi:10.1080/00031305.2017.1375990
#> <https://doi.org/10.1080/00031305.2017.1375990>.
#>   - Goodrich B, Gabry J, Ali I, Brilleman S (2025). “rstanarm: Bayesian applied
#> regression modeling via Stan.” R package version 2.32.2,
#> <https://mc-stan.org/rstanarm/>. Brilleman S, Crowther M, Moreno-Betancur M,
#> Buros Novik J, Wolfe R (2018). “Joint longitudinal and time-to-event models via
#> Stan.” StanCon 2018. 10-12 Jan 2018. Pacific Grove, CA, USA.,
#> <https://github.com/stan-dev/stancon_talks/>.
#>   - Lüdecke D, Ben-Shachar M, Patil I, Waggoner P, Makowski D (2021).
#> “performance: An R Package for Assessment, Comparison and Testing of
#> Statistical Models.” _Journal of Open Source Software_, *6*(60), 3139.
#> doi:10.21105/joss.03139 <https://doi.org/10.21105/joss.03139>.
#>   - Makowski D, Ben-Shachar M, Lüdecke D (2019). “bayestestR: Describing Effects
#> and their Uncertainty, Existence and Significance within the Bayesian
#> Framework.” _Journal of Open Source Software_, *4*(40), 1541.
#> doi:10.21105/joss.01541 <https://doi.org/10.21105/joss.01541>,
#> <https://joss.theoj.org/papers/10.21105/joss.01541>.
#>   - Makowski D, Ben-Shachar M, Wiernik B, Patil I, Thériault R, Lüdecke D (2025).
#> “modelbased: An R package to make the most out of your statistical models
#> through marginal means, marginal effects, and model predictions.” _Journal of
#> Open Source Software_, *10*(109), 7969. doi:10.21105/joss.07969
#> <https://doi.org/10.21105/joss.07969>,
#> <https://joss.theoj.org/papers/10.21105/joss.07969>.
#>   - Makowski D, Lüdecke D, Patil I, Thériault R, Ben-Shachar M, Wiernik B (2023).
#> “Automated Results Reporting as a Practical Tool to Improve Reproducibility and
#> Methodological Best Practices Adoption.” _CRAN_.
#> doi:10.32614/CRAN.package.report
#> <https://doi.org/10.32614/CRAN.package.report>,
#> <https://easystats.github.io/report/>.
#>   - Morey R, Rouder J (2024). _BayesFactor: Computation of Bayes Factors for
#> Common Designs_. R package version 0.9.12-4.7,
#> <https://richarddmorey.github.io/BayesFactor/>.
#>   - Plummer M, Best N, Cowles K, Vines K (2006). “CODA: Convergence Diagnosis and
#> Output Analysis for MCMC.” _R News_, *6*(1), 7-11.
#> <https://journal.r-project.org/archive/>.
#>   - R Core Team (2025). _R: A Language and Environment for Statistical
#> Computing_. R Foundation for Statistical Computing, Vienna, Austria.
#> <https://www.R-project.org/>.
#>   - Rosseel Y, Jorgensen T, De Wilde L (2025). _lavaan: Latent Variable
#> Analysis_. doi:10.32614/CRAN.package.lavaan
#> <https://doi.org/10.32614/CRAN.package.lavaan>, R package version 0.6-20,
#> <https://CRAN.R-project.org/package=lavaan>. Rosseel Y (2012). “lavaan: An R
#> Package for Structural Equation Modeling.” _Journal of Statistical Software_,
#> *48*(2), 1-36. doi:10.18637/jss.v048.i02
#> <https://doi.org/10.18637/jss.v048.i02>.
#>   - Wickham H, François R, Henry L, Müller K, Vaughan D (2026). _dplyr: A Grammar
#> of Data Manipulation_. R package version 1.2.0, <https://dplyr.tidyverse.org>.
summary(r)
#> The analysis was done using the R Statistical language (v4.5.2; R Core Team,
#> 2025) on Ubuntu 24.04.3 LTS, using the packages Matrix (v1.7.4), lme4
#> (v1.1.38), brms (v2.23.0), Rcpp (v1.1.1), rstanarm (v2.32.2), performance
#> (v0.15.3), bayestestR (v0.17.0), modelbased (v0.13.1), report (v0.6.3),
#> BayesFactor (v0.9.12.4.7), coda (v0.19.4.1), lavaan (v0.6.21) and dplyr
#> (v1.2.0).

# Data
report_text(iris$Sepal.Length)
#> iris$Sepal.Length: n = 150, Mean = 5.84, SD = 0.83, Median = 5.80, MAD = 1.04,
#> range: [4.30, 7.90], Skewness = 0.31, Kurtosis = -0.55, 0% missing
report_text(as.character(round(iris$Sepal.Length, 1)))
#> as.character(round(iris$Sepal.Length, 1)): 35 entries, such as 5 (6.67%); 5.1
#> (6.00%); 6.3 (6.00%) and 32 others (0 missing)
report_text(iris$Species)
#> iris$Species: 3 levels, namely setosa (n = 50, 33.33%), versicolor (n = 50,
#> 33.33%) and virginica (n = 50, 33.33%)
report_text(iris)
#> The data contains 150 observations of the following 5 variables:
#> 
#>   - Sepal.Length: n = 150, Mean = 5.84, SD = 0.83, Median = 5.80, MAD = 1.04,
#> range: [4.30, 7.90], Skewness = 0.31, Kurtosis = -0.55, 0% missing
#>   - Sepal.Width: n = 150, Mean = 3.06, SD = 0.44, Median = 3.00, MAD = 0.44,
#> range: [2, 4.40], Skewness = 0.32, Kurtosis = 0.23, 0% missing
#>   - Petal.Length: n = 150, Mean = 3.76, SD = 1.77, Median = 4.35, MAD = 1.85,
#> range: [1, 6.90], Skewness = -0.27, Kurtosis = -1.40, 0% missing
#>   - Petal.Width: n = 150, Mean = 1.20, SD = 0.76, Median = 1.30, MAD = 1.04,
#> range: [0.10, 2.50], Skewness = -0.10, Kurtosis = -1.34, 0% missing
#>   - Species: 3 levels, namely setosa (n = 50, 33.33%), versicolor (n = 50,
#> 33.33%) and virginica (n = 50, 33.33%)

# h-tests
report_text(t.test(iris$Sepal.Width, iris$Sepal.Length))
#> Effect sizes were labelled following Cohen's (1988) recommendations.
#> 
#> The Welch Two Sample t-test testing the difference between iris$Sepal.Width and
#> iris$Sepal.Length (mean of x = 3.06, mean of y = 5.84) suggests that the effect
#> is negative, statistically significant, and large (difference = -2.79, 95% CI
#> [-2.94, -2.64], t(225.68) = -36.46, p < .001; Cohen's d = -4.21, 95% CI [-4.66,
#> -3.76])

# ANOVA
r <- report_text(aov(Sepal.Length ~ Species, data = iris))
r
#> The ANOVA (formula: Sepal.Length ~ Species) suggests that:
#> 
#>   - The main effect of Species is statistically significant and large (F(2, 147)
#> = 119.26, p < .001; Eta2 = 0.62, 95% CI [0.54, 1.00])
#> 
#> Effect sizes were labelled following Field's (2013) recommendations.
summary(r)
#> The ANOVA suggests that:
#> 
#>   - The main effect of Species is statistically significant and large (F(2, 147)
#> = 119.26, p < .001, Eta2 = 0.62)

# GLMs
r <- report_text(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
r
#> We fitted a linear model (estimated using OLS) to predict Sepal.Length with
#> Petal.Length and Species (formula: Sepal.Length ~ Petal.Length * Species). The
#> model explains a statistically significant and substantial proportion of
#> variance (R2 = 0.84, F(5, 144) = 151.71, p < .001, adj. R2 = 0.83). The model's
#> intercept, corresponding to Petal.Length = 0 and Species = setosa, is at 4.21
#> (95% CI [3.41, 5.02], t(144) = 10.34, p < .001). Within this model:
#> 
#>   - The effect of Petal Length is statistically non-significant and positive
#> (beta = 0.54, 95% CI [-4.76e-03, 1.09], t(144) = 1.96, p = 0.052; Std. beta =
#> 1.16, 95% CI [-0.01, 2.32])
#>   - The effect of Species [versicolor] is statistically significant and negative
#> (beta = -1.81, 95% CI [-2.99, -0.62], t(144) = -3.02, p = 0.003; Std. beta =
#> -0.88, 95% CI [-2.41, 0.65])
#>   - The effect of Species [virginica] is statistically significant and negative
#> (beta = -3.15, 95% CI [-4.41, -1.90], t(144) = -4.97, p < .001; Std. beta =
#> -1.75, 95% CI [-3.32, -0.18])
#>   - The effect of Petal Length × Species [versicolor] is statistically
#> non-significant and positive (beta = 0.29, 95% CI [-0.30, 0.87], t(144) = 0.97,
#> p = 0.334; Std. beta = 0.61, 95% CI [-0.63, 1.85])
#>   - The effect of Petal Length × Species [virginica] is statistically
#> non-significant and positive (beta = 0.45, 95% CI [-0.12, 1.03], t(144) = 1.56,
#> p = 0.120; Std. beta = 0.97, 95% CI [-0.26, 2.19])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
summary(r)
#> We fitted a linear model to predict Sepal.Length with Petal.Length and Species.
#> The model's explanatory power is substantial (R2 = 0.84, adj. R2 = 0.83). The
#> model's intercept is at 4.21 (95% CI [3.41, 5.02]). Within this model:
#> 
#>   - The effect of Petal Length is statistically non-significant and positive
#> (beta = 0.54, 95% CI [-4.76e-03, 1.09], t(144) = 1.96, p = 0.052, Std. beta =
#> 1.16)
#>   - The effect of Species [versicolor] is statistically significant and negative
#> (beta = -1.81, 95% CI [-2.99, -0.62], t(144) = -3.02, p = 0.003, Std. beta =
#> -0.88)
#>   - The effect of Species [virginica] is statistically significant and negative
#> (beta = -3.15, 95% CI [-4.41, -1.90], t(144) = -4.97, p < .001, Std. beta =
#> -1.75)
#>   - The effect of Petal Length × Species [versicolor] is statistically
#> non-significant and positive (beta = 0.29, 95% CI [-0.30, 0.87], t(144) = 0.97,
#> p = 0.334, Std. beta = 0.61)
#>   - The effect of Petal Length × Species [virginica] is statistically
#> non-significant and positive (beta = 0.45, 95% CI [-0.12, 1.03], t(144) = 1.56,
#> p = 0.120, Std. beta = 0.97)

# \donttest{
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
r <- report_text(model)
r
#> We fitted a linear mixed model (estimated using REML and nloptwrap optimizer)
#> to predict Sepal.Length with Petal.Length (formula: Sepal.Length ~
#> Petal.Length). The model included Species as random effect (formula: ~1 |
#> Species). The model's total explanatory power is substantial (conditional R2 =
#> 0.97) and the part related to the fixed effects alone (marginal R2) is of 0.66.
#> The model's intercept, corresponding to Petal.Length = 0, is at 2.50 (95% CI
#> [1.19, 3.82], t(146) = 3.75, p < .001). Within this model:
#> 
#>   - The effect of Petal Length is statistically significant and positive (beta =
#> 0.89, 95% CI [0.76, 1.01], t(146) = 13.93, p < .001; Std. beta = 1.89, 95% CI
#> [1.63, 2.16])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
summary(r)
#> We fitted a linear mixed model to predict Sepal.Length with Petal.Length. The
#> model included Species as random effect. The model's total explanatory power is
#> substantial (conditional R2 = 0.97) and the part related to the fixed effects
#> alone (marginal R2) is of 0.66. The model's intercept is at 2.50 (95% CI [1.19,
#> 3.82]). Within this model:
#> 
#>   - The effect of Petal Length is statistically significant and positive (beta =
#> 0.89, 95% CI [0.76, 1.01], t(146) = 13.93, p < .001, Std. beta = 1.89)
# }
# \donttest{
# Bayesian models
library(rstanarm)
model <- suppressWarnings(stan_glm(mpg ~ cyl + wt, data = mtcars, refresh = 0, iter = 600))
r <- report_text(model)
r
#> We fitted a Bayesian linear model (estimated using MCMC sampling with 4 chains
#> of 600 iterations and a warmup of 300) to predict mpg with cyl and wt (formula:
#> mpg ~ cyl + wt). Priors over parameters were all set as normal (mean = 0.00, SD
#> = 8.44; mean = 0.00, SD = 15.40) distributions. The model's explanatory power
#> is substantial (R2 = 0.81, 95% CI [0.71, 0.89], adj. R2 = 0.80). The model's
#> intercept, corresponding to cyl = 0 and wt = 0, is at 39.70 (95% CI [36.11,
#> 43.29]). Within this model:
#> 
#>   - The effect of cyl (Median = -1.49, 95% CI [-2.28, -0.67]) has a 100.00%
#> probability of being negative (< 0), 99.83% of being significant (< -0.30), and
#> 21.33% of being large (< -1.81). The estimation successfully converged (Rhat =
#> 1.002) but the indices are unreliable (ESS = 743)
#>   - The effect of wt (Median = -3.22, 95% CI [-4.67, -1.80]) has a 100.00%
#> probability of being negative (< 0), 100.00% of being significant (< -0.30),
#> and 97.33% of being large (< -1.81). The estimation successfully converged
#> (Rhat = 0.999) but the indices are unreliable (ESS = 668)
#> 
#> Following the Sequential Effect eXistence and sIgnificance Testing (SEXIT)
#> framework, we report the median of the posterior distribution and its 95% CI
#> (Highest Density Interval), along the probability of direction (pd), the
#> probability of significance and the probability of being large. The thresholds
#> beyond which the effect is considered as significant (i.e., non-negligible) and
#> large are |0.30| and |1.81| (corresponding respectively to 0.05 and 0.30 of the
#> outcome's SD). Convergence and stability of the Bayesian sampling has been
#> assessed using R-hat, which should be below 1.01 (Vehtari et al., 2019), and
#> Effective Sample Size (ESS), which should be greater than 1000 (Burkner, 2017).
summary(r)
#> We fitted a Bayesian linear model to predict mpg with cyl and wt. Priors over
#> parameters were all set as normal (mean = 0.00, SD = 8.44; mean = 0.00, SD =
#> 15.40) distributions. The model's explanatory power is substantial (R2 = 0.81,
#> adj. R2 = 0.80). The model's intercept is at 39.70 (95% CI [36.11, 43.29]).
#> Within this model:
#> 
#>   - The effect of cyl (Median = -1.49, 95% CI [-2.28, -0.67]) has 100.00%, 99.83%
#> and 21.33% probability of being negative (< 0), significant (< -0.30) and large
#> (< -1.81). The estimation successfully converged (Rhat = 1.002) but the indices
#> are unreliable (ESS = 743)
#>   - The effect of wt (Median = -3.22, 95% CI [-4.67, -1.80]) has 100.00%, 100.00%
#> and 97.33% probability of being negative (< 0), significant (< -0.30) and large
#> (< -1.81). The estimation successfully converged (Rhat = 0.999) but the indices
#> are unreliable (ESS = 668)
# }
```
