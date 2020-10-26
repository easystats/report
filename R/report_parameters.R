#' Report the parameters of a model
#'
#' Creates a list containing a description of the parameters of R objects (see list of supported objects in \code{\link{report}}).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return A \code{vector}.
#'
#' @examples
#' library(report)
#'
#' # Miscellaneous
#' r <- report_parameters(sessionInfo())
#' r
#' summary(r)
#'
#' # Data
#' report_parameters(iris$Sepal.Length)
#' report_parameters(as.character(round(iris$Sepal.Length, 1)))
#' report_parameters(iris$Species)
#' report_parameters(iris)
#'
#' # h-tests
#' report_parameters(t.test(iris$Sepal.Width, iris$Sepal.Length))
#' report_parameters(cor.test(iris$Sepal.Width, iris$Sepal.Length))
#'
#' # ANOVA
#' report_parameters(aov(Sepal.Length ~ Species, data=iris))
#'
#' # GLMs
#' report_parameters(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' report_parameters(lm(Petal.Width ~ Species, data = iris), include_intercept=FALSE)
#' report_parameters(glm(vs ~ disp, data = mtcars, family = "binomial"))
#'
#' # Mixed models
#' if(require("lme4")){
#'   model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#'   report_parameters(model)
#' }
#'
#' # Bayesian models
#' if(require("rstanarm")){
#'   model <- stan_glm(Sepal.Length ~ Species, data = iris, refresh=0, iter=600)
#'   report_parameters(model)
#' }
#' @export
report_parameters <- function(x, table = NULL, ...) {
  UseMethod("report_parameters")
}


#' @export
report_parameters.default <- function(x, ...) {
  stop(paste0("report_parameters() is not available for objects of class ", class(x)))
}

# METHODS -----------------------------------------------------------------


#' @rdname as.report
#' @export
as.report_parameters <- function(x, summary = NULL, prefix = "  - ", ...) {
  class(x) <- unique(c("report_parameters", class(x)))
  attributes(x) <- c(attributes(x), list(...))
  attr(x, "prefix") <- prefix

  if (!is.null(summary)) {
    class(summary) <- unique(c("report_parameters", class(summary)))
    attr(summary, "prefix") <- prefix
    attr(x, "summary") <- summary
  }
  x
}

#' @export
as.character.report_parameters <- function(x, prefix = NULL, ...) {
  # Find prefix
  if (is.null(prefix)) prefix <- attributes(x)$prefix
  if (is.null(prefix)) prefix <- ""

  # Concatenate
  text <- paste0(prefix, x)
  text <- paste0(text, collapse = "\n")
  text
}

#' @export
summary.report_parameters <- function(object, ...) {
  if (is.null(attributes(object)$summary)) {
    object
  } else{
    attributes(object)$summary
  }
}


#' @export
print.report_parameters <- function(x, ...) {
  cat(as.character(x, ...))
}



# Utils -------------------------------------------------------------------

#' @keywords internal
.format_parameters_aov <- function(names) {
  for(i in 1:length(names)){
    if (grepl(":", names[i], fixed = TRUE)) {
      names[i] <- format_text(unlist(strsplit(names[i], ":", fixed = TRUE)))
      names[i] <- paste0("The interaction between ", names[i])
    } else {
      names[i] <- paste0("The main effect of ", names[i])
    }
  }
  names
}

#' @keywords internal
.format_parameters_regression <- function(names) {
  for(i in 1:length(names)){
    # Interaction
    if (grepl(" * ", names[i], fixed=TRUE)) {
      parts <- unlist(strsplit(names[i], " * ", fixed = TRUE))
      basis <- paste0(head(parts, -1), collapse = " * ")
      names[i] <- paste0("The interaction effect of ", tail(parts, 1), " on ", basis)

    # Intercept
    } else if(names[i] == "(Intercept)") {
      names[i] <- paste0("The intercept")

    # No interaction
    } else {
      names[i] <- paste0("The effect of ", names[i])
    }
  }
  names
}