## ---- echo = FALSE----------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  warning = FALSE,
  message = FALSE,
  out.width = "100%",
  tidy.opts = list(width.cutoff = 60),
  tidy = TRUE,
  comment = "#"
)

options(
  knitr.kable.NA = "",
  digits = 4,
  width = 60
)

if (!requireNamespace("dplyr", quietly = TRUE)) {
  knitr::opts_chunk$set(eval = FALSE)
}

## ----eval=FALSE-------------------------------------------
#  install.packages("remotes")
#  remotes::install_github("easystats/report") # You only need to do that once

## ---------------------------------------------------------
library("report") # Load the package every time you start R

## ---------------------------------------------------------
report(iris)

## ---------------------------------------------------------
library(dplyr)

iris %>%
  group_by(Species) %>%
  report_table()

## ---------------------------------------------------------
report(cor.test(mtcars$wt, mtcars$mpg))

## ---------------------------------------------------------
report(t.test(formula = wt ~ am, data = mtcars))

## ---------------------------------------------------------
model <- lm(wt ~ am + mpg, data = mtcars)

report(model)

## ---------------------------------------------------------
model <- aov(wt ~ am + mpg, data = mtcars)

report(model)

## ---------------------------------------------------------
model <- glm(vs ~ mpg + cyl, data = mtcars, family = "binomial")

report(model)

## ---------------------------------------------------------
library(lme4)

model <- lmer(Reaction ~ Days + (Days | Subject), data = sleepstudy)

report(model)

