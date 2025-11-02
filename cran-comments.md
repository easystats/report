## R CMD check results report 0.6.2.1

0 errors | 0 warnings | 0 note

This submission addresses CRAN feedback about excessive test execution time:
* Added `skip_on_cran()` to 9 computationally intensive test files involving Bayesian models (brms, rstanarm, BayesFactor), mixed-effects models (lme4, nlme, glmmTMB, GLMMadaptive), and structural equation models (lavaan)
* These tests are skipped on CRAN but continue to run in CI and local development environments
* 71% of test files (34/48) still run on CRAN, ensuring comprehensive coverage of core functionality
* Expected to reduce test execution time from >530 seconds to well under CRAN's 10-minute limit

## R CMD check results report 0.6.2

0 errors | 0 warnings | 0 note

## R CMD check results report 0.6.1

0 errors | 0 warnings | 0 note

## R CMD check results report 0.6.0

0 errors | 0 warnings | 0 note

## R CMD check results report 0.5.9

0 errors | 0 warnings | 0 note

## R CMD check results report 0.5.8 

0 errors | 0 warnings | 0 note

## R CMD check results report 0.5.7

0 errors | 0 warnings | 0 note

## R CMD check results report 0.5.6

0 errors | 0 warnings | 1 note

* Change of maintainer from Dominique Makowski to Rémi Thériault.
