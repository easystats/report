#' Report the parameters of a model
#'
#' Creates a list containing a description of the parameters of R objects (see
#' list of supported objects in [report()]).
#'
#' @inheritParams report
#' @inheritParams report_table
#' @inheritParams report_text
#' @inheritParams as.report
#'
#' @return A `vector`.
#'
#' @examples
#' \donttest{
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
#'
#' # ANOVA
#' report_parameters(aov(Sepal.Length ~ Species, data = iris))
#'
#' # GLMs
#' report_parameters(lm(Sepal.Length ~ Petal.Length * Species, data = iris))
#' report_parameters(lm(Petal.Width ~ Species, data = iris), include_intercept = FALSE)
#' report_parameters(glm(vs ~ disp, data = mtcars, family = "binomial"))
#' }
#'
#' @examplesIf requireNamespace("lme4", quietly = TRUE)
#' \donttest{
#' # Mixed models
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' report_parameters(model)
#' }
#'
#' @examplesIf requireNamespace("rstanarm", quietly = TRUE)
#' \donttest{
#' # Bayesian models
#' library(rstanarm)
#' model <- suppressWarnings(stan_glm(Sepal.Length ~ Species, data = iris, refresh = 0, iter = 600))
#' report_parameters(model)
#' }
#' @export
report_parameters <- function(x, ...) {
  UseMethod("report_parameters")
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
  if (is.null(prefix)) {
    prefix <- attributes(x)$prefix
  }
  if (is.null(prefix)) {
    prefix <- ""
  }

  # Concatenate
  text_output <- paste0(prefix, x)
  text_output <- paste(text_output, collapse = "\n")
  text_output
}

#' @export
summary.report_parameters <- function(object, ...) {
  if (is.null(attributes(object)$summary)) {
    object
  } else {
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
  for (i in seq_along(names)) {
    if (grepl(":", names[i], fixed = TRUE)) {
      interaction_terms <- unlist(strsplit(names[i], ":", fixed = TRUE))
      names[i] <- paste0(
        "The interaction between ",
        datawizard::text_concatenate(interaction_terms)
      )
    } else {
      names[i] <- paste0("The main effect of ", names[i])
    }
  }
  names
}

#' @keywords internal
.format_parameters_regression <- function(names) {
  for (i in seq_along(names)) {
    # Interaction
    if (grepl(" * ", names[i], fixed = TRUE)) {
      parts <- unlist(strsplit(names[i], " * ", fixed = TRUE))
      basis <- paste(utils::head(parts, -1), collapse = " * ")
      names[i] <- paste0(
        "The interaction effect of ",
        utils::tail(parts, 1),
        " on ",
        basis
      )

      # Intercept
    } else if (names[i] == "(Intercept)") {
      names[i] <- paste0("The intercept")

      # No interaction
    } else {
      names[i] <- paste0("The effect of ", names[i])
    }
  }
  names
}

#' @keywords internal
.parameters_starting_text <- function(x, params) {
  if ("pretty_names" %in% attributes(params)) {
    pretty_name <- attributes(params)$pretty_names[params$Parameter]
  } else {
    pretty_name <- parameters::format_parameters(x)
  }

  text_output <- vapply(
    pretty_name,
    .format_parameters_regression,
    USE.NAMES = TRUE,
    "character"
  )

  text_output
}


#' @keywords internal
.parameters_diagnostic_bayesian <- function(
  diagnostic,
  only_when_insufficient = FALSE,
  ...
) {
  # Convergence
  if ("Rhat" %in% names(diagnostic)) {
    convergence <- effectsize::interpret_rhat(diagnostic$Rhat, ...)
    text_output <- ifelse(
      convergence == "converged",
      paste0(
        "The estimation successfully converged (Rhat = ",
        insight::format_value(diagnostic$Rhat, digits = 3),
        ")"
      ),
      paste0(
        "However, the estimation might not have successfuly converged (Rhat = ",
        insight::format_value(diagnostic$Rhat, digits = 3),
        ")"
      )
    )

    if ("ESS" %in% names(diagnostic)) {
      stability <- effectsize::interpret_ess(diagnostic$ESS, ...)
      text_output <- lapply(seq_along(stability), function(x) {
        y <- switch(
          EXPR = paste(
            stability[x] == "sufficient",
            convergence[x] == "converged"
          ),
          "TRUE TRUE" = paste0(
            text_output,
            " and the indices are reliable (ESS = ",
            insight::format_value(diagnostic$ESS, digits = 0),
            ")"
          ),
          "TRUE FALSE" = paste0(
            text_output,
            " even though the indices appear as reliable (ESS = ",
            insight::format_value(diagnostic$ESS, digits = 0),
            ")"
          ),
          "FALSE TRUE" = paste0(
            text_output,
            " but the indices are unreliable (ESS = ",
            insight::format_value(diagnostic$ESS, digits = 0),
            ")"
          ),
          "FALSE FALSE" = paste0(
            text_output,
            " and the indices are unreliable (ESS = ",
            insight::format_value(diagnostic$ESS, digits = 0),
            ")"
          )
        )
        y[[x]]
      })
      text_output <- unlist(text_output)
    }
  } else {
    text_output <- ""
  }

  if (only_when_insufficient) {
    ifelse(
      convergence != "converged" | stability != "sufficient",
      text_output,
      ""
    )
  } else {
    text_output
  }
}
