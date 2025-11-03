# Cite the easystats ecosystem

A convenient function for those who wish to cite the easystats packages.

## Usage

``` r
cite_easystats(
  packages = "easystats",
  format = c("text", "markdown", "biblatex"),
  intext_prefix = TRUE,
  intext_suffix = "."
)

# S3 method for class 'cite_easystats'
summary(object, what = "all", ...)

# S3 method for class 'cite_easystats'
print(x, what = "all", ...)
```

## Arguments

- packages:

  A character vector of packages to cite. Can be `"all"` for all
  *easystats* packages or a vector with specific package names.

- format:

  The format to generate citations. Can be `"text"` for plain text,
  `"markdown"` for markdown citations and CSL bibliography (recommended
  for writing in RMarkdown), or `"biblatex"` for BibLaTeX citations and
  bibliography.

- intext_prefix:

  A character vector of length 1 containing text to include before
  in-text citations. If `TRUE`, defaults to
  `"Analyses were conducted using the easystats collection of packages "`.
  If `FALSE` or `NA`, no prefix is included.

- intext_suffix:

  A character vector of length 1 containing text to include after
  in-text citations. Defaults to `"."`. If `FALSE` or `NA`, no suffix is
  included.

- what:

  What elements of the citations to print, can be `"all"`, `"intext"`,
  or `"refs"`.

- ...:

  Not used. Included for compatibility with the generic function.

- x, object:

  A `"cite_easystats"` object to print.

## Value

A list of class `"cite_easystats"` with elements:

- `intext`: In-text citations in the requested `format`

- `refs`: References or bibliography in the requested `format`

## Examples

