#' Pretty Printing
#'
#' @keywords internal
.display <- function(x) {
  UseMethod(".display")
}





#' Dataframe Pretty Printing
#'
#' @examples
#' \dontrun{
#' x <- model_parameters(lm(Sepal.Length ~ Species * Sepal.Width, data = iris))
#' x <- .colour_column_if(x,
#'   name = "CI_low", condition = `<`, threshold = 0,
#'   colour_if = "red", colour_else = "green"
#' )
#' x <- .colour_column_if(x,
#'   name = "p", condition = `<`, threshold = 0.05,
#'   colour_if = "yellow", colour_else = NULL
#' )
#' .display.data.frame(x)
#' }
#' @method .display data.frame
#' @keywords internal
.display.data.frame <- function(x, sep = " | ") {
  df <- as.data.frame(sapply(x, format_value, digits = 2), stringsAsFactors = FALSE)

  # Add colnames as row
  df <- rbind(Parameter = colnames(df), df)

  # Extract color info
  coloured_cells_index <- sapply(df, .colour_detect)
  coloured_cells <- as.matrix(df)[coloured_cells_index]

  # Create uncouloured
  uncoloured <- as.data.frame(sapply(df, .colour_remove), stringsAsFactors = FALSE)


  # Align
  aligned <- format(uncoloured, justify = "right")

  # Centre first row
  first_row <- as.character(aligned[1, ])
  for (i in 1:length(first_row)) {
    aligned[1, i] <- format(trimws(first_row[i]), width = nchar(first_row[i]), justify = "right")
  }

  # Replace coloured
  final <- as.matrix(aligned)
  final[coloured_cells_index] <- coloured_cells
  # final[coloured_cells_index] <- paste0(" ", coloured_cells)

  # Transform to character
  rows <- c()
  for (row in 1:nrow(final)) {
    final_row <- paste0(final[row, ], collapse = sep)
    rows <- paste0(rows, final_row, sep = "\n")

    if (row == 1) {
      rows <- paste0(rows, paste0(rep_len("-", nchar(final_row)), collapse = ""), sep = "\n")
    }
  }
  cat(rows, sep = "\n")
}