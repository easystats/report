#' @export
text_model.estimate_contrasts <- function(model, effsize = "funder2019", ...) {
  text <- paste0("We ran a contrast anaysis based on estimated marginal means at different levels of the ", format_text(attributes(model)$levels), " factor", ifelse(length(attributes(model)$levels) > 1, "s", ""))

  if (!is.null(attributes(model)$fixed)) {
    text <- paste0(
      text,
      " (adjusted for ",
      attributes(model)$fixed,
      ")"
    )
  }

  text <- paste0(text, ".")
  text_full <- text

  # Details
  if (!is.null(attributes(model)$rope_range)) {
    text_full <- paste0(
      text_full,
      .text_rope(attributes(model)$rope_range, attributes(model)$rope_ci)
    )
  }
  if (!is.null(attributes(model)$ci) && !is.null(attributes(model)$ci_method)) {
    text_full <- paste0(
      text_full,
      .text_ci(attributes(model)$ci, attributes(model)$ci_method)
    )
  }
  if (!is.null(effsize)) {
    text_full <- paste0(
      text_full,
      .text_effsize(effsize)
    )
  }


  text_full <- paste0(
    text_full,
    " Within this model:\n\n"
  )
  text <- paste0(
    text,
    " Within this model:\n\n"
  )
  list(
    "text" = text,
    "text_full" = text_full
  )
}



#' @export
text_model.estimate_slopes <- function(model, effsize = "funder2019", ...) {
  text <- paste0("We estimated the marginal effect of ", attributes(model)$trend, " at different levels of the ", attributes(model)$levels, " factor")

  if (!is.null(attributes(model)$fixed)) {
    text <- paste0(
      text,
      " (adjusted for ",
      attributes(model)$fixed,
      ")"
    )
  }

  text <- paste0(text, ".")
  text_full <- text

  # Details
  if (!is.null(attributes(model)$rope_range)) {
    text_full <- paste0(
      text_full,
      .text_rope(attributes(model)$rope_range, attributes(model)$rope_ci)
    )
  }
  if (!is.null(attributes(model)$ci) && !is.null(attributes(model)$ci_method)) {
    text_full <- paste0(
      text_full,
      .text_ci(attributes(model)$ci, attributes(model)$ci_method)
    )
  }
  if (!is.null(effsize)) {
    text_full <- paste0(
      text_full,
      .text_effsize(effsize)
    )
  }



  text_full <- paste0(
    text_full,
    " Within this model:\n\n"
  )
  text <- paste0(
    text,
    " Within this model:\n\n"
  )
  list(
    "text" = text,
    "text_full" = text_full
  )
}





#' @export
text_model.estimate_means <- function(model, ...) {
  levels <- attributes(model)$levels[!attributes(model)$levels %in% attributes(model)$fixed]
  text <- paste0("We estimated marginal means at different levels of the ", levels, " factor")

  if (!is.null(attributes(model)$fixed)) {
    text <- paste0(
      text,
      " (adjusted for ",
      attributes(model)$fixed,
      ")"
    )
  }

  text <- paste0(text, ".")
  text_full <- text

  # Details
  if (!is.null(attributes(model)$ci) && !is.null(attributes(model)$ci_method)) {
    text_full <- paste0(
      text_full,
      .text_ci(attributes(model)$ci, attributes(model)$ci_method)
    )
  }

  text_full <- paste0(
    text_full,
    " Within this model:\n\n"
  )
  text <- paste0(
    text,
    " Within this model:\n\n"
  )
  list(
    "text" = text,
    "text_full" = text_full
  )
}
