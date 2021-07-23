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
#' report_effectsize(cor.test(iris$Sepal.Width, iris$Sepal.Length))
#'
#' # ANOVAs
#' report_effectsize(aov(Sepal.Length ~ Species, data = iris))
#'
#' # GLMs
#' report_effectsize(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' report_effectsize(glm(vs ~ disp, data = mtcars, family = "binomial"))
#' \donttest{
#' # Mixed models
#' if (require("lme4")) {
#'   model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#'   report_effectsize(model)
#' }
#'
#' # Bayesian models
#' if (require("rstanarm")) {
#'   model <- stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600)
#'   report_effectsize(model, effectsize_method = "basic")
#' }
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

  cat(paste0(x, collapse = "\n"))
}



# Utilities ---------------------------------------------------------------



#' @keywords internal
.text_effectsize <- function(interpretation) {
  # Effect size
  if (!is.null(interpretation)) {
    if (is.character(interpretation)) {
      effsize_name <- ifelse(interpretation == "cohen1988", "Cohen's (1988)",
        ifelse(interpretation == "sawilowsky2009", "Savilowsky's (2009)",
          ifelse(interpretation == "gignac2016", "Gignac's (2016)",
            ifelse(interpretation == "funder2019", "Funder's (2019)",
              ifelse(interpretation == "chen2010", "Chen's (2010)",
                ifelse(interpretation == "field2013", "Field's (2013)", interpretation)
              )
            )
          )
        )
      )
      text <- paste0("Effect sizes were labelled following ", effsize_name, " recommendations.")
    } else {
      text <- paste0("Effect sizes were labelled following a custom set of rules.")
    }
  } else {
    text <- ""
  }
  text
}


#' @keywords internal
.text_standardize <- function(x, ...) {
  method <- attributes(x)$std_method
  robust <- attributes(x)$robust
  two_sd <- attributes(x)$two_sd

  if (method == "refit") {
    if (robust == TRUE) {
      text <- "(using the median and the MAD, a robust equivalent of the SD) "
    } else {
      text <- ""
    }
    text <- paste0("Standardized parameters were obtained by fitting the model on a standardized version ", text, "of the dataset.")
  } else if (method == "2sd") {
    if (robust == TRUE) {
      text <- "MAD (a median-based equivalent of the SD) "
    } else {
      text <- "SD "
    }
    text <- paste0("Standardized parameters were obtained by standardizing the data by 2 times the ", text, " (see Gelman, 2008).")
  } else if (method %in% c("smart", "basic", "posthoc")) {
    if (robust == TRUE) {
      text <- "median and the MAD (a median-based equivalent of the SD) of the response variable."
    } else {
      text <- "mean and the SD of the response variable."
    }
    text <- paste0("Parameters were scaled by the ", text)
  } else {
    text <- paste0("Parameters were standardized using the ", method, " method.")
  }

  text
}
