# call this function to check arguments. "select" is the argument where user
# specified column names. "arg_name" is the name of that argument, can be NULL
.check_spelling <- function(data, select) {
  wrong_arg <- paste0("specified in `", deparse(substitute(select)), "` ")
  if (!is.null(select) && isTRUE(nzchar(select)) && !all(select %in% colnames(data))) {
    not_found <- select[!select %in% colnames(data)]
    insight::format_error(
      paste0(
        sprintf("The following column(s) %sdon't exist in the dataset: ", wrong_arg),
        datawizard::text_concatenate(not_found), "."
      ),
      .misspelled_string(colnames(data), not_found, "Possibly misspelled?")
    )
  }
}


#' Fuzzy grep, matches pattern that are close, but not identical
#' @examples
#' colnames(iris)
#' p <- sprintf("(%s){~%i}", "Spela", 2)
#' grep(pattern = p, x = colnames(iris), ignore.case = FALSE)
#' @keywords internal
#' @noRd
.fuzzy_grep <- function(x, pattern, precision = NULL) {
  if (is.null(precision)) {
    precision <- round(nchar(pattern) / 3)
  }
  if (precision > nchar(pattern)) {
    return(NULL)
  }
  p <- sprintf("(%s){~%i}", pattern, precision)
  grep(pattern = p, x = x, ignore.case = FALSE)
}


#' create a message string to tell user about matches that could possibly
#' be the string they were looking for
#'
#' @keywords internal
#' @noRd
.misspelled_string <- function(source, searchterm, default_message = NULL) {
  if (is.null(searchterm) || length(searchterm) < 1) {
    return(default_message)
  }
  # used for many matches
  more_found <- ""
  # init default
  msg <- ""
  # guess the misspelled string
  possible_strings <- unlist(lapply(searchterm, function(s) {
    source[.fuzzy_grep(source, s)] # nolint
  }), use.names = FALSE)
  if (length(possible_strings)) {
    msg <- "Did you mean "
    if (length(possible_strings) > 1) {
      # make sure we don't print dozens of alternatives for larger data frames
      if (length(possible_strings) > 5) {
        more_found <- sprintf(
          " We even found %i more possible matches, not shown here.",
          length(possible_strings) - 5
        )
        possible_strings <- possible_strings[1:5]
      }
      msg <- paste0(msg, "one of ", datawizard::text_concatenate(possible_strings, enclose = "\"", last = " or "))
    } else {
      msg <- paste0(msg, "\"", possible_strings, "\"")
    }
    msg <- paste0(msg, "?", more_found)
  } else {
    msg <- default_message
  }
  # no double white space
  insight::trim_ws(msg)
}
