#' Miscellaneous reports
#'
#' Other convenient or totally useless reports.
#'
#' @inheritParams report
#'
#' @inherit report return seealso
#'
#' @examples
#' library(report)
#'
#' report_date()
#' summary(report_date())
#' report_story()
#' @return Objects of class [report_text()].
#' @export
report_date <- function(...) {
  date <- Sys.time()
  text <- format(date, "It's %A, %B %d of the year %Y, at %l%P %M and %S seconds")
  text_short <- format(date, "%d/%m/%y - %H:%M:%S")
  as.report_text(text, summary = text_short)
}



#' @rdname report_date
#' @export
report_story <- function(...) {
  text <-
    paste("Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not.",
          "It's not a story the Jedi would tell you. It's a Sith legend.",
          "Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force",
          "to influence the midichlorians to create life...",
          "He had such a knowledge of the dark side that he could even keep the ones he cared about from dying.",
          "The dark side of the Force is a pathway to many abilities some consider to be unnatural.",
          "He became so powerful...",
          "the only thing he was afraid of was losing his power, which eventually, of course, he did.",
          "Unfortunately, he taught his apprentice everything he knew, then his apprentice killed him in his sleep.",
          "Ironic. He could save others from death, but not himself.")

  text_short <- "So this is how liberty dies. With thunderous applause."

  as.report_text(text, summary = text_short)
}
