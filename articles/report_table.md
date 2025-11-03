# Publication-ready Tables

First, load the [report](https://easystats.github.io/report/) package:

``` r

library(report)
```

## Getting started with correlations

Let’s start by demonstrating some features with simple tests. The
function
[`report_table()`](https://easystats.github.io/report/reference/report_table.md)
can be used to create a table for many R objects.

``` r

results <- cor.test(mtcars$mpg, mtcars$wt)

report_table(results)
# Pearson's product-moment correlation
# 
# Parameter1 | Parameter2 |     r |         95% CI | t(30) |      p
# -----------------------------------------------------------------
# mtcars$mpg |  mtcars$wt | -0.87 | [-0.93, -0.74] | -9.56 | < .001
# 
# Alternative hypothesis: two.sided
```

We can also obtain a shorter version by running
[`summary()`](https://rdrr.io/r/base/summary.html) on the output (that
we are going to store in a variable called `t` - like table)

``` r

t <- summary(report_table(results))
t
# Pearson's product-moment correlation
# 
# Parameter1 | Parameter2 |     r |         95% CI |      p
# ---------------------------------------------------------
# mtcars$mpg |  mtcars$wt | -0.87 | [-0.93, -0.74] | < .001
# 
# Alternative hypothesis: two.sided
```

In the example above, running just `t` ran `print(t)` under the hood,
which prints the table inside the console. However, one can nicely
display that table in markdown documents using
[`display()`](https://easystats.github.io/insight/reference/display.html).

``` r

display(t)
```

| Parameter1            | Parameter2 |       r        | 95% CI  |  p  |
|:----------------------|:----------:|:--------------:|:-------:|:---:|
| mtcarsmpg \| mtcarswt |   -0.87    | (-0.93, -0.74) | \< .001 |     |

Alternative hypothesis: true correlation is not equal to 0

We can further customize this table, by adding significance stars,

``` r

display(t,
  stars = TRUE,
  title = "Table 1",
  footer = "Correlation in the mtcars (n = 32) dataset.\n*** p < .001"
)
```

| Parameter1            | Parameter2 |       r        |    95% CI     |  p  |
|:----------------------|:----------:|:--------------:|:-------------:|:---:|
| mtcarsmpg \| mtcarswt |   -0.87    | (-0.93, -0.74) | \< .001\*\*\* |     |

Table 1 {.table}

Correlation in the mtcars (n = 32) dataset. \*\*\* p \< .001

Alternative hypothesis: true correlation is not equal to 0

## *t*-tests, …

It works similarly for *t*-tests.

``` r

results <- t.test(mtcars$mpg ~ mtcars$am)

t <- summary(report_table(results))
t
# Difference |          95% CI | t(18.33) |     p | Cohen's d |  Cohen's d  CI
# ----------------------------------------------------------------------------
# -7.24      | [-11.28, -3.21] |    -3.77 | 0.001 |     -1.41 | [-2.26, -0.53]
# 
# Alternative hypothesis: two.sided
```

Note that, by default,
[`report_table()`](https://easystats.github.io/report/reference/report_table.md)
prettifies the printing: that means that the column names and its
content is, underneath, not necessarily what is printed, which can be a
bit confusing. For instance, while the confidence interval `CI` appears
as one column, it this actually made of three columns! One can access
this *raw* table as a dataframe:

``` r

as.data.frame(t)
#   Difference   CI    CI_low   CI_high         t df_error
# 1  -7.244939 0.95 -11.28019 -3.209684 -3.767123 18.33225
#             p Alternative  Cohens_d Cohens_d_CI_low
# 1 0.001373638   two.sided -1.411046       -2.260021
#   Cohens_d_CI_high
# 1       -0.5342256
```

In fact, the function used to *prettify* the output is called
[`insight::format_table()`](https://easystats.github.io/insight/reference/format_table.html)
and is accessible to you too, so that you can prettify the output while
keeping it as a data frame.

``` r

insight::format_table(as.data.frame(t), stars = TRUE)
#   Difference          95% CI t(18.33)       p Alternative
# 1      -7.24 [-11.28, -3.21]    -3.77 0.001**   two.sided
#   Cohen's d  Cohen's d  CI
# 1     -1.41 [-2.26, -0.53]
```

Also, you can join the results of multiple tables:

``` r

results1 <- t.test(mtcars$mpg ~ mtcars$am)
results2 <- t.test(mtcars$wt ~ mtcars$am)
results3 <- t.test(mtcars$qsec ~ mtcars$am)

results <- c(
  report_table(results1),
  report_table(results2),
  report_table(results3)
)
display(results)
```

| Parameter | Group | Mean_Group1 | Mean_Group2 | Difference | 95% CI | t | df | p | Cohen’s d | Cohen’s d CI |
|:---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| mtcarsmpg \| mtcarsam | 17.15 | 24.39 | -7.24 | (-11.28, -3.21) | -3.77 | 18.33 | 0.001 | -1.41 | (-2.26, -0.53) |  |
| mtcarswt \| mtcarsam | 3.77 | 2.41 | 1.36 | (0.85, 1.86) | 5.49 | 29.23 | \< .001 | 1.93 | (1.08, 2.77) |  |
| mtcarsqsec \| mtcarsam | 18.18 | 17.36 | 0.82 | (-0.49, 2.14) | 1.29 | 25.53 | 0.209 | 0.46 | (-0.26, 1.18) |  |

## ANOVAs

## Linear Models

``` r

model <- lm(Petal.Length ~ Species * Petal.Width, data = iris)

report_table(model)
# Parameter                          | Coefficient
# ------------------------------------------------
# (Intercept)                        |        1.33
# Species [versicolor]               |        0.45
# Species [virginica]                |        2.91
# Petal Width                        |        0.55
# Species [versicolor] × Petal Width |        1.32
# Species [virginica] × Petal Width  |        0.10
#                                    |            
# AIC                                |            
# AICc                               |            
# BIC                                |            
# R2                                 |            
# R2 (adj.)                          |            
# Sigma                              |            
# 
# Parameter                          |        95% CI | t(144)
# -----------------------------------------------------------
# (Intercept)                        | [ 1.07, 1.59] |  10.14
# Species [versicolor]               | [-0.28, 1.19] |   1.21
# Species [virginica]                | [ 2.11, 3.72] |   7.17
# Petal Width                        | [-0.42, 1.52] |   1.12
# Species [versicolor] × Petal Width | [ 0.23, 2.42] |   2.38
# Species [virginica] × Petal Width  | [-0.94, 1.14] |   0.19
#                                    |               |       
# AIC                                |               |       
# AICc                               |               |       
# BIC                                |               |       
# R2                                 |               |       
# R2 (adj.)                          |               |       
# Sigma                              |               |       
# 
# Parameter                          |      p | Std. Coef.
# --------------------------------------------------------
# (Intercept)                        | < .001 |      -1.01
# Species [versicolor]               | 0.227  |       1.16
# Species [virginica]                | < .001 |       1.72
# Petal Width                        | 0.267  |       0.24
# Species [versicolor] × Petal Width | 0.019  |       0.57
# Species [virginica] × Petal Width  | 0.848  |       0.04
#                                    |        |           
# AIC                                |        |           
# AICc                               |        |           
# BIC                                |        |           
# R2                                 |        |           
# R2 (adj.)                          |        |           
# Sigma                              |        |           
# 
# Parameter                          | Std. Coef. 95% CI |    Fit
# ---------------------------------------------------------------
# (Intercept)                        |    [-1.53, -0.48] |       
# Species [versicolor]               |    [ 0.63,  1.69] |       
# Species [virginica]                |    [ 1.16,  2.28] |       
# Petal Width                        |    [-0.18,  0.65] |       
# Species [versicolor] × Petal Width |    [ 0.10,  1.05] |       
# Species [virginica] × Petal Width  |    [-0.40,  0.49] |       
#                                    |                   |       
# AIC                                |                   | 128.29
# AICc                               |                   | 129.08
# BIC                                |                   | 149.36
# R2                                 |                   |   0.96
# R2 (adj.)                          |                   |   0.96
# Sigma                              |                   |   0.36
```
