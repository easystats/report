---
title: "report: Automated Reporting of Results and Statistical Models in R"
tags:
  - R
  - easystats
authors:
- affiliation: 1
  name: Dominique Makowski
  orcid: 0000-0001-5375-9967
- affiliation: 2
  name: Indrajeet Patil
  orcid: 0000-0003-1995-6531
- affiliation: 3
  name: Mattan S. Ben-Shachar
  orcid: 0000-0002-4287-4801
- affiliation: 4
  name: Brenton M. Wiernik^[Brenton Wiernik is currently an independent researcher and Research Scientist at Meta, Demography and Survey Science. The current work was done in an independent capacity.]
  orcid: 0000-0001-9560-6336
- affiliation: 5
  name: Etienne Bacher
  orcid: 0000-0002-9271-5075 
- affiliation: 6
  name: Daniel Lüdecke
  orcid: 0000-0002-8895-3206
- affiliation: 7
  name: Rémi Thériault
  orcid: 0000-0003-4315-6788
    
affiliations:
- index: 1
  name: Nanyang Technological University, Singapore
- index: 2
  name: Center for Humans and Machines, Max Planck Institute for Human Development, Berlin, Germany
- index: 3
  name: Ben-Gurion University of the Negev, Israel
- index: 4
  name: Independent Researcher
- index: 5
  name: Luxembourg Institute of Socio-Economic Research (LISER), Luxembourg
- index: 6
  name: University Medical Center Hamburg-Eppendorf, Germany
- index: 7
  name: Université du Québec à Montréal, Montréal, Canada
      
date: "2023-02-22"
bibliography: paper.bib
output: rticles::joss_article
csl: apa.csl
journal: JOSS
link-citations: yes
---



# Summary

The `{report}` package is a powerful tool for researchers who use R to analyze data and create reports for publication. It bridges the gap between R's output and the formatted results to be included in a manuscript, allowing users to easily convert statistical models and data frames into textual reports that are suitable for publication. This paper provides an overview of this package, including its features, advantages, and how to use it. We also provide examples of how the package can be used to standardize and improve results reporting in R.

# Statement of Need

Reporting results is a crucial part of scientific research. Researchers need to ensure that their results are reported accurately and clearly, so that other researchers can understand and reproduce their work. However, the process of results reporting can be time-consuming and error-prone, particularly when it comes to formatting data for publication. The `{report}` package was developed to address this problem, providing researchers with a tool that can help standardize and improve reporting results from their workflows in R.

# Features

The package includes several features that make it a valuable tool for researchers. It can convert statistical models and data frames into textual reports, which can be easily customized and formatted to meet the requirements of a particular journal or publication. The package supports a wide range of output formats, including HTML, LaTeX, and Microsoft Word, via RMarkdown.

Using this package in an analytic workflow has several advantages. First, it can help standardize results reporting across a research team or project, ensuring that everyone is using the same format and style. Second, the package can save researchers time by automating many of the tasks involved in reporting results, such as formatting tables and text. Third, the package can improve the quality of results reporting by providing users with a tool that is specifically designed for this purpose. Additionally, it prevents any copy-and-paste errors.

The examples below illustrate the ease with which `{report}` can create detailed textual or tabular summaries for statistical objects:


```r
library(report)

m_lm <- lm(mpg ~ qsec + wt, data = mtcars)
report(m_lm)
#> We fitted a linear model (estimated using OLS) to predict
#> mpg with qsec and wt (formula: mpg ~ qsec + wt). The model
#> explains a statistically significant and substantial
#> proportion of variance (R2 = 0.83, F(2, 29) = 69.03, p <
#> .001, adj. R2 = 0.81). The model's intercept, corresponding
#> to qsec = 0 and wt = 0, is at 19.75 (95% CI [9.00, 30.49],
#> t(29) = 3.76, p < .001). Within this model:
#> 
#>   - The effect of qsec is statistically significant and
#> positive (beta = 0.93, 95% CI [0.39, 1.47], t(29) = 3.51, p
#> = 0.001; Std. beta = 0.28, 95% CI [0.11, 0.44])
#>   - The effect of wt is statistically significant and
#> negative (beta = -5.05, 95% CI [-6.04, -4.06], t(29) =
#> -10.43, p < .001; Std. beta = -0.82, 95% CI [-0.98, -0.66])
#> 
#> Standardized parameters were obtained by fitting the model
#> on a standardized version of the dataset. 95% Confidence
#> Intervals (CIs) and p-values were computed using a Wald
#> t-distribution approximation.

library(lme4)
m_lmer <- lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
report(m_lmer)
#> We fitted a linear mixed model (estimated using REML and
#> nloptwrap optimizer) to predict Sepal.Length with
#> Petal.Length (formula: Sepal.Length ~ Petal.Length). The
#> model included Species as random effect (formula: ~1 |
#> Species). The model's total explanatory power is
#> substantial (conditional R2 = 0.97) and the part related to
#> the fixed effects alone (marginal R2) is of 0.66. The
#> model's intercept, corresponding to Petal.Length = 0, is at
#> 2.50 (95% CI [1.19, 3.82], t(146) = 3.75, p < .001). Within
#> this model:
#> 
#>   - The effect of Petal Length is statistically significant
#> and positive (beta = 0.89, 95% CI [0.76, 1.01], t(146) =
#> 13.93, p < .001; Std. beta = 1.89, 95% CI [1.63, 2.16])
#> 
#> Standardized parameters were obtained by fitting the model
#> on a standardized version of the dataset. 95% Confidence
#> Intervals (CIs) and p-values were computed using a Wald
#> t-distribution approximation.

library(rstanarm)
m_rstan <- stan_glm(mpg ~ qsec + wt, data = mtcars, refresh = 0, iter = 1000)
report(m_rstan)
#> We fitted a Bayesian linear model (estimated using MCMC
#> sampling with 4 chains of 1000 iterations and a warmup of
#> 500) to predict mpg with qsec and wt (formula: mpg ~ qsec +
#> wt). Priors over parameters were set as normal (mean =
#> 0.00, SD = 8.43) distributions. The model's explanatory
#> power is substantial (R2 = 0.81, 95% CI [0.69, 0.89], adj.
#> R2 = 0.79). The model's intercept, corresponding to qsec =
#> 0 and wt = 0, is at 19.59 (95% CI [8.71, 30.63]). Within
#> this model:
#> 
#>   - The effect of qsec (Median = 0.93, 95% CI [0.38, 1.50])
#> has a 99.85% probability of being positive (> 0), 98.65% of
#> being significant (> 0.30), and 0.10% of being large (>
#> 1.81). The estimation successfully converged (Rhat = 1.001)
#> and the indices are reliable (ESS = 2048)
#>   - The effect of wt (Median = -5.05, 95% CI [-6.07, -4.05])
#> has a 100.00% probability of being negative (< 0), 100.00%
#> of being significant (< -0.30), and 100.00% of being large
#> (< -1.81). The estimation successfully converged (Rhat =
#> 0.999) and the indices are reliable (ESS = 1744)
#> 
#> Following the Sequential Effect eXistence and sIgnificance
#> Testing (SEXIT) framework, we report the median of the
#> posterior distribution and its 95% CI (Highest Density
#> Interval), along the probability of direction (pd), the
#> probability of significance and the probability of being
#> large. The thresholds beyond which the effect is considered
#> as significant (i.e., non-negligible) and large are |0.30|
#> and |1.81| (corresponding respectively to 0.05 and 0.30 of
#> the outcome's SD). Convergence and stability of the
#> Bayesian sampling has been assessed using R-hat, which
#> should be below 1.01 (Vehtari et al., 2019), and Effective
#> Sample Size (ESS), which should be greater than 1000
#> (Burkner, 2017). and We fitted a Bayesian linear model
#> (estimated using MCMC sampling with 4 chains of 1000
#> iterations and a warmup of 500) to predict mpg with qsec
#> and wt (formula: mpg ~ qsec + wt). Priors over parameters
#> were set as normal (mean = 0.00, SD = 15.40) distributions.
#> The model's explanatory power is substantial (R2 = 0.81,
#> 95% CI [0.69, 0.89], adj. R2 = 0.79). The model's
#> intercept, corresponding to qsec = 0 and wt = 0, is at
#> 19.59 (95% CI [8.71, 30.63]). Within this model:
#> 
#>   - The effect of qsec (Median = 0.93, 95% CI [0.38, 1.50])
#> has a 99.85% probability of being positive (> 0), 98.65% of
#> being significant (> 0.30), and 0.10% of being large (>
#> 1.81). The estimation successfully converged (Rhat = 1.001)
#> and the indices are reliable (ESS = 2048)
#>   - The effect of wt (Median = -5.05, 95% CI [-6.07, -4.05])
#> has a 100.00% probability of being negative (< 0), 100.00%
#> of being significant (< -0.30), and 100.00% of being large
#> (< -1.81). The estimation successfully converged (Rhat =
#> 0.999) and the indices are reliable (ESS = 1744)
#> 
#> Following the Sequential Effect eXistence and sIgnificance
#> Testing (SEXIT) framework, we report the median of the
#> posterior distribution and its 95% CI (Highest Density
#> Interval), along the probability of direction (pd), the
#> probability of significance and the probability of being
#> large. The thresholds beyond which the effect is considered
#> as significant (i.e., non-negligible) and large are |0.30|
#> and |1.81| (corresponding respectively to 0.05 and 0.30 of
#> the outcome's SD). Convergence and stability of the
#> Bayesian sampling has been assessed using R-hat, which
#> should be below 1.01 (Vehtari et al., 2019), and Effective
#> Sample Size (ESS), which should be greater than 1000
#> (Burkner, 2017).
```

