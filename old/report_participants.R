#' Reporting the participant data
#'
#' A helper function to help you format the participants data (age, sex, ...) in the participants section.
#'
#' @param data A dataframe.
#' @param age The name of the column containing the age.
#' @param sex The name of the column containing the sex. Note that classes should be some of c("Male", "M", "Female", "F").
#' @param participants The name of the participants' identifier column (for instance in the case of repeated measures).
#' @param group A character vector indicating the name(s) of the column(s) used for stratified description.
#' @param spell_n Fully spell the sample size ("Three participants" instead of "3 participants").
#' @inheritParams report.numeric
#'
#'
#' @examples
#' library(report)
#' data <- data.frame("Age" = c(22, 23, 54, 21, 8, 42),
#'                    "Sex" = c("F", "F", "M", "M", "M", "F"))
#'
#' report_participants(data, age = "Age", sex = "Sex")
#'
#' # Years of education (relative to high school graduation)
#' data$Education <- c(0, 8, -3, -5, 3, 5)
#' report_participants(data, age = "Age", sex = "Sex", education = "Education")
#'
#' # Education as factor
#' data$Education2 <- c("Bachelor", "PhD", "Highschool",
#'                      "Highschool", "Bachelor", "Bachelor")
#' report_participants(data, age = "Age", sex = "Sex", education = "Education2")
#'
#'
#' # Repeated measures data
#' data <- data.frame("Age" = c(22, 22, 54, 54, 8, 8),
#'                    "Sex" = c("F", "F", "M", "M", "F", "F"),
#'                    "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3"))
#'
#' report_participants(data, age = "Age", sex = "Sex", participants = "Participant")
#'
#' # Grouped data
#' data <- data.frame("Age" = c(22, 22, 54, 54, 8, 8, 42, 42),
#'                    "Sex" = c("F", "F", "M", "M", "F", "F", "M", "M"),
#'                    "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3", "s4", "s4"),
#'                    "Condition" = c("A", "A", "A", "A", "B", "B", "B", "B"))
#'
#' report_participants(data, age = "Age",
#'                           sex = "Sex",
#'                           participants = "Participant",
#'                           group = "Condition")
#'
#' # Spell sample size
#' paste(report_participants(data, participants = "Participant", spell_n = TRUE),
#'       "were recruited in the study by means of torture and coercion.")
#'
#' @importFrom stats aggregate
#' @export
report_participants <- function(data, age = "Age", sex = "Sex", education = "Education", participants = NULL, group = NULL, spell_n = FALSE, ...){

  if (!is.null(group)) {
    text <- c()
    for (i in split(data, data[group])) {
      current_text <- .report_participant(i, age = age, sex = sex, education = education, participants = participants, spell_n = spell_n)
      pre_text <- paste0("the '", paste0(names(i[group]), " - ", as.character(sapply(i[group], unique)), collapse = " and "), "' group: ")
      text <- c(text, paste0(pre_text, current_text))
    }
    text <- paste("For", format_text(text, sep = ", for ", last = " and for "))
  } else {
    text <- .report_participant(data, age = age, sex = sex, education = education, participants = participants, spell_n = spell_n, ...)
  }
  text
}




#' @keywords internal
.report_participant <- function(data, age = "Age", sex = "Sex", education = "Education", participants = NULL, spell_n = FALSE, ...){
  # Sanity checks
  if(is.null(age) | !age %in% names(data)){
    data$Age <- NA
    age <- "Age"
  }
  if(is.null(sex) | !sex %in% names(data)){
    data$Sex <- NA
    sex <- "Sex"
  }
  if(is.null(education) | !education %in% names(data)){
    data$Education <- NA
    education <- "Education"
  }

  # Grouped data
  if(!is.null(participants)){
    data <- data.frame(
      "Age" = stats::aggregate(data[[age]], by=list(data[[participants]]), FUN=mean)[[2]],
      "Sex" = stats::aggregate(data[[sex]], by=list(data[[participants]]), FUN=head, n = 1)[[2]],
      "Education" = stats::aggregate(data[[education]], by=list(data[[participants]]), FUN=head, n = 1)[[2]]
    )
    age <- "Age"
    sex = "Sex"
    education = "Education"
  }

  if(spell_n){
    size <- tools::toTitleCase(parameters::format_number(nrow(data)))
  } else{
    size <- nrow(data)
  }

  # Create text
  text_age <- if(all(is.na(data[[age]]))){
    ""
  } else{
    paste0("Mean age = ",
           insight::format_value(mean(data[[age]], na.rm = TRUE)),
           ", ",
           report(data[[age]], centrality = FALSE, missing_percentage = NULL, ...)$text)
  }

  text_sex <- if(all(is.na(data[[sex]]))){
    ""
  } else{
    paste0(insight::format_value(length(data[[sex]][tolower(data[[sex]]) %in% c("female", "f")])/nrow(data)*100),
    "% females")
  }

  text_education <- if(all(is.na(data[[education]]))){
    ""
  } else{
    if(is.numeric(data[[education]])){
      paste0("Mean education = ",
             insight::format_value(mean(data[[education]], na.rm = TRUE)),
             ", ",
             report(data[[education]], centrality = FALSE, missing_percentage = NULL, ...)$text)
    } else{
      report(as.factor(data[[education]]), levels_percentage = TRUE, ...)$text
    }
  }


  paste0(size,
         " participants (",
         ifelse(text_age == "", "", text_age),
         ifelse(text_sex == "", "", paste0(ifelse(text_age == "", "", "; "), text_sex)),
         ifelse(text_education == "", "", paste0(ifelse(text_age == "" & text_sex == "", "", "; "), text_education)),
         ")"
         )
}