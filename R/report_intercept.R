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
#'
#' # Mixed models
#' if (require("lme4")) {
#'   model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#'   report_intercept(model)
#' }
#'
#' # Bayesian models
#' if (require("rstanarm")) {
#'   model <- stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600)
#'   report_intercept(model)
#' }
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
  cat(paste0(x, collapse = "\n"))
}


# Utils -------------------------------------------------------------------

#' @keywords internal
.find_intercept <- function(model) {
  # Intercept-only
  if (insight::is_nullmodel(model)) {
    return("")
  }

  terms <- insight::find_variables(model)$conditional
  model_data <- insight::get_data(model)
  data <- model_data[terms[terms %in% names(model_data)]]
  text <- c()
  for (col in names(data)) {
    if (is.numeric(data[[col]])) {
      text <- c(text, paste0(col, " = 0"))
    } else if (is.character(data[[col]])) {
      text <- c(text, paste0(col, " = ", levels(as.factor(data[[col]]))[1]))
    } else if (is.factor(data[[col]])) {
      text <- c(text, paste0(col, " = ", levels(data[[col]])[.find_reference_level(data[[col]])]))
    } else {
      text <- c(text, paste0(col, " = [?]"))
    }
  }
  paste0(", corresponding to ", paste(text, collapse = ", "), ",")
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
