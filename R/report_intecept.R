#' Report intercept
#'
#' Reports intercept of regression models (see list of supported objects in \code{\link{report}}).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return A \code{character} string.
#'
#' @examples
#' library(report)
#'
#' # GLMs
#' report_intercept(lm(Sepal.Length ~ Species, data = iris))
#' report_intercept(glm(vs ~ disp, data = mtcars, family = "binomial"))
#'
#' if(require("lme4")){
#'   # model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#'   # report_intercept(model)
#' }
#' @export
report_intercept <- function(x, ...) {
  UseMethod("report_intercept")
}


#' @export
report_intercept.default <- function(x, ...) {
  stop(paste0("report_intercept() is not available for objects of class ", class(x)))
}

# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_intercept <- function(x, summary = NULL, ...) {
  class(x) <- unique(c("report_info", class(x)))
  attributes(x) <- c(attributes(x), list(...))

  if (!is.null(summary)) {
    attr(x, "summary") <- summary
  }
  x
}


#' @export
summary.report_intercept <- function(object, ...) {
  if(is.null(attributes(object)$summary)){
    object
  } else{
    attributes(object)$summary
  }
}

#' @export
print.report_intercept <- function(x, ...) {
  cat(paste0(x, collapse = "\n"))
}



# Utils -------------------------------------------------------------------




#' @importFrom insight is_nullmodel get_data find_variables
#' @keywords internal
.find_intercept <- function(model) {

  # Intercept-only
  if (insight::is_nullmodel(model)) {
    return("")
  }

  terms <- insight::find_variables(model)$conditional
  data <- insight::get_data(model)[terms %in% names(insight::get_data(model))]
  text <- c()
  for (col in names(data)) {
    if (is.numeric(data[[col]])) {
      text <- c(text, paste0(col, " = 0"))
    } else if (is.character(data[[col]])) {
      data[col] <- as.character(data[col])
      text <- c(text, paste0(col, " = ", levels(data[[col]])[1]))
    } else if (is.factor(data[[col]])) {
      text <- c(text, paste0(col, " = ", levels(data[[col]])[.find_reference_level(data[[col]])]))
    } else {
      text <- c(text, paste0(col, " = [?]"))
    }
  }
  paste0(", corresponding to ", format_text(text), ",")
}



#' @importFrom stats contrasts
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

