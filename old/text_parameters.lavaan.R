#' @export
text_parameters.lavaan <- function(model, parameters = NULL, prefix = "  - ", effsize = "funder2019", ...) {
  if (is.null(parameters)) {
    parameters <- as.data.frame(model)
  }

  parameters <- as.data.frame(parameters)

  # Create name
  parameters$Label <- ifelse(parameters$Type == "Loading",
                                 paste0("loading of "),
                                 ifelse(parameters$Type == "Correlation",
                                        paste0("correlation between "),
                                        ifelse(parameters$Type == "Regression",
                                               paste0("effect of "),
                                               NA)))
  parameters$Parameter <- ifelse(parameters$Type == "Loading",
                                 paste0(parameters$From, " on ", parameters$To),
                                 ifelse(parameters$Type == "Correlation",
                                        paste0(parameters$From, " and ", parameters$To),
                                        ifelse(parameters$Type == "Regression",
                                               paste0(parameters$From, " on ", parameters$To),
                                               NA)))
  parameters <- parameters[!is.na(parameters$Parameter), ]

  # Text Loadings
  if(nrow(parameters[parameters$Type == "Loading", ]) >= 1){
    params <- parameters[parameters$Type == "Loading", ]

    text_loadings <- .text_parameters_combine(
      names = .text_parameters_names(params, label = params[1, "Label"]),
      direction = .text_parameters_direction(params),
      significance = .text_parameters_significance(params),
      indices = .text_parameters_indices(params, ci = attributes(parameters)$ci)
    )
    text_loadings <- paste0("The loadings were the following:\n", paste0(paste0(prefix, text_loadings), collapse = "\n"))
  } else{
    text_loadings <- ""
  }

  # Text Correlations
  if(nrow(parameters[parameters$Type == "Correlation", ]) >= 1){
    params <- parameters[parameters$Type == "Correlation", ]

    text_correlations <- .text_parameters_combine(
      names = .text_parameters_names(params, label = params[1, "Label"]),
      direction = .text_parameters_direction(params),
      size = .text_parameters_size(params, effsize = effsize, type = "r"),
      significance = .text_parameters_significance(params),
      indices = .text_parameters_indices(params[names(params)[names(params) != "Std_Coefficient"]], ci = attributes(parameters)$ci, coefname = "r")
    )
    text_correlations <- paste0("The correlations presented the following characteristics:\n", paste0(paste0(prefix, text_correlations), collapse = "\n"))
  } else{
    text_correlations <- ""
  }

  # Text Regression
  if(nrow(parameters[parameters$Type == "Regression", ]) >= 1){
    params <- parameters[parameters$Type == "Regression", ]

    text_regressions <- .text_parameters_combine(
      names = .text_parameters_names(params, label = params[1, "Label"]),
      direction = .text_parameters_direction(params),
      size = .text_parameters_size(params, effsize = effsize, type = "d"),
      significance = .text_parameters_significance(params),
      indices = .text_parameters_indices(params, ci = attributes(parameters)$ci)
    )
    text_regressions <- paste0("The regression parameters were estimated as follows:\n", paste0(paste0(prefix, text_regressions), collapse = "\n"))
  } else{
    text_regressions <- ""
  }


  paste0(c(text_loadings, text_correlations, text_regressions), collapse = "\n\n")
}
