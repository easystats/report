# Report R environment (packages, system, etc.)

Report R environment (packages, system, etc.)

## Usage

``` r
# S3 method for class 'sessionInfo'
report(x, ...)

report_packages(session = NULL, include_R = TRUE, ...)

cite_packages(session = NULL, include_R = TRUE, ...)

report_system(session = NULL)
```

## Arguments

- x:

  The R object that you want to report (see list of of supported objects
  above).

- ...:

  Arguments passed to or from other methods.

- session:

  A [sessionInfo](https://rdrr.io/r/utils/sessionInfo.html) object.

- include_R:

  Include R in the citations.

## Value

For `report_packages`, a data frame of class with information on package
name, version and citation.

An object of class
[`report()`](https://easystats.github.io/report/reference/report.md).

## Examples

``` r

library(report)

session <- sessionInfo()

r <- report(session)
r
#> Analyses were conducted using the R Statistical language (version 4.5.2; R Core
#> Team, 2025) on Ubuntu 24.04.3 LTS, using the packages Matrix (version 1.7.4;
#> Bates D et al., 2025), lme4 (version 1.1.37; Bates D et al., 2015), brms
#> (version 2.23.0; Bürkner P, 2017), Rcpp (version 1.1.0; Eddelbuettel D et al.,
#> 2025), performance (version 0.15.2; Lüdecke D et al., 2021), bayestestR
#> (version 0.17.0; Makowski D et al., 2019), modelbased (version 0.13.0; Makowski
#> D et al., 2025), report (version 0.6.2; Makowski D et al., 2023), BayesFactor
#> (version 0.9.12.4.7; Morey R, Rouder J, 2024), coda (version 0.19.4.1; Plummer
#> M et al., 2006), lavaan (version 0.6.20; Rosseel Y et al., 2025) and dplyr
#> (version 1.1.4; Wickham H et al., 2023).
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
#> Bates D, Chambers J (2025). _Rcpp: Seamless R and C++ Integration_. R package
#> version 1.1.0, <https://www.rcpp.org>. Eddelbuettel D, François R (2011).
#> “Rcpp: Seamless R and C++ Integration.” _Journal of Statistical Software_,
#> *40*(8), 1-18. doi:10.18637/jss.v040.i08
#> <https://doi.org/10.18637/jss.v040.i08>. Eddelbuettel D (2013). _Seamless R and
#> C++ Integration with Rcpp_. Springer, New York. doi:10.1007/978-1-4614-6868-4
#> <https://doi.org/10.1007/978-1-4614-6868-4>, ISBN 978-1-4614-6867-7.
#> Eddelbuettel D, Balamuta J (2018). “Extending R with C++: A Brief Introduction
#> to Rcpp.” _The American Statistician_, *72*(1), 28-36.
#> doi:10.1080/00031305.2017.1375990
#> <https://doi.org/10.1080/00031305.2017.1375990>.
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
#>   - Wickham H, François R, Henry L, Müller K, Vaughan D (2023). _dplyr: A Grammar
#> of Data Manipulation_. R package version 1.1.4, <https://dplyr.tidyverse.org>.
summary(r)
#> The analysis was done using the R Statistical language (v4.5.2; R Core Team,
#> 2025) on Ubuntu 24.04.3 LTS, using the packages Matrix (v1.7.4), lme4
#> (v1.1.37), brms (v2.23.0), Rcpp (v1.1.0), performance (v0.15.2), bayestestR
#> (v0.17.0), modelbased (v0.13.0), report (v0.6.2), BayesFactor (v0.9.12.4.7),
#> coda (v0.19.4.1), lavaan (v0.6.20) and dplyr (v1.1.4).
as.data.frame(r)
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
#> lavaan      |     0.6.20 |                                                                                                                                                                                                                                                                                                                                                                            Rosseel Y, Jorgensen T, De Wilde L (2025). _lavaan: Latent Variable Analysis_. doi:10.32614/CRAN.package.lavaan <https://doi.org/10.32614/CRAN.package.lavaan>, R package version 0.6-20, <https://CRAN.R-project.org/package=lavaan>. Rosseel Y (2012). “lavaan: An R Package for Structural Equation Modeling.” _Journal of Statistical Software_, *48*(2), 1-36. doi:10.18637/jss.v048.i02 <https://doi.org/10.18637/jss.v048.i02>.
#> lme4        |     1.1.37 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Bates D, Mächler M, Bolker B, Walker S (2015). “Fitting Linear Mixed-Effects Models Using lme4.” _Journal of Statistical Software_, *67*(1), 1-48. doi:10.18637/jss.v067.i01 <https://doi.org/10.18637/jss.v067.i01>.
#> modelbased  |     0.13.0 |                                                                                                                                                                                                                                                                                                                                                                                                                 Makowski D, Ben-Shachar M, Wiernik B, Patil I, Thériault R, Lüdecke D (2025). “modelbased: An R package to make the most out of your statistical models through marginal means, marginal effects, and model predictions.” _Journal of Open Source Software_, *10*(109), 7969. doi:10.21105/joss.07969 <https://doi.org/10.21105/joss.07969>, <https://joss.theoj.org/papers/10.21105/joss.07969>.
#> performance |     0.15.2 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Lüdecke D, Ben-Shachar M, Patil I, Waggoner P, Makowski D (2021). “performance: An R Package for Assessment, Comparison and Testing of Statistical Models.” _Journal of Open Source Software_, *6*(60), 3139. doi:10.21105/joss.03139 <https://doi.org/10.21105/joss.03139>.
#> report      |      0.6.2 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Makowski D, Lüdecke D, Patil I, Thériault R, Ben-Shachar M, Wiernik B (2023). “Automated Results Reporting as a Practical Tool to Improve Reproducibility and Methodological Best Practices Adoption.” _CRAN_. doi:10.32614/CRAN.package.report <https://doi.org/10.32614/CRAN.package.report>, <https://easystats.github.io/report/>.
summary(as.data.frame(r))
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
#> lavaan      |     0.6.20
#> lme4        |     1.1.37
#> modelbased  |     0.13.0
#> performance |     0.15.2
#> report      |      0.6.2

# Convenience functions
report_packages(include_R = FALSE)
#>   - Matrix (version 1.7.4; Bates D et al., 2025)
#>   - lme4 (version 1.1.37; Bates D et al., 2015)
#>   - brms (version 2.23.0; Bürkner P, 2017)
#>   - Rcpp (version 1.1.0; Eddelbuettel D et al., 2025)
#>   - performance (version 0.15.2; Lüdecke D et al., 2021)
#>   - bayestestR (version 0.17.0; Makowski D et al., 2019)
#>   - modelbased (version 0.13.0; Makowski D et al., 2025)
#>   - report (version 0.6.2; Makowski D et al., 2023)
#>   - BayesFactor (version 0.9.12.4.7; Morey R, Rouder J, 2024)
#>   - coda (version 0.19.4.1; Plummer M et al., 2006)
#>   - lavaan (version 0.6.20; Rosseel Y et al., 2025)
#>   - dplyr (version 1.1.4; Wickham H et al., 2023)
cite_packages(prefix = "> ")
#> > Bates D, Maechler M, Jagan M (2025). _Matrix: Sparse and Dense Matrix Classes and Methods_. doi:10.32614/CRAN.package.Matrix <https://doi.org/10.32614/CRAN.package.Matrix>, R package version 1.7-4, <https://CRAN.R-project.org/package=Matrix>.
#> > Bates D, Mächler M, Bolker B, Walker S (2015). “Fitting Linear Mixed-Effects Models Using lme4.” _Journal of Statistical Software_, *67*(1), 1-48. doi:10.18637/jss.v067.i01 <https://doi.org/10.18637/jss.v067.i01>.
#> > Bürkner P (2017). “brms: An R Package for Bayesian Multilevel Models Using Stan.” _Journal of Statistical Software_, *80*(1), 1-28. doi:10.18637/jss.v080.i01 <https://doi.org/10.18637/jss.v080.i01>. Bürkner P (2018). “Advanced Bayesian Multilevel Modeling with the R Package brms.” _The R Journal_, *10*(1), 395-411. doi:10.32614/RJ-2018-017 <https://doi.org/10.32614/RJ-2018-017>. Bürkner P (2021). “Bayesian Item Response Modeling in R with brms and Stan.” _Journal of Statistical Software_, *100*(5), 1-54. doi:10.18637/jss.v100.i05 <https://doi.org/10.18637/jss.v100.i05>.
#> > Eddelbuettel D, Francois R, Allaire J, Ushey K, Kou Q, Russell N, Ucar I, Bates D, Chambers J (2025). _Rcpp: Seamless R and C++ Integration_. R package version 1.1.0, <https://www.rcpp.org>. Eddelbuettel D, François R (2011). “Rcpp: Seamless R and C++ Integration.” _Journal of Statistical Software_, *40*(8), 1-18. doi:10.18637/jss.v040.i08 <https://doi.org/10.18637/jss.v040.i08>. Eddelbuettel D (2013). _Seamless R and C++ Integration with Rcpp_. Springer, New York. doi:10.1007/978-1-4614-6868-4 <https://doi.org/10.1007/978-1-4614-6868-4>, ISBN 978-1-4614-6867-7. Eddelbuettel D, Balamuta J (2018). “Extending R with C++: A Brief Introduction to Rcpp.” _The American Statistician_, *72*(1), 28-36. doi:10.1080/00031305.2017.1375990 <https://doi.org/10.1080/00031305.2017.1375990>.
#> > Lüdecke D, Ben-Shachar M, Patil I, Waggoner P, Makowski D (2021). “performance: An R Package for Assessment, Comparison and Testing of Statistical Models.” _Journal of Open Source Software_, *6*(60), 3139. doi:10.21105/joss.03139 <https://doi.org/10.21105/joss.03139>.
#> > Makowski D, Ben-Shachar M, Lüdecke D (2019). “bayestestR: Describing Effects and their Uncertainty, Existence and Significance within the Bayesian Framework.” _Journal of Open Source Software_, *4*(40), 1541. doi:10.21105/joss.01541 <https://doi.org/10.21105/joss.01541>, <https://joss.theoj.org/papers/10.21105/joss.01541>.
#> > Makowski D, Ben-Shachar M, Wiernik B, Patil I, Thériault R, Lüdecke D (2025). “modelbased: An R package to make the most out of your statistical models through marginal means, marginal effects, and model predictions.” _Journal of Open Source Software_, *10*(109), 7969. doi:10.21105/joss.07969 <https://doi.org/10.21105/joss.07969>, <https://joss.theoj.org/papers/10.21105/joss.07969>.
#> > Makowski D, Lüdecke D, Patil I, Thériault R, Ben-Shachar M, Wiernik B (2023). “Automated Results Reporting as a Practical Tool to Improve Reproducibility and Methodological Best Practices Adoption.” _CRAN_. doi:10.32614/CRAN.package.report <https://doi.org/10.32614/CRAN.package.report>, <https://easystats.github.io/report/>.
#> > Morey R, Rouder J (2024). _BayesFactor: Computation of Bayes Factors for Common Designs_. R package version 0.9.12-4.7, <https://richarddmorey.github.io/BayesFactor/>.
#> > Plummer M, Best N, Cowles K, Vines K (2006). “CODA: Convergence Diagnosis and Output Analysis for MCMC.” _R News_, *6*(1), 7-11. <https://journal.r-project.org/archive/>.
#> > R Core Team (2025). _R: A Language and Environment for Statistical Computing_. R Foundation for Statistical Computing, Vienna, Austria. <https://www.R-project.org/>.
#> > Rosseel Y, Jorgensen T, De Wilde L (2025). _lavaan: Latent Variable Analysis_. doi:10.32614/CRAN.package.lavaan <https://doi.org/10.32614/CRAN.package.lavaan>, R package version 0.6-20, <https://CRAN.R-project.org/package=lavaan>. Rosseel Y (2012). “lavaan: An R Package for Structural Equation Modeling.” _Journal of Statistical Software_, *48*(2), 1-36. doi:10.18637/jss.v048.i02 <https://doi.org/10.18637/jss.v048.i02>.
#> > Wickham H, François R, Henry L, Müller K, Vaughan D (2023). _dplyr: A Grammar of Data Manipulation_. R package version 1.1.4, <https://dplyr.tidyverse.org>.
report_system()
#> Analyses were conducted using the R Statistical language (version 4.5.2; R Core
#> Team, 2025) on Ubuntu 24.04.3 LTS
```
