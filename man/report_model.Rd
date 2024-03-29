% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_model.R
\name{report_model}
\alias{report_model}
\title{Report the model type}
\usage{
report_model(x, table = NULL, ...)
}
\arguments{
\item{x}{The R object that you want to report (see list of of supported
objects above).}

\item{table}{A table obtained via \code{report_table()}. If not provided,
will run it.}

\item{...}{Arguments passed to or from other methods.}
}
\value{
A \code{character} string.
}
\description{
Reports the type of different R objects (see list of supported objects in
\code{\link[=report]{report()}}).
}
\examples{
\donttest{
library(report)

# h-tests
report_model(t.test(iris$Sepal.Width, iris$Sepal.Length))

# ANOVA
report_model(aov(Sepal.Length ~ Species, data = iris))

# GLMs
report_model(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
report_model(glm(vs ~ disp, data = mtcars, family = "binomial"))
}

\dontshow{if (requireNamespace("lme4", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
\donttest{
# Mixed models
library(lme4)
model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
report_model(model)
}
\dontshow{\}) # examplesIf}
\dontshow{if (requireNamespace("rstanarm", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
\donttest{
# Bayesian models
library(rstanarm)
model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
report_model(model)
}
\dontshow{\}) # examplesIf}
}
