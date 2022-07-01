#' Reporting the participant data
#'
#' A helper function to help you format the participants data (age, sex, ...) in
#' the participants section.
#'
#' @param data A data frame.
#' @param age The name of the column containing the age of the participant.
#' @param sex The name of the column containing the sex of the participant. The
#'   classes should be one of `c("Male", "M", "Female", "F")`. Note that
#'   you can specify other characters here as well (e.g., `"Intersex"`), but
#'   the function will group all individuals in those groups as `"Other"`.
#' @param gender The name of the column containing the gender of the
#'   classes should be one of `c("Man", "M", "Male", Woman", "W", F",
#'   "Female", Non-Binary", "N")`. Note that you can specify other characters
#'   here as well (e.g., `"Gender Fluid"`), but the function will group all
#'   individuals in those groups as `"Non-Binary"`.
#' @param education The name of the column containing education information.
#' @param country The name of the column containing country information.
#' @param threshold Percentage after which to combine, e.g., countries (default is 10%, so countries that represent less than 10% will be combined in the "other" category).
#' @param participants The name of the participants' identifier column (for
#'   instance in the case of repeated measures).
#' @param group A character vector indicating the name(s) of the column(s) used
#'   for stratified description.
#' @param spell_n Logical, fully spell the sample size (`"Three participants"`
#'   instead of `"3 participants"`).
#' @inheritParams report.numeric
#'
#' @return A character vector with description of the "participants", based on
#'   the information provided in `data`.
#'
#' @examples
#' library(report)
#' data <- data.frame(
#'   "Age" = c(22, 23, 54, 21, 8, 42),
#'   "Sex" = c("Intersex", "F", "M", "M", "M", "F"),
#'   "Gender" = c("N", "W", "W", "M", "M", "M")
#' )
#'
#' report_participants(data, age = "Age", sex = "Sex")
#'
#' # Years of education (relative to high school graduation)
#' data$Education <- c(0, 8, -3, -5, 3, 5)
#' report_participants(data,
#'   age = "Age", sex = "Sex", gender = "Gender",
#'   education = "Education"
#' )
#'
#' # Education as factor
#' data$Education2 <- c(
#'   "Bachelor", "PhD", "Highschool",
#'   "Highschool", "Bachelor", "Bachelor"
#' )
#' report_participants(data, age = "Age", sex = "Sex", gender = "Gender", education = "Education2")
#' # Country
#' data <- data.frame(
#'   "Age" = c(22, 23, 54, 21, 8, 42, 18, 32, 24, 27, 45),
#'   "Sex" = c("Intersex", "F", "F", "M", "M", "M", "F", "F", "F", "F", "F"),
#'   "Gender" = c("F", "F", "F", "M", "M", "M", "F", "F", "F", "F", "F"),
#'   "Country" = c("USA", NA, "Canada", "Canada", "India", "Germany",
#'   "USA", "USA", "USA", "USA", "Canada"))
#' report_participants(data)
#'
#' # Country, control presentation treshold
#' report_participants(data, threshold = 5)
#'
#' # Repeated measures data
#' data <- data.frame(
#'   "Age" = c(22, 22, 54, 54, 8, 8),
#'   "Sex" = c("I", "F", "M", "M", "F", "F"),
#'   "Gender" = c("N", "W", "W", "M", "M", "M"),
#'   "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3")
#' )
#'
#' report_participants(data, age = "Age", sex = "Sex", gender = "Gender", participants = "Participant")
#'
#' # Grouped data
#' data <- data.frame(
#'   "Age" = c(22, 22, 54, 54, 8, 8, 42, 42),
#'   "Sex" = c("I", "I", "M", "M", "F", "F", "F", "F"),
#'   "Gender" = c("N", "N", "W", "M", "M", "M", "Non-Binary", "Non-Binary"),
#'   "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3", "s4", "s4"),
#'   "Condition" = c("A", "A", "A", "A", "B", "B", "B", "B")
#' )
#'
#' report_participants(data,
#'   age = "Age",
#'   sex = "Sex",
#'   gender = "Gender",
#'   participants = "Participant",
#'   group = "Condition"
#' )
#'
#' # Spell sample size
#' paste(
#'   report_participants(data, participants = "Participant", spell_n = TRUE),
#'   "were recruited in the study by means of torture and coercion."
#' )
#' @export
report_participants <- function(data,
                                age = NULL,
                                sex = NULL,
                                gender = NULL,
                                education = NULL,
                                country = NULL,
                                participants = NULL,
                                group = NULL,
                                spell_n = FALSE,
                                digits = 1,
                                threshold = 10,
                                ...) {

  # find age variable automatically
  if (is.null(age)) {
    age <- .find_age_in_data(data)
  }

  # find sex variable automatically
  if (is.null(sex)) {
    sex <- .find_sex_in_data(data)
  }

  # find gender variable automatically
  if (is.null(gender)) {
    gender <- .find_gender_in_data(data)
  }

  # find education variable automatically
  if (is.null(education)) {
    education <- .find_education_in_data(data)
  }

  # find country variable automatically
  if (is.null(country)) {
    country <- .find_country_in_data(data)
  }

  if (!is.null(group)) {
    text <- c()
    for (i in split(data, data[group])) {
      current_text <- .report_participants(
        i,
        age = age,
        sex = sex,
        education = education,
        country = country,
        participants = participants,
        spell_n = spell_n,
        digits = digits,
        threshold = threshold
      )

      pre_text <- paste0("the '", paste0(names(i[group]), " - ", as.character(sapply(i[group], unique)), collapse = " and "), "' group: ")

      text <- c(text, paste0(pre_text, current_text))
    }
    text <- paste("For", text_concatenate(text, sep = ", for ", last = " and for "))
  } else {
    text <- .report_participants(
      data,
      age = age,
      sex = sex,
      gender = gender,
      education = education,
      country = country,
      participants = participants,
      spell_n = spell_n,
      digits = digits,
      threshold = threshold,
      ...
    )
  }
  text
}



