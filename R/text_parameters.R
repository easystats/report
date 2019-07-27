#' @keywords internal
.text_parameters_direction <- function(parameters, parameter_column = "Parameter"){

  estimate_name <- names(parameters)[names(parameters) %in% c("Coefficient", "Median", "Mean", "MAP")][1]

  if(length(estimate_name) == 1){
    if("pd" %in% names(parameters)){
      text <- paste0(
        parameters[[parameter_column]],
        " has a probability of ",
        parameters::format_pd(parameters$pd, name = NULL),
        " of being ",
        interpret_direction(parameters[[estimate_name]])
      )
    } else{
      text <- paste0(
        parameters[[parameter_column]],
        " is ",
        interpret_direction(parameters[[estimate_name]])
      )
    }
  } else{
    text <- parameters[[parameter_column]]
  }

  text
}





#' @keywords internal
.text_parameters_size <- function(parameters, effsize = "cohen1988", type = "d"){
  text <- ""

  estimate_name <- names(parameters)[names(parameters) %in% c("Std_Coefficient", "Std_Median", "Std_Mean", "Std_MAP")][1]

  if(type == "d"){
    text <- interpret_d(parameters[[estimate_name]], rules = effsize)
  }

  text
}





#' @keywords internal
.text_parameters_significance <- function(parameters, rope_ci = 1){
  text <- ""

  if("p" %in% names(parameters)){
    text <- interpret_p(parameters$p)
  }

  if("ROPE_Percentage" %in% names(parameters) & !is.null(rope_ci)){
    text <- interpret_rope(parameters$ROPE_Percentage, ci = rope_ci)
  }
  text
}



#' @keywords internal
.text_parameters_indices <- function(parameters, ci = 0.89){

  text <- ""

  if ("Coefficient" %in% names(parameters)) {
    text <- paste0(
      text,
      "beta = ",
      parameters::format_value(parameters$Coefficient))
  }

  if ("Difference" %in% names(parameters)) {
    text <- paste0(
      text,
      "Difference = ",
      parameters::format_value(parameters$Difference)
    )
  }

  if ("SE" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "SE = ",
      parameters::format_value(parameters$SE))
  }

  if ("Median" %in% names(parameters)) {
    text <- paste0(
      text,
      "median = ",
      parameters::format_value(parameters$Median))
  }

  if ("MAD" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "MAD = ",
      parameters::format_value(parameters$MAD))
  }

  if ("Mean" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "mean = ",
      parameters::format_value(parameters$Mean))
  }

  if ("SD" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "SD = ",
      parameters::format_value(parameters$SD))
  }

  if ("MAP" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "MAP = ",
      parameters::format_value(parameters$MAP)
    )
  }


  # CI
  if (all(c("CI_low", "CI_high") %in% names(parameters))) {
    text <- paste0(
      .add_comma(text),
      parameters::format_ci(parameters$CI_low, parameters$CI_high, ci = ci)
    )
  }

  # ROPE
  if ("ROPE_Percentage" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      parameters::format_rope(parameters$ROPE_Percentage)
    )
  }


  # Standardized stuff
  if ("Std_Coefficient" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "beta (std.) = ",
      parameters::format_value(parameters$Std_Coefficient))
  }

  if ("Std_SE" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "SE (std.) = ",
      parameters::format_value(parameters$Std_SE))
  }

  if ("Std_Median" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "median (std.) = ",
      parameters::format_value(parameters$Std_Median))
  }

  if ("Std_MAD" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "MAD (std.) = ",
      parameters::format_value(parameters$Std_MAD))
  }

  if ("Std_Mean" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "mean (std.) = ",
      parameters::format_value(parameters$Std_Mean))
  }

  if ("Std_SD" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "SD (std.) = ",
      parameters::format_value(parameters$Std_SD))
  }

  if ("Std_MAP" %in% names(parameters)) {
    text <- paste0(
      .add_comma(text),
      "MAP (std.) = ",
      parameters::format_value(parameters$Std_MAP)
    )
  }

  text
}









#' @keywords internal
.text_parameters_combine <- function(direction = "", significance = "", size = "", indices = ""){

  text <- direction
  text <- ifelse(significance != "" | size != "", paste0(text, " and can be considered as "), text)
  text <- paste0(text, size)

  text <- ifelse(significance != "" & size != "", paste0(text, " and ", significance),
                 ifelse(significance == "" & size != "", paste0(text, significance), text))

  text <- paste0(text, " (", indices, ").")
  text

}







#' @keywords internal
.add_comma <- function(text){
  ifelse(substring(text, nchar(text)-1) != ", ", paste0(text, ", "), text)
}