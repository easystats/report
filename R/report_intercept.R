#' Report intercept
#'
#' Reports intercept of regression models (see list of supported objects in
#' [report()]).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return An object of class [report_intercept()].
#'
#' @examples
#' \donttest{
#' library(report)
#'
#' # GLMs
#' report_intercept(lm(Sepal.Length ~ Species, data = iris))
#' report_intercept(glm(vs ~ disp, data = mtcars, family = "binomial"))
#' }
#'
#' @examplesIf requireNamespace("lme4", quietly = TRUE)
#' \donttest{
#' # Mixed models
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' report_intercept(model)
#' }
#'
#' @examplesIf requireNamespace("rstanarm", quietly = TRUE)
#' \donttest{
#' # Bayesian models
#' library(rstanarm)
#' model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
#' report_intercept(model)
#' }
#' @export

report_intercept <- function(x, ...) {
  UseMethod("report_intercept")
}


# METHODS -----------------------------------------------------------------

#' @rdname as.report
#' @export
as.report_intercept <- function(x, summary = NULL, ...) {
  class(x) <- unique(c("report_intercept", class(x)))
  attributes(x) <- c(attributes(x), list(...))

  if (!is.null(summary)) {
    attr(x, "summary") <- summary
  }
  x
}


#' @export
summary.report_intercept <- function(object, ...) {
  if (is.null(attributes(object)$summary)) {
    object
  } else {
    attributes(object)$summary
  }
}

#' @export
print.report_intercept <- function(x, ...) {
  cat(paste(x, collapse = "\n"))
}


# Utils -------------------------------------------------------------------

#' @keywords internal
.find_intercept <- function(model) {
  # Intercept-only
  if (suppressWarnings(insight::is_nullmodel(model))) {
    return("")
  }

  model_terms <- insight::find_variables(model)$conditional
  model_data <- insight::get_data(model)
  intercept_data <- model_data[model_terms[model_terms %in% names(model_data)]]
  intercept_text <- NULL
  for (col in names(intercept_data)) {
    if (is.numeric(intercept_data[[col]])) {
      intercept_text <- c(intercept_text, paste0(col, " = 0"))
    } else if (is.character(intercept_data[[col]])) {
      intercept_text <- c(intercept_text, paste0(col, " = ", levels(as.factor(intercept_data[[col]]))[1]))
    } else if (is.factor(intercept_data[[col]])) {
      ref_level <- .find_reference_level(intercept_data[[col]])
      intercept_text <- c(intercept_text, paste0(col, " = ", levels(intercept_data[[col]])[ref_level]))
    } else {
      intercept_text <- c(intercept_text, paste0(col, " = [?]"))
    }
  }
  paste0(", corresponding to ", datawizard::text_concatenate(intercept_text), ",")
}


.find_reference_level <- function(f) {
  tryCatch(
    {
      con <- stats::contrasts(f)
      unname(which(apply(con, 1, function(i) sum(i) == 0)))
    },
    error = function(e) {
      1
    }
  )
}
