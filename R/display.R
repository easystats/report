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
#' x <- model_parameters(lm(Sepal.Length ~ Species * Sepal.Width, data=iris))
#' x <- .colour_column_if(x, name="CI_low", condition = `<`, threshold = 0,
#'                        colour_if = "red", colour_else = "green")
#' x <- .colour_column_if(x, name="p", condition = `<`, threshold = 0.05,
#'                        colour_if = "yellow", colour_else = NULL)
#' .display.data.frame(x)
#' }
#' @method .display data.frame
#' @keywords internal
.display.data.frame <- function(x, sep = " | ") {
  df <- dplyr::mutate_if(x, is.numeric, format_value, digits = 2)
  df <- as.data.frame(sapply(df, as.character), stringsAsFactors = FALSE)

  # Add colnames as row
  temp <- df
  df[1, ] <- as.character(colnames(df))
  df <- rbind(df[1, ], temp)

  # Extract color info
  coloured_cells_index <- sapply(df, .colour_detect)
  coloured_cells <- as.matrix(df)[coloured_cells_index]

  # Create uncouloured
  uncoloured <- as.data.frame(sapply(df, .colour_remove), stringsAsFactors = FALSE)


  # Align
  aligned <- format(uncoloured, justify = "right")

  # Centre first row
  first_row <- as.character(aligned[1, ])
  for(i in 1:length(first_row)){
    aligned[1, i] <- format(stringr::str_trim(first_row[i]), width = nchar(first_row[i]), justify="centre")
  }

  # Replace coloured
  final <- as.matrix(aligned)
  final[coloured_cells_index] <- coloured_cells
  # final[coloured_cells_index] <- paste0(" ", coloured_cells)

  # Transform to character
  rows <- c()
  for(row in 1:nrow(final)){
    final_row <- paste0(final[row, ], collapse=sep)
    rows <- paste0(rows, final_row, sep="\n")

    if (row == 1) {
      rows <- paste0(rows, paste0(rep_len("-", nchar(final_row)), collapse = ""), sep="\n")
    }
  }
  cat(rows, sep = "\n")
}


#' #' Dataframe Pretty Printing
#' #'
#' #' @examples
#' #' x <- model_parameters(lm(Sepal.Length ~ Species * Sepal.Width, data=iris))
#' #' x <- .colour_column_if(x, "beta", condition = `>`, threshold = 0, colour_if = "green", colour_else = "red")
#' #' .display.data.frame(x)
#' #' @method .display data.frame
#' #' @keywords internal
#' .display.data.frame <- function(x, cat = TRUE, sep = " | ") {
#'   ansi_regex <- paste0(
#'     "(?:(?:\\x{001b}\\[)|\\x{009b})",
#'     "(?:(?:[0-9]{1,3})?(?:(?:;[0-9]{0,3})*)?[A-M|f-m])",
#'     "|\\x{001b}[A-M]"
#'   )
#'
#'
#'   df <- dplyr::mutate_if(x, is.numeric, format_value, digits = 2)
#'   df <- as.data.frame(sapply(df, as.character), stringsAsFactors = FALSE)
#'
#'   temp <- df
#'   if (cat) {
#'     # Add colnames as row
#'     df[1, ] <- as.character(colnames(df))
#'     df <- rbind(df[1, ], temp)
#'   }
#'
#'
#'   # Align
#'   name_width <- max(sapply(names(df), nchar))
#'   names(df) <- format(names(df), width = name_width, justify = "centre")
#'   df <- format(df, width = name_width, justify = "right")
#'
#'   if (cat) {
#'     rows <- c()
#'     for (i in 1:nrow(df)) {
#'       row <- df[i, ]
#'
#'       # Detect if colour
#'       color_cells <- grepl(ansi_regex, row, perl = TRUE)
#'       stripped_cells <- gsub(ansi_regex, "", row, perl = TRUE)
#'       names(stripped_cells) <- names(row)
#'       if (i > 1) {
#'         for (j in names(row[color_cells])) {
#'           whitespaces <- as.numeric(nchar(df[1, ][j]) - nchar(stripped_cells[j]))
#'           row[color_cells][j] <- paste0(paste0(rep_len(" ", whitespaces), collapse = ""), row[color_cells][j])
#'         }
#'       }
#'
#'       # Paste
#'       row <- paste0(row, collapse = sep)
#'       rows <- c(rows, row)
#'       if (i == 1) {
#'         rows <- c(rows, paste0(rep_len("-", nchar(row)), collapse = ""))
#'       }
#'     }
#'
#'
#'     cat(rows, sep = "\n")
#'   } else {
#'     return(df)
#'   }
#' }