#' @keywords internal
.report_participants <- function(data,
                                 age = "Age",
                                 sex = "Sex",
                                 gender = "Gender",
                                 education = "Education",
                                 country = "Country",
                                 participants = NULL,
                                 spell_n = FALSE,
                                 digits = 1,
                                 threshold = 10,
                                 ...) {
  # Sanity checks
  if (is.null(age) | !age %in% names(data)) {
    data$Age <- NA
    age <- "Age"
  }
  if (is.null(sex) | !sex %in% names(data)) {
    data$Sex <- NA
    sex <- "Sex"
  }
  if (is.null(gender) | !gender %in% names(data)) {
    data$Gender <- NA
    gender <- "Gender"
  }
  if (is.null(education) | !education %in% names(data)) {
    data$Education <- NA
    education <- "Education"
  }
  if (is.null(country) | !country %in% names(data)) {
    data$country <- NA
    country <- "Country"
  }

  # Grouped data
  if (!is.null(participants)) {
    data <- data.frame(
      "Age" = stats::aggregate(data[[age]], by = list(data[[participants]]), FUN = mean)[[2]],
      "Sex" = stats::aggregate(data[[sex]], by = list(data[[participants]]), FUN = utils::head, n = 1)[[2]],
      "Gender" = stats::aggregate(data[[gender]], by = list(data[[participants]]), FUN = utils::head, n = 1)[[2]],
      "Education" = stats::aggregate(data[[education]], by = list(data[[participants]]), FUN = utils::head, n = 1)[[2]],
      "Country" = stats::aggregate(data[[country]], by = list(data[[participants]]), FUN = utils::head, n = 1)[[2]]
    )
    age <- "Age"
    sex <- "Sex"
    gender <- "Gender"
    education <- "Education"
    country <- "Country"
  }

  if (spell_n) {
    size <- tools::toTitleCase(insight::format_number(nrow(data)))
  } else {
    size <- nrow(data)
  }

  # Create text
  if (all(is.na(data[[age]]))) {
    text_age <- ""
  } else {
    text_age <- summary(
      report_statistics(
        data[[age]],
        n = FALSE,
        centrality = "mean",
        missing_percentage = TRUE,
        digits = digits,
        ...
      )
    )
    text_age <- sub("Mean =", "Mean age =", text_age, fixed = TRUE)
  }


  text_sex <- if (all(is.na(data[[sex]]))) {
    ""
  } else if (insight::format_value(length(data[[sex]][tolower(data[[sex]]) %in% c("")]) / nrow(data) * 100) == "0.00") {
    paste0(
      "Sex: ",
      insight::format_value(length(data[[sex]][tolower(data[[sex]]) %in% c("female", "f")]) / nrow(data) * 100, digits = digits),
      "% females, ",
      insight::format_value(length(data[[sex]][tolower(data[[sex]]) %in% c("male", "m")]) / nrow(data) * 100, digits = digits),
      "% males, ",
      insight::format_value(100 - length(data[[sex]][tolower(data[[sex]]) %in% c("male", "m", "female", "f")]) / nrow(data) * 100, digits = digits),
      "% other"
    )
  } else {
    paste0(
      "Sex: ",
      insight::format_value(length(data[[sex]][tolower(data[[sex]]) %in% c("female", "f")]) / nrow(data) * 100, digits = digits),
      "% females, ",
      insight::format_value(length(data[[sex]][tolower(data[[sex]]) %in% c("male", "m")]) / nrow(data) * 100, digits = digits),
      "% males, ",
      insight::format_value(100 - length(data[[sex]][tolower(data[[sex]]) %in% c("male", "m", "female", "f")]) / nrow(data) * 100, digits = digits),
      "% other, ",
      insight::format_value(length(data[[sex]][tolower(data[[sex]]) %in% c(NA)]) / nrow(data) * 100),
      "% missing"
    )
  }

  text_gender <- if (all(is.na(data[[gender]]))) {
    ""
  } else if (insight::format_value(length(data[[gender]][tolower(data[[gender]]) %in% c("")]) / nrow(data) * 100) == "0.00") {
    paste0(
      "Gender: ",
      insight::format_value(length(data[[gender]][tolower(data[[gender]]) %in% c("woman", "w", "f", "female")]) / nrow(data) * 100, digits = digits),
      "% women, ",
      insight::format_value(length(data[[gender]][tolower(data[[gender]]) %in% c("man", "m", "male")]) / nrow(data) * 100, digits = digits),
      "% men, ",
      insight::format_value(100 - length(data[[gender]][tolower(data[[gender]]) %in% c("woman", "w", "f", "female", "man", "m", "male")]) / nrow(data) * 100),
      "% non-binary"
    )
  } else {
    paste0(
      "Gender: ",
      insight::format_value(length(data[[gender]][tolower(data[[gender]]) %in% c("woman", "w", "f", "female")]) / nrow(data) * 100, digits = digits),
      "% women, ",
      insight::format_value(length(data[[gender]][tolower(data[[gender]]) %in% c("man", "m", "male")]) / nrow(data) * 100, digits = digits),
      "% men, ",
      insight::format_value(100 - length(data[[gender]][tolower(data[[gender]]) %in% c("woman", "w", "f", "female", "man", "m", "male")]) / nrow(data) * 100),
      "% non-binary, ",
      insight::format_value(length(data[[gender]][tolower(data[[gender]]) %in% c(NA)]) / nrow(data) * 100),
      "% missing"
    )
  }

  if (all(is.na(data[[education]]))) {
    text_education <- ""
  } else {
    if (is.numeric(data[[education]])) {
      text_education <- summary(
        report_statistics(
          data[[education]],
          n = FALSE,
          centrality = "mean",
          missing_percentage = NULL,
          digits = digits,
          ...
        )
      )

      text_education <- sub("Mean =", "Mean education =", text_education, fixed = TRUE)
    } else {
      txt <- summary(report_statistics(
        as.factor(data[[education]]),
        levels_percentage = TRUE,
        digits = digits,
        ...
      ))

      text_education <- paste0("Education: ", txt)
    }
  }

  text_country <- if (all(is.na(data[[country]]))) {
    ""
  } else {
    country.table <- as.data.frame(datawizard::data_tabulate(data[[country]]))[c(2, 4)]
    names(country.table) <- c("Country", "Percentage")
    country.table <- country.table[order(-country.table$Percentage),]
    upper <- country.table[which(country.table$Percentage >= threshold),]
    lower <- country.table[which(country.table$Percentage < threshold),]
    if(nrow(lower) > 0) {
      lower.sum <- data.frame(Country = "other", Percentage = sum(lower$Percentage))
      combined <- rbind(upper, lower.sum)
    } else {
      combined <- upper
    }
    combined$Percentage <- insight::format_value(combined$Percentage)
    country_string <- paste0(combined$Percentage, "% ", combined$Country, collapse = ", ")
    text_country <- paste("Country:", country_string)
  }

  paste0(
    size,
    " participants (",
    ifelse(text_age == "", "", text_age),

    ifelse(text_sex == "", "", paste0(ifelse(
      text_age == "", "", "; "), text_sex)),

    ifelse(text_gender == "", "", paste0(ifelse(
      text_age == "" & text_sex == "", "", "; "), text_gender)),

    ifelse(text_education == "", "", paste0(ifelse(
      text_age == "" & text_sex == "" & text_gender == "", "", "; "), text_education)),

    ifelse(text_country == "", "", paste0(ifelse(
      text_education == "" & text_age == "" & text_sex == "" &
        text_gender == "", "", "; "), text_country)),
    ")."
  )
}

