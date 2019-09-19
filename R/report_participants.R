#' Reporting the participant data
#'
#' A helper function to help you format the participants data (age, sex, ...) in the participants section.
#'
#' @param data A dataframe.
#' @param age The name of the column containing the age.
#' @param sex The name of the column containing the sex. Note that classes should be some of c("Male", "M", "Female", "F").
#' @param participant The name of the participants' identifier column (for instance in the case of repeated measures).
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
#' # Grouped data
#' data <- data.frame("Age" = c(22, 22, 54, 54, 8, 8),
#'                    "Sex" = c("F", "F", "M", "M", "F", "F"),
#'                    "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3"))
#'
#' report_participants(data, age = "Age", sex = "Sex", participant = "Participant")
#'
#' # Spell sample size
#' paste(report_participants(data, participant = "Participant", spell_n = TRUE),
#'       "were recruited in the study by means of torture and coercion.")
#'
#' @importFrom stats aggregate
#' @export
report_participants <- function(data, age = "Age", sex = "Sex", participant = NULL, spell_n = FALSE, ...){

  # Sanity checks
  if(is.null(age)){
    data$Age <- NA
    age <- "Age"
  }
  if(is.null(sex)){
    data$Sex <- NA
    sex <- "Sex"
  }

  # Grouped data
  if(!is.null(participant)){
    data <- data.frame(
      "Age" = stats::aggregate(data[[age]], by=list(data[[participant]]), FUN=mean)[[2]],
      "Sex" = stats::aggregate(data[[sex]], by=list(data[[participant]]), FUN=head, n = 1)[[2]]
    )
    age <- "Age"
    sex = "Sex"
  }

  if(spell_n){
    size <- tools::toTitleCase(parameters::format_number(nrow(data)))
  } else{
    size <- nrow(data)
  }

  text <- paste0(size,
         " participants (Mean age = ",
         insight::format_value(mean(data[[age]], na.rm = TRUE)),
         ", ",
         report(data[[age]], centrality = FALSE, missing_percentage = NULL, ...)$text,
         ", ",
         insight::format_value(length(data[[sex]][tolower(data[[sex]]) %in% c("female", "f")])/nrow(data)*100),
         "% females)")

  text
}