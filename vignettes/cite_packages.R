## ---- echo = FALSE------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  message = FALSE,
  warning = FALSE,
  tidy.opts = list(width.cutoff = 60),
  tidy = TRUE,
  comment = "#"
)

options(knitr.kable.NA = '', digits = 4)

if (!requireNamespace("dplyr", quietly = TRUE)) {
  knitr::opts_chunk$set(eval = FALSE)
}

## ---- results='asis'----------------------------------------------------------
library(report)
library(dplyr)

cite_packages()

## ----results='asis'-----------------------------------------------------------
cite_easystats()

