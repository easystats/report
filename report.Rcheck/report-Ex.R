pkgname <- "report"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('report')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("cite_easystats")
### * cite_easystats

flush(stderr()); flush(stdout())

### Name: cite_easystats
### Title: Cite the easystats ecosystem
### Aliases: cite_easystats summary.cite_easystats print.cite_easystats

### ** Examples





cleanEx()
nameEx("format_citation")
### * format_citation

flush(stderr()); flush(stdout())

### Name: format_citation
### Title: Citation formatting
### Aliases: format_citation cite_citation clean_citation

### ** Examples

library(report)

citation <- "Makowski, D., Ben-Shachar, M. S., Patil, I., & Ludecke, D. (2020).
Methods and Algorithms for Correlation Analysis in R. Journal of Open Source
Software, 5(51), 2306."

format_citation(citation, authorsdate = TRUE)
format_citation(citation, authorsdate = TRUE, short = TRUE)
format_citation(citation, authorsdate = TRUE, short = TRUE, intext = TRUE)

cite_citation(citation)
clean_citation(citation())



cleanEx()
nameEx("format_formula")
### * format_formula

flush(stderr()); flush(stdout())

### Name: format_algorithm
### Title: Convenient formatting of text components
### Aliases: format_algorithm format_formula format_model

### ** Examples

model <- lm(Sepal.Length ~ Species, data = iris)
format_algorithm(model)

## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Sepal.Width + (1 | Species), data = iris)
format_algorithm(model)
## Don't show: 
}) # examplesIf
## End(Don't show)
model <- lm(Sepal.Length ~ Species, data = iris)
format_formula(model)

## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Sepal.Width + (1 | Species), data = iris)
format_formula(model)
format_formula(model, "random")
## Don't show: 
}) # examplesIf
## End(Don't show)
model <- lm(Sepal.Length ~ Species, data = iris)
format_model(model)

## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Sepal.Width + (1 | Species), data = iris)
format_model(model)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report.BFBayesFactor")
### * report.BFBayesFactor

flush(stderr()); flush(stdout())

### Name: report.BFBayesFactor
### Title: Reporting 'BFBayesFactor' objects from the 'BayesFactor' package
### Aliases: report.BFBayesFactor report_statistics.BFBayesFactor

### ** Examples