#' @keywords internal
.find_age_in_data <- function(data) {
  if ("Age" %in% colnames(data)) {
    "Age"
  } else if ("age" %in% colnames(data)) {
    "age"
  } else if (any(grepl("^Age", colnames(data)))) {
    grep("^Age", colnames(data), value = TRUE)[1]
  } else if (any(grepl("^age", colnames(data)))) {
    grep("^age", colnames(data), value = TRUE)[1]
  } else {
    ""
  }
}

#' @keywords internal
.find_sex_in_data <- function(data) {
  if ("Sex" %in% colnames(data)) {
    "Sex"
  } else if ("sex" %in% colnames(data)) {
    "sex"
  } else if (any(grepl("^Sex", colnames(data)))) {
    grep("^Sex", colnames(data), value = TRUE)[1]
  } else if (any(grepl("^sex", colnames(data)))) {
    grep("^sex", colnames(data), value = TRUE)[1]
  } else {
    ""
  }
}

#' @keywords internal
.find_gender_in_data <- function(data) {
  if ("Gender" %in% colnames(data)) {
    "Gender"
  } else if ("gender" %in% colnames(data)) {
    "gender"
  } else if (any(grepl("^Gender", colnames(data)))) {
    grep("^Gender", colnames(data), value = TRUE)[1]
  } else if (any(grepl("^gender", colnames(data)))) {
    grep("^gender", colnames(data), value = TRUE)[1]
  } else {
    ""
  }
}

#' @keywords internal
.find_education_in_data <- function(data) {
  if ("Education" %in% colnames(data)) {
    "Education"
  } else if ("education" %in% colnames(data)) {
    "education"
  } else if (any(grepl("^Education", colnames(data)))) {
    grep("^Education", colnames(data), value = TRUE)[1]
  } else if (any(grepl("^education", colnames(data)))) {
    grep("^education", colnames(data), value = TRUE)[1]
  } else if ("isced" %in% colnames(data)) {
    "isced"
  } else if (any(grepl("^isced", colnames(data)))) {
    grep("^isced", colnames(data), value = TRUE)[1]
  } else {
    ""
  }
}

#' @keywords internal
.find_country_in_data <- function(data) {
  if ("Country" %in% colnames(data)) {
    "Country"
  } else if ("country" %in% colnames(data)) {
    "country"
  } else if (any(grepl("^Country", colnames(data)))) {
    grep("^Country", colnames(data), value = TRUE)[1]
  } else if (any(grepl("^country", colnames(data)))) {
    grep("^country", colnames(data), value = TRUE)[1]
  } else {
    ""
  }
}