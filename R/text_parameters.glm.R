#' @export
text_parameters.lm <- function(model, parameters = NULL, prefix = "  - ", ci = 0.95, effsize = "funder2019", ...){

  if(!is.null(attributes(parameters)$clean_names)){
    parameters$Parameter <- attributes(parameters)$clean_names
  }

  params <- as.data.frame(parameters[!parameters$Parameter %in% c("(Intercept)"), ])

  text_full <- .text_parameters(params, ci = ci, effsize = effsize, type = "d", prefix = prefix)
  text <- .text_parameters(params[names(params) %in% c("Parameter", "Coefficient", "Median", "Mean", "MAP", "CI_low", "CI_high", "p", "pd", "ROPE_Percentage", "BF", "Std_Coefficient", "Std_Median", "Std_Mean", "Std_MAP")], ci = ci, effsize = effsize, type = "d", prefix = prefix)

  list(
    "text" = text,
    "text_full" = text_full
  )
}




#' @keywords internal
.text_parameters <- function(params, ci, effsize, type, prefix = "  - "){
  text <- .text_parameters_combine(direction = .text_parameters_direction(params),
                                   size = .text_parameters_size(params, effsize = effsize, type = "d"),
                                   significance = .text_parameters_significance(params),
                                   indices = .text_parameters_indices(params, ci = ci))
  paste0(paste0(prefix, .text_parameters_names(params), text), collapse = "\n")
}
