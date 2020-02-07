#' @export
text_parameters.estimate_contrasts <- function(model, parameters = NULL, prefix = "  - ", effsize = "funder2019", ...) {
  if (is.null(parameters)) {
    parameters <- as.data.frame(model)
  }

  # Create name
  if (!is.null(attributes(model)$modulate)) {
    parameters$Parameter <- paste0(
      "The difference between ",
      parameters$Level1, " and ",
      parameters$Level2, " when ",
      attributes(model)$modulate, " is ",
      insight::format_value(parameters[[attributes(model)$modulate]], protect_integers = TRUE)
    )
  } else {
    parameters$Parameter <- paste0(
      "The difference between ",
      parameters$Level1, " and ",
      parameters$Level2
    )
  }


  # Create text
  text <- .text_parameters_combine(
    names = .text_parameters_names(parameters),
    direction = .text_parameters_direction(parameters),
    size = .text_parameters_size(parameters, effsize = effsize, type = "d"),
    significance = .text_parameters_significance(parameters, rope_ci = attributes(model)$rope_ci),
    indices = .text_parameters_indices(parameters, ci = attributes(model)$ci)
  )

  paste0(paste0(prefix, text), collapse = "\n")
}


#' @export
text_parameters.estimate_slopes <- function(model, parameters = NULL, prefix = "  - ", effsize = "funder2019", ...) {
  if (is.null(parameters)) {
    parameters <- as.data.frame(model)
  }

  # Create name
  levels <- attributes(model)$levels[!attributes(model)$levels %in% attributes(model)$fixed]
  if (!is.null(attributes(model)$modulate)) {
    parameters$Parameter <- paste0(
      "The marginal effect at ",
      parameters[[levels]], " when ",
      attributes(model)$modulate, " is ",
      insight::format_value(parameters[[attributes(model)$modulate]], protect_integers = TRUE)
    )
  } else {
    parameters$Parameter <- paste0(
      "The marginal effect at ",
      parameters[[levels]]
    )
  }


  # Create text
  text <- .text_parameters_combine(
    names = .text_parameters_names(parameters),
    direction = .text_parameters_direction(parameters),
    size = .text_parameters_size(parameters, effsize = effsize, type = "d"),
    significance = .text_parameters_significance(parameters, rope_ci = attributes(model)$rope_ci),
    indices = .text_parameters_indices(parameters, ci = attributes(model)$ci)
  )

  paste0(paste0(prefix, text), collapse = "\n")
}





#' @export
text_parameters.estimate_means <- function(model, parameters = NULL, prefix = "  - ", ...) {
  if (is.null(parameters)) {
    parameters <- as.data.frame(model)
  }

  # Create name
  levels <- attributes(model)$levels[!attributes(model)$levels %in% attributes(model)$fixed]
  # Create name
  if (!is.null(attributes(model)$modulate)) {
    parameters$Parameter <- paste0(
      parameters[, levels], " when ",
      attributes(model)$modulate, " is ",
      insight::format_value(parameters[[attributes(model)$modulate]], protect_integers = TRUE)
    )
  } else {
    parameters$Parameter <- parameters[, levels]
  }

  # Create text
  text <- paste0(parameters$Parameter, ": ", .text_parameters_indices(parameters, ci = attributes(model)$ci), ".")

  paste0(paste0(prefix, text), collapse = "\n")
}