``` r
# \donttest{
# Cite just the 'easystats' umbrella package:
cite_easystats()
#> Thanks for crediting us! 😀 You can cite the easystats ecosystem as follows:
#> 
#> Citations
#> ----------
#> 
#> Analyses were conducted using the _easystats_ collection of packages
#> (Lüdecke et al., 2019/2023).
#> 
#> 
#> References
#> ----------
#> 
#> - Lüdecke, D., Makowski, D., Ben-Shachar, M. S., Patil, I., Wiernik, B. M.,
#>     Bacher, Etienne, & Thériault, R. (2023). easystats: Streamline model
#>     interpretation, visualization, and reporting [R package].
#>     https://easystats.github.io/easystats/ (Original work published 2019)
#> 
summary(cite_easystats(), what = "all")
#> 
#> Citations
#> ----------
#> 
#> Analyses were conducted using the _easystats_ collection of packages
#> (Lüdecke et al., 2019/2023).
#> 
#> 
#> References
#> ----------
#> 
#> - Lüdecke, D., Makowski, D., Ben-Shachar, M. S., Patil, I., Wiernik, B. M.,
#>     Bacher, Etienne, & Thériault, R. (2023). easystats: Streamline model
#>     interpretation, visualization, and reporting [R package].
#>     https://easystats.github.io/easystats/ (Original work published 2019)
#> 

# Cite every easystats package:
cite_easystats(packages = "all")
#> Thanks for crediting us! 😀 You can cite the easystats ecosystem as follows:
#> 
#> Citations
#> ----------
#> 
#> Analyses were conducted using the _easystats_ collection of packages
#> (Lüdecke et al., 2019, 2019/2022a, Makowski et al., 2021/2022a, Makowski et
#> al., 2019, 2019/2022b, Lüdecke et al., 2021, 2019/2022b, Lüdecke et al.,
#> 2020, 2019/2022c, Ben-Shachar et al., 2020, 2019/2022, Makowski et al.,
#> 2020/2022c, Makowski et al., 2021/2023d).
#> 
#> 
#> References
#> ----------
#> 
#> - Ben-Shachar, M. S., Lüdecke, D., & Makowski, D. (2020). effectsize:
#>     Estimation of effect size indices and standardized parameters. Journal
#>     of Open Source Software, 5(56), 2815.
#>     https://doi.org/10.21105/joss.02815
#> - Ben-Shachar, M. S., Makowski, D., Lüdecke, D., Patil, I., & Wiernik, B.
#>     M. (2022). effectsize: Indices of effect size and standardized
#>     parameters (1.0.1) [R package].
#>     https://CRAN.R-project.org/package=effectsize (Original work published
#>     2019)
#> - Lüdecke, D., Ben-Shachar, M., Patil, I., & Makowski, D. (2020).
#>     Extracting, computing and exploring the parameters of statistical
#>     models using R. Journal of Open Source Software, 5(53), 2445.
#>     https://doi.org/10.21105/joss.02445
#> - Lüdecke, D., Ben-Shachar, M., Patil, I., Waggoner, P., & Makowski, D.
#>     (2021). performance: An R package for assessment, comparison and
#>     testing of statistical models. Journal of Open Source Software, 6(60),
#>     3139. https://doi.org/10.21105/joss.03139
#> - Lüdecke, D., Makowski, D., Ben-Shachar, M. S., Patil, I., Højsgaard, S.,
#>     & Wiernik, B. M. (2022). parameters: Processing of model parameters
#>     (0.28.2) [R package]. https://CRAN.R-project.org/package=parameters
#>     (Original work published 2019)
#> - Lüdecke, D., Makowski, D., Ben-Shachar, M. S., Patil, I., Waggoner, P., &
#>     Wiernik, B. M. (2021). performance: Assessment of regression models
#>     performance (0.15.2) [R package].
#>     https://CRAN.R-project.org/package=performance (Original work published
#>     2019)
#> - Lüdecke, D., Makowski, D., Patil, I., Waggoner, P., Ben-Shachar, M. S.,
#>     Wiernik, B. M., & Arel-Bundock, V. (2022). insight: Easy access to
#>     model information for various model objects (1.4.2) [R package].
#>     https://CRAN.R-project.org/package=insight (Original work published
#>     2019)
#> - Lüdecke, D., Waggoner, P., & Makowski, D. (2019). insight: A unified
#>     interface to access information from model objects in R. Journal of
#>     Open Source Software, 4(38), 1412. https://doi.org/10.21105/joss.01412
#> - Makowski, D., Ben-Shachar, M., & Lüdecke, D. (2019). bayestestR:
#>     Describing effects and their uncertainty, existence and significance
#>     within the Bayesian framework. Journal of Open Source Software, 4(40),
#>     1541. https://doi.org/10.21105/joss.01541
#> - Makowski, D., Lüdecke, D., Ben-Shachar, M. S., & Patil, I. (2022).
#>     modelbased: Estimation of model-based predictions, contrasts and means
#>     (0.13.0) [R package]. https://CRAN.R-project.org/package=modelbased
#>     (Original work published 2020)
#> - Makowski, D., Lüdecke, D., Ben-Shachar, M. S., Patil, I., Wilson, M. D.,
#>     & Wiernik, B. M. (2021). bayestestR: Understand and describe Bayesian
#>     models and posterior distributions (0.17.0) [R package].
#>     https://CRAN.R-project.org/package=bayestestR (Original work published
#>     2019)
#> - Makowski, D., Lüdecke, D., Patil, I., Ben-Shachar, M. S., & Wiernik, B.
#>     M. (2022). datawizard: Easy data wrangling (1.3.0) [R package].
#>     https://CRAN.R-project.org/package=datawizard (Original work published
#>     2021)
#> - Makowski, D., Lüdecke, D., Patil, I., Thériault, R., Ben-Shachar, M. S.,
#>     & Wiernik, B. M. (2023). report: Automated reporting of results and
#>     statistical models (0.6.2) [R package].
#>     https://easystats.github.io/easystats/ (Original work published 2021)
#> 
summary(cite_easystats(packages = "all"), what = "all")
#> 
#> Citations
#> ----------
#> 
#> Analyses were conducted using the _easystats_ collection of packages
#> (Lüdecke et al., 2019, 2019/2022a, Makowski et al., 2021/2022a, Makowski et
#> al., 2019, 2019/2022b, Lüdecke et al., 2021, 2019/2022b, Lüdecke et al.,
#> 2020, 2019/2022c, Ben-Shachar et al., 2020, 2019/2022, Makowski et al.,
#> 2020/2022c, Makowski et al., 2021/2023d).
#> 
#> 
#> References
#> ----------
#> 
#> - Ben-Shachar, M. S., Lüdecke, D., & Makowski, D. (2020). effectsize:
#>     Estimation of effect size indices and standardized parameters. Journal
#>     of Open Source Software, 5(56), 2815.
#>     https://doi.org/10.21105/joss.02815
#> - Ben-Shachar, M. S., Makowski, D., Lüdecke, D., Patil, I., & Wiernik, B.
#>     M. (2022). effectsize: Indices of effect size and standardized
#>     parameters (1.0.1) [R package].
#>     https://CRAN.R-project.org/package=effectsize (Original work published
#>     2019)
#> - Lüdecke, D., Ben-Shachar, M., Patil, I., & Makowski, D. (2020).
#>     Extracting, computing and exploring the parameters of statistical
#>     models using R. Journal of Open Source Software, 5(53), 2445.
#>     https://doi.org/10.21105/joss.02445
#> - Lüdecke, D., Ben-Shachar, M., Patil, I., Waggoner, P., & Makowski, D.
#>     (2021). performance: An R package for assessment, comparison and
#>     testing of statistical models. Journal of Open Source Software, 6(60),
#>     3139. https://doi.org/10.21105/joss.03139
#> - Lüdecke, D., Makowski, D., Ben-Shachar, M. S., Patil, I., Højsgaard, S.,
#>     & Wiernik, B. M. (2022). parameters: Processing of model parameters
#>     (0.28.2) [R package]. https://CRAN.R-project.org/package=parameters
#>     (Original work published 2019)
#> - Lüdecke, D., Makowski, D., Ben-Shachar, M. S., Patil, I., Waggoner, P., &
#>     Wiernik, B. M. (2021). performance: Assessment of regression models
#>     performance (0.15.2) [R package].
#>     https://CRAN.R-project.org/package=performance (Original work published
#>     2019)
#> - Lüdecke, D., Makowski, D., Patil, I., Waggoner, P., Ben-Shachar, M. S.,
#>     Wiernik, B. M., & Arel-Bundock, V. (2022). insight: Easy access to
#>     model information for various model objects (1.4.2) [R package].
#>     https://CRAN.R-project.org/package=insight (Original work published
#>     2019)
#> - Lüdecke, D., Waggoner, P., & Makowski, D. (2019). insight: A unified
#>     interface to access information from model objects in R. Journal of
#>     Open Source Software, 4(38), 1412. https://doi.org/10.21105/joss.01412
#> - Makowski, D., Ben-Shachar, M., & Lüdecke, D. (2019). bayestestR:
#>     Describing effects and their uncertainty, existence and significance
#>     within the Bayesian framework. Journal of Open Source Software, 4(40),
#>     1541. https://doi.org/10.21105/joss.01541
#> - Makowski, D., Lüdecke, D., Ben-Shachar, M. S., & Patil, I. (2022).
#>     modelbased: Estimation of model-based predictions, contrasts and means
#>     (0.13.0) [R package]. https://CRAN.R-project.org/package=modelbased
#>     (Original work published 2020)
#> - Makowski, D., Lüdecke, D., Ben-Shachar, M. S., Patil, I., Wilson, M. D.,
#>     & Wiernik, B. M. (2021). bayestestR: Understand and describe Bayesian
#>     models and posterior distributions (0.17.0) [R package].
#>     https://CRAN.R-project.org/package=bayestestR (Original work published
#>     2019)
#> - Makowski, D., Lüdecke, D., Patil, I., Ben-Shachar, M. S., & Wiernik, B.
#>     M. (2022). datawizard: Easy data wrangling (1.3.0) [R package].
#>     https://CRAN.R-project.org/package=datawizard (Original work published
#>     2021)
#> - Makowski, D., Lüdecke, D., Patil, I., Thériault, R., Ben-Shachar, M. S.,
#>     & Wiernik, B. M. (2023). report: Automated reporting of results and
#>     statistical models (0.6.2) [R package].
#>     https://easystats.github.io/easystats/ (Original work published 2021)
#> 

# Cite specific packages:
cite_easystats(packages = c("modelbased", "see"))
#> Requested package(s) not installed:
#>   see
#>   Citations to these packages omitted.
#> Thanks for crediting us! 😀 You can cite the easystats ecosystem as follows:
#> 
#> Citations
#> ----------
#> 
#> Analyses were conducted using the _easystats_ collection of packages
#> (Makowski et al., 2020/2022).
#> 
#> 
#> References
#> ----------
#> 
#> - Makowski, D., Lüdecke, D., Ben-Shachar, M. S., & Patil, I. (2022).
#>     modelbased: Estimation of model-based predictions, contrasts and means
#>     (0.13.0) [R package]. https://CRAN.R-project.org/package=modelbased
#>     (Original work published 2020)
#> 
summary(cite_easystats(packages = c("modelbased", "see")), what = "all")
#> Requested package(s) not installed:
#>   see
#>   Citations to these packages omitted.
#> 
#> Citations
#> ----------
#> 
#> Analyses were conducted using the _easystats_ collection of packages
#> (Makowski et al., 2020/2022).
#> 
#> 
#> References
#> ----------
#> 
#> - Makowski, D., Lüdecke, D., Ben-Shachar, M. S., & Patil, I. (2022).
#>     modelbased: Estimation of model-based predictions, contrasts and means
#>     (0.13.0) [R package]. https://CRAN.R-project.org/package=modelbased
#>     (Original work published 2020)
#> 

# To cite easystats packages in an RMarkdown document, use:

## In-text citations:
print(cite_easystats(format = "markdown"), what = "intext")
#> Analyses were conducted using the _easystats_ collection of packages
#> [@easystatsPackage].

## Bibliography (print with the  `output = 'asis'` option on the code chunk)
print(cite_easystats(format = "markdown"), what = "refs")
#> --- references:
#> 
#> - id: easystatsPackage accessed: - year: 2023 month: 2 day: 4 author: -
#>     family: Lüdecke given: Daniel - family: Makowski given: Dominique -
#>     family: Ben-Shachar given: Mattan S.  - family: Patil given: Indrajeet
#>     - family: Wiernik given: Brenton M.  - family: Bacher given: Etienne -
#>     family: Thériault given: Rémi citation-key: easystatsPackage genre: R
#>     package issued: - year: 2023 month: 2 day: 4 original-date: - year:
#>     2019 month: 1 day: 28 title: >- <span class="nocase">easystats</span>:
#>     streamline model interpretation, visualization, and reporting
#>     title-short: <span class="nocase">easystats</span> type: software URL:
#>     https://easystats.github.io/easystats/ version: ...
# }
```
