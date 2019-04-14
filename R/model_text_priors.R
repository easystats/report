#' @keywords internal
model_text_priors <- function(parameters){

  # Return empty if no priors info
  if(!"Prior_Distribution" %in% names(parameters)){
    return("")}

  params <- parameters[parameters$Parameter != "(Intercept)", ]
  values <- ifelse(params$Prior_Distribution == "normal",
                 paste0("mean = ", format_value(params$Prior_Location), ", SD = ", format_value(params$Prior_Scale)),
                 paste0("location = ", format_value(params$Prior_Location), ", scale = ", format_value(params$Prior_Scale)))

  values <- paste0(params$Prior_Distribution, " (", values, ")")

  if(length(unique(values)) == 1 & nrow(params) > 1){
    text <- paste0("all set as ", values[1])
  } else{
    text <- paste0("set as ", format_text_collapse(values))
  }

  text <- paste0("Priors over parameters were ", text, " distributions.")
  return(text)

}