#' Report the effect size(s) of a model or a test
#'
#' Computes, interpret and formats the effect sizes of a variety of models and statistical tests (see list of supported objects in \code{\link{report}}).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return An object of class \code{report_effectsize}.
#'
#' @examples
#' library(report)
#'
#' # h-tests
#' report_effectsize(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report_effectsize(cor.test(iris$Sepal.Width, iris$Sepal.Length))
#' @export
report_effectsize <- function(x, ...) {
  UseMethod("report_effectsize")
}


#' @export
report_effectsize.default <- function(x, ...) {
  stop(paste0("report_effectsize() is not available for objects of class ", class(x)))
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
  if(is.null(attributes(object)$summary)){
    object
  } else{
    attributes(object)$summary
  }
}

#' @export
print.report_effectsize <- function(x, ...) {
  if(!is.null(attributes(x)$rules)){
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
                                                  ifelse(interpretation == "chen2010", "Chen's (2010)", interpretation)
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
