#' Report the effect size(s) of a model or a test
#'
#' Computes, interpret and formats the effect sizes of a variety of models and
#' statistical tests (see list of supported objects in [report()]).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return An object of class [report_effectsize()].
#'
#' @examples
#' library(report)
#'
#' # h-tests
#' report_effectsize(t.test(iris$Sepal.Width, iris$Sepal.Length))
#'
#' # ANOVAs
#' report_effectsize(aov(Sepal.Length ~ Species, data = iris))
#'
#' # GLMs
#' report_effectsize(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' report_effectsize(glm(vs ~ disp, data = mtcars, family = "binomial"))
#'
#' @examplesIf requireNamespace("lme4", quietly = TRUE)
#' \donttest{
#' # Mixed models
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' report_effectsize(model)
#' }
#'
#' @examplesIf requireNamespace("rstanarm", quietly = TRUE)
#' \donttest{
#' # Bayesian models
#' library(rstanarm)
#' model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
#' report_effectsize(model, effectsize_method = "basic")
#' }
#' @export
report_effectsize <- function(x, ...) {
  UseMethod("report_effectsize")
}


# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_effectsize <- function(x, summary = NULL, prefix = "  - ", ...) {
  class(x) <- unique(c("report_effectsize", class(x)))
  attributes(x) <- c(attributes(x), list(...))
  attr(x, "prefix") <- prefix

  if (!is.null(summary)) {
    class(summary) <- unique(c("report_effectsize", class(summary)))
    attr(summary, "prefix") <- prefix
    attr(x, "summary") <- summary
  }

  x
}


#' @export
summary.report_effectsize <- function(object, ...) {
  if (is.null(attributes(object)$summary)) {
    object
  } else {
    attributes(object)$summary
  }
}

#' @export
print.report_effectsize <- function(x, ...) {
  if (!is.null(attributes(x)$rules)) {
    cat(attributes(x)$rules, "\n\n")
  }

  cat(paste(x, collapse = "\n"))
}


# Utilities ---------------------------------------------------------------


#' @keywords internal
.text_effectsize <- function(interpretation) {
  # Effect size
  if (is.null(interpretation)) {
    effect_text <- ""
  } else if (is.character(interpretation)) {
    effsize_name <- switch(interpretation,
      cohen1988 = "Cohen's (1988)",
      sawilowsky2009 = "Savilowsky's (2009)",
      gignac2016 = "Gignac's (2016)",
      funder2019 = "Funder's (2019)",
      lovakov2021 = "Lovakov's (2021)",
      evans1996 = "Evans's (1996)",
      chen2010 = "Chen's (2010)",
      field2013 = "Field's (2013)",
      landis1977 = "Landis' (1977)"
    )
    effect_text <- paste0("Effect sizes were labelled following ", effsize_name, " recommendations.")
  } else {
    effect_text <- paste0("Effect sizes were labelled following a custom set of rules.")
  }
  effect_text
}


#' @keywords internal
.text_standardize <- function(x, ...) {
  method <- attributes(x)$std_method
  robust <- attributes(x)$robust
  two_sd <- attributes(x)$two_sd

  if (method == "refit") {
    if (robust) {
      standard_text <- "(using the median and the MAD, a robust equivalent of the SD) "
    } else {
      standard_text <- ""
    }
    standard_text <- paste0(
      "Standardized parameters were obtained by fitting the model on a standardized version ",
      standard_text, "of the dataset."
    )
  } else if (method == "2sd") {
    if (robust) {
      standard_text <- "MAD (a median-based equivalent of the SD) "
    } else {
      standard_text <- "SD "
    }
    standard_text <- paste0(
      "Standardized parameters were obtained by standardizing the data by 2 times the ",
      standard_text, " (see Gelman, 2008)."
    )
  } else if (method %in% c("smart", "basic", "posthoc")) {
    if (robust) {
      standard_text <- "median and the MAD (a median-based equivalent of the SD) of the response variable."
    } else {
      standard_text <- "mean and the SD of the response variable."
    }
    standard_text <- paste0("Parameters were scaled by the ", standard_text)
  } else {
    standard_text <- paste0("Parameters were standardized using the ", method, " method.")
  }

  standard_text
}