## Don't show: 
if (requireNamespace("BayesFactor", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report")
### * report

flush(stderr()); flush(stdout())

### Name: report
### Title: Automatic reporting of R objects
### Aliases: report

### ** Examples


library(report)

model <- t.test(mtcars$mpg ~ mtcars$am)
r <- report(model)

# Text
r
summary(r)

# Tables
as.data.frame(r)
summary(as.data.frame(r))




cleanEx()
nameEx("report.aov")
### * report.aov

flush(stderr()); flush(stdout())

### Name: report.aov
### Title: Reporting ANOVAs
### Aliases: report.aov report_effectsize.aov report_table.aov
###   report_statistics.aov report_parameters.aov report_model.aov
###   report_info.aov report_text.aov

### ** Examples

data <- iris
data$Cat1 <- rep(c("A", "B"), length.out = nrow(data))

model <- aov(Sepal.Length ~ Species * Cat1, data = data)
r <- report(model)
r
summary(r)
as.data.frame(r)
summary(as.data.frame(r))



cleanEx()
nameEx("report.bayesfactor_models")
### * report.bayesfactor_models

flush(stderr()); flush(stdout())

### Name: report.bayesfactor_models
### Title: Reporting Models' Bayes Factor
### Aliases: report.bayesfactor_models report.bayesfactor_inclusion

### ** Examples

## Don't show: 
if (requireNamespace("bayestestR", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
library(bayestestR)
# Bayes factor - models
mo0 <- lm(Sepal.Length ~ 1, data = iris)
mo1 <- lm(Sepal.Length ~ Species, data = iris)
mo2 <- lm(Sepal.Length ~ Species + Petal.Length, data = iris)
mo3 <- lm(Sepal.Length ~ Species * Petal.Length, data = iris)
BFmodels <- bayesfactor_models(mo1, mo2, mo3, denominator = mo0)

r <- report(BFmodels)
r

# Bayes factor - inclusion
inc_bf <- bayesfactor_inclusion(BFmodels, prior_odds = c(1, 2, 3), match_models = TRUE)

r <- report(inc_bf)
r
as.data.frame(r)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report.brmsfit")
### * report.brmsfit

flush(stderr()); flush(stdout())

### Name: report.brmsfit
### Title: Reporting Bayesian Models from brms
### Aliases: report.brmsfit

### ** Examples

## Don't show: 
if (require("brms", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report.compare.loo")
### * report.compare.loo

flush(stderr()); flush(stdout())

### Name: report.compare.loo
### Title: Reporting Bayesian Model Comparison
### Aliases: report.compare.loo

### ** Examples

## Don't show: 
if (requireNamespace("brms", quietly = TRUE) && requireNamespace("RcppEigen", quietly = TRUE) && requireNamespace("BH", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report.compare_performance")
### * report.compare_performance

flush(stderr()); flush(stdout())

### Name: report.compare_performance
### Title: Reporting models comparison
### Aliases: report.compare_performance report_table.compare_performance
###   report_statistics.compare_performance
###   report_parameters.compare_performance report_text.compare_performance

### ** Examples




cleanEx()
nameEx("report.data.frame")
### * report.data.frame

flush(stderr()); flush(stdout())

### Name: report.character
### Title: Reporting Datasets and Dataframes
### Aliases: report.character report.data.frame report.factor
###   report.numeric

### ** Examples

r <- report(iris,
  centrality = "median", dispersion = FALSE,
  distribution = TRUE, missing_percentage = TRUE
)
r
summary(r)
as.data.frame(r)
summary(as.data.frame(r))

## Don't show: 
if (requireNamespace("dplyr", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
# grouped analysis using `{dplyr}` package
library(dplyr)
r <- iris %>%
  group_by(Species) %>%
  report()
r
summary(r)
as.data.frame(r)
summary(as.data.frame(r))
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report.default")
### * report.default

flush(stderr()); flush(stdout())

### Name: report.default
### Title: Template to add report support for new objects
### Aliases: report.default report_effectsize.default report_table.default
###   report_statistics.default report_parameters.default
###   report_intercept.default report_model.default report_random.default
###   report_priors.default report_performance.default report_info.default
###   report_text.default

### ** Examples

library(report)

# Add a reproducible example instead of the following
model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
r <- report(model)
r
summary(r)
as.data.frame(r)
summary(as.data.frame(r))



cleanEx()
nameEx("report.estimate_contrasts")
### * report.estimate_contrasts

flush(stderr()); flush(stdout())

### Name: report.estimate_contrasts
### Title: Reporting 'estimate_contrasts' objects
### Aliases: report.estimate_contrasts report_table.estimate_contrasts
###   report_text.estimate_contrasts

### ** Examples

## Don't show: 
if (all(insight::check_if_installed(c("modelbased", "marginaleffects", "collapse", "Formula"), quietly = TRUE))) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
library(modelbased)
model <- lm(Sepal.Width ~ Species, data = iris)
contr <- estimate_contrasts(model)
report(contr)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report.htest")
### * report.htest

flush(stderr()); flush(stdout())

### Name: report.htest
### Title: Reporting 'htest' objects (Correlation, t-test...)
### Aliases: report.htest report_effectsize.htest report_table.htest
###   report_statistics.htest report_parameters.htest report_model.htest
###   report_info.htest report_text.htest

### ** Examples

# t-tests
report(t.test(iris$Sepal.Width, iris$Sepal.Length))
report(t.test(iris$Sepal.Width, iris$Sepal.Length, var.equal = TRUE))
report(t.test(mtcars$mpg ~ mtcars$vs))
report(t.test(mtcars$mpg, mtcars$vs, paired = TRUE), verbose = FALSE)
report(t.test(iris$Sepal.Width, mu = 1))

# Correlations
report(cor.test(iris$Sepal.Width, iris$Sepal.Length))



cleanEx()
nameEx("report.lavaan")
### * report.lavaan

flush(stderr()); flush(stdout())

### Name: report.lavaan
### Title: Reports of Structural Equation Models (SEM)
### Aliases: report.lavaan report_performance.lavaan

### ** Examples

## Don't show: 
if (requireNamespace("lavaan", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report.lm")
### * report.lm

flush(stderr()); flush(stdout())

### Name: report.lm
### Title: Reporting (General) Linear Models
### Aliases: report.lm report_effectsize.lm report_table.lm
###   report_statistics.lm report_parameters.lm report_intercept.lm
###   report_model.lm report_performance.lm report_info.lm report_text.lm
###   report_random.merMod

### ** Examples


## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report.sessionInfo")
### * report.sessionInfo

flush(stderr()); flush(stdout())

### Name: report.sessionInfo
### Title: Report R environment (packages, system, etc.)
### Aliases: report.sessionInfo report_packages cite_packages report_system

### ** Examples


library(report)

session <- sessionInfo()

r <- report(session)
r
summary(r)
as.data.frame(r)
summary(as.data.frame(r))

# Convenience functions
report_packages(include_R = FALSE)
cite_packages(prefix = "> ")
report_system()




cleanEx()
nameEx("report.stanreg")
### * report.stanreg

flush(stderr()); flush(stdout())

### Name: report.stanreg
### Title: Reporting Bayesian Models
### Aliases: report.stanreg

### ** Examples

## Don't show: 
if (requireNamespace("rstanarm", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report.test_performance")
### * report.test_performance

flush(stderr()); flush(stdout())

### Name: report.test_performance
### Title: Reporting models comparison
### Aliases: report.test_performance report_table.test_performance
###   report_statistics.test_performance report_parameters.test_performance
###   report_text.test_performance

### ** Examples




cleanEx()
nameEx("report_date")
### * report_date

flush(stderr()); flush(stdout())

### Name: report_date
### Title: Miscellaneous reports
### Aliases: report_date report_story

### ** Examples

library(report)

report_date()
summary(report_date())
report_story()



cleanEx()
nameEx("report_effectsize")
### * report_effectsize

flush(stderr()); flush(stdout())

### Name: report_effectsize
### Title: Report the effect size(s) of a model or a test
### Aliases: report_effectsize

### ** Examples

library(report)

# h-tests
report_effectsize(t.test(iris$Sepal.Width, iris$Sepal.Length))

# ANOVAs
report_effectsize(aov(Sepal.Length ~ Species, data = iris))

# GLMs
report_effectsize(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
report_effectsize(glm(vs ~ disp, data = mtcars, family = "binomial"))

## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)
## Don't show: 
if (requireNamespace("rstanarm", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report_info")
### * report_info

flush(stderr()); flush(stdout())

### Name: report_info
### Title: Report additional information
### Aliases: report_info

### ** Examples

library(report)

# h-tests
report_info(t.test(iris$Sepal.Width, iris$Sepal.Length))

# ANOVAs
report_info(aov(Sepal.Length ~ Species, data = iris))

## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)
## Don't show: 
if (requireNamespace("rstanarm", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report_intercept")
### * report_intercept

flush(stderr()); flush(stdout())

### Name: report_intercept
### Title: Report intercept
### Aliases: report_intercept

### ** Examples


## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)
## Don't show: 
if (requireNamespace("rstanarm", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report_model")
### * report_model

flush(stderr()); flush(stdout())

### Name: report_model
### Title: Report the model type
### Aliases: report_model

### ** Examples


## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)
## Don't show: 
if (requireNamespace("rstanarm", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report_parameters")
### * report_parameters

flush(stderr()); flush(stdout())

### Name: report_parameters
### Title: Report the parameters of a model
### Aliases: report_parameters

### ** Examples


## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)
## Don't show: 
if (requireNamespace("rstanarm", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report_participants")
### * report_participants

flush(stderr()); flush(stdout())

### Name: report_participants
### Title: Reporting the participant data
### Aliases: report_participants

### ** Examples

library(report)
data <- data.frame(
  "Age" = c(22, 23, 54, 21, 8, 42),
  "Sex" = c("Intersex", "F", "M", "M", "NA", NA),
  "Gender" = c("N", "W", "W", "M", "NA", NA)
)
report_participants(data, age = "Age", sex = "Sex")

# Years of education (relative to high school graduation)
data$Education <- c(0, 8, -3, -5, 3, 5)
report_participants(data,
  age = "Age", sex = "Sex", gender = "Gender",
  education = "Education"
)

# Education as factor
data$Education2 <- c(
  "Bachelor", "PhD", "Highschool",
  "Highschool", "Bachelor", "Bachelor"
)
report_participants(data, age = "Age", sex = "Sex", gender = "Gender", education = "Education2")

# Country
data <- data.frame(
  "Age" = c(22, 23, 54, 21, 8, 42, 18, 32, 24, 27, 45),
  "Sex" = c("Intersex", "F", "F", "M", "M", "M", "F", "F", "F", "F", "F"),
  "Gender" = c("N", "W", "W", "M", "M", "M", "W", "W", "W", "W", "W"),
  "Country" = c(
    "USA", NA, "Canada", "Canada", "India", "Germany",
    "USA", "USA", "USA", "USA", "Canada"
  )
)
report_participants(data)

# Country, control presentation treshold
report_participants(data, threshold = 5)

# Race/ethnicity
data <- data.frame(
  "Age" = c(22, 23, 54, 21, 8, 42, 18, 32, 24, 27, 45),
  "Sex" = c("Intersex", "F", "F", "M", "M", "M", "F", "F", "F", "F", "F"),
  "Gender" = c("N", "W", "W", "M", "M", "M", "W", "W", "W", "W", "W"),
  "Race" = c(
    "Black", NA, "White", "Asian", "Black", "Arab", "Black",
    "White", "Asian", "Southeast Asian", "Mixed"
  )
)
report_participants(data)

# Race/ethnicity, control presentation treshold
report_participants(data, threshold = 5)

# Repeated measures data
data <- data.frame(
  "Age" = c(22, 22, 54, 54, 8, 8),
  "Sex" = c("I", "F", "M", "M", "F", "F"),
  "Gender" = c("N", "W", "W", "M", "M", "M"),
  "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3")
)
report_participants(data, age = "Age", sex = "Sex", gender = "Gender", participants = "Participant")

# Grouped data
data <- data.frame(
  "Age" = c(22, 22, 54, 54, 8, 8, 42, 42),
  "Sex" = c("I", "I", "M", "M", "F", "F", "F", "F"),
  "Gender" = c("N", "N", "W", "M", "M", "M", "Non-Binary", "Non-Binary"),
  "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3", "s4", "s4"),
  "Condition" = c("A", "A", "A", "A", "B", "B", "B", "B")
)

report_participants(data,
  age = "Age",
  sex = "Sex",
  gender = "Gender",
  participants = "Participant",
  by = "Condition"
)

# Spell sample size
paste(
  report_participants(data, participants = "Participant", spell_n = TRUE),
  "were recruited in the study by means of torture and coercion."
)



cleanEx()
nameEx("report_performance")
### * report_performance

flush(stderr()); flush(stdout())

### Name: report_performance
### Title: Report the model's quality and fit indices
### Aliases: report_performance

### ** Examples


## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)
## Don't show: 
if (requireNamespace("rstanarm", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)
## Don't show: 
if (requireNamespace("lavaan", quietly = TRUE) && packageVersion("effectsize") >= "0.6.0.1") (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report_priors")
### * report_priors

flush(stderr()); flush(stdout())

### Name: report_priors
### Title: Report priors of Bayesian models
### Aliases: report_priors

### ** Examples

## Don't show: 
if (requireNamespace("rstanarm", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report_random")
### * report_random

flush(stderr()); flush(stdout())

### Name: report_random
### Title: Report random effects and factors
### Aliases: report_random

### ** Examples

## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)
## Don't show: 
if (requireNamespace("rstanarm", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)
## Don't show: 
if (requireNamespace("brms", quietly = TRUE) && packageVersion("rstan") >= "2.26.0") (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report_s")
### * report_s

flush(stderr()); flush(stdout())

### Name: report_s
### Title: Report S- and p-values in easy language.
### Aliases: report_s

### ** Examples

report_s(s = 1.5)
report_s(p = 0.05)



cleanEx()
nameEx("report_sample")
### * report_sample

flush(stderr()); flush(stdout())

### Name: report_sample
### Title: Sample Description
### Aliases: report_sample

### ** Examples

library(report)

report_sample(iris[, 1:4])
report_sample(iris, select = c("Sepal.Length", "Petal.Length", "Species"))
report_sample(iris, by = "Species")
report_sample(airquality, by = "Month", n = TRUE, total = FALSE)

# confidence intervals for proportions
set.seed(123)
d <- data.frame(x = factor(sample(letters[1:3], 100, TRUE, c(0.01, 0.39, 0.6))))
report_sample(d, ci = 0.95, ci_method = "wald") # ups, negative CI
report_sample(d, ci = 0.95, ci_method = "wilson") # negative CI fixed
report_sample(d, ci = 0.95, ci_correct = TRUE) # continuity correction



cleanEx()
nameEx("report_statistics")
### * report_statistics

flush(stderr()); flush(stdout())

### Name: report_statistics
### Title: Report the statistics of a model
### Aliases: report_statistics

### ** Examples


## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)
## Don't show: 
if (requireNamespace("rstanarm", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report_table")
### * report_table

flush(stderr()); flush(stdout())

### Name: report_table
### Title: Report a descriptive table
### Aliases: report_table

### ** Examples


## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)
## Don't show: 
if (requireNamespace("rstanarm", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)
## Don't show: 
if (requireNamespace("lavaan", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("report_text")
### * report_text

flush(stderr()); flush(stdout())

### Name: report_text
### Title: Report a textual description of an object
### Aliases: report_text

### ** Examples

library(report)

# Miscellaneous
r <- report_text(sessionInfo())
r
summary(r)

# Data
report_text(iris$Sepal.Length)
report_text(as.character(round(iris$Sepal.Length, 1)))
report_text(iris$Species)
report_text(iris)

# h-tests
report_text(t.test(iris$Sepal.Width, iris$Sepal.Length))

# ANOVA
r <- report_text(aov(Sepal.Length ~ Species, data = iris))
r
summary(r)

# GLMs
r <- report_text(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
r
summary(r)

## Don't show: 
if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)
## Don't show: 
if (requireNamespace("rstanarm", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
## Don't show: 
}) # examplesIf
## End(Don't show)



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