You can also seamlessly integrate `{report}` with *tidyverse* workflows:


```r
library(dplyr)

iris %>%
  select(-starts_with("Sepal")) %>%
  group_by(Species) %>%
  report() %>%
  summary()
#> The data contains 150 observations, grouped by Species, of
#> the following 3 variables:
#> 
#> - setosa (n = 50):
#>   - Petal.Length: Mean = 1.46, SD = 0.17, range: [1, 1.90]
#>   - Petal.Width: Mean = 0.25, SD = 0.11, range: [0.10, 0.60]
#> 
#> - versicolor (n = 50):
#>   - Petal.Length: Mean = 4.26, SD = 0.47, range: [3, 5.10]
#>   - Petal.Width: Mean = 1.33, SD = 0.20, range: [1, 1.80]
#> 
#> - virginica (n = 50):
#>   - Petal.Length: Mean = 5.55, SD = 0.55, range: [4.50, 6.90]
#>   - Petal.Width: Mean = 2.03, SD = 0.27, range: [1.40, 2.50]
```

# Conclusion

The `{report}` package is a valuable tool for researchers who use R to analyze data and create reports for publication. It can help standardize and improve results reporting while saving researchers time and improving the quality of their work. 

# Licensing and Availability

`{report}` is licensed under the GNU General Public License (v3.0), with all source code openly developed and stored on GitHub (<https://github.com/easystats/report>), along with a corresponding issue tracker for bug reporting and feature enhancements. In the spirit of honest and open science, we encourage requests, tips for fixes, feature updates, as well as general questions and concerns via direct interaction with contributors and developers.

# Acknowledgments

`{report}` is part of the collaborative [*easystats*](https://easystats.github.io/easystats/) ecosystem. Thus, we thank the [members of easystats](https://github.com/orgs/easystats/people) as well as the users.

# References
