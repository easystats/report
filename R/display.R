#' Pretty Printing
#'
#' @keywords internal
.display <- function(x) {
  UseMethod(".display")
}



#' Dataframe Pretty Printing
#'
#' @method .display data.frame
#' @keywords internal
.display.data.frame <- function(x, cat = TRUE, sep = " | ") {
  ansi_regex <- paste0(
    "(?:(?:\\x{001b}\\[)|\\x{009b})",
    "(?:(?:[0-9]{1,3})?(?:(?:;[0-9]{0,3})*)?[A-M|f-m])",
    "|\\x{001b}[A-M]"
  )


  df <- dplyr::mutate_if(x, is.numeric, format_value, digits = 2)
  df <- as.data.frame(sapply(df, as.character), stringsAsFactors = FALSE)

  temp <- df
  if (cat) {
    # Add colnames as row
    df[1, ] <- as.character(colnames(df))
    df <- rbind(df[1, ], temp)
  }


  # Align
  name_width <- max(sapply(names(df), nchar))
  names(df) <- format(names(df), width = name_width, justify = "centre")
  df <- format(df, width = name_width, justify = "right")

  if (cat) {
    rows <- c()
    for (i in 1:nrow(df)) {
      row <- df[i, ]

      # Detect if colour
      color_cells <- grepl(ansi_regex, row, perl = TRUE)
      stripped_cells <- gsub(ansi_regex, "", row, perl = TRUE)
      names(stripped_cells) <- names(row)
      if (i > 1) {
        for (j in names(row[color_cells])) {
          whitespaces <- as.numeric(nchar(df[1, ][j]) - nchar(stripped_cells[j]))
          row[color_cells][j] <- paste0(paste0(rep_len(" ", whitespaces), collapse = ""), row[color_cells][j])
        }
      }

      # Paste
      row <- paste0(row, collapse = sep)
      rows <- c(rows, row)
      if (i == 1) {
        rows <- c(rows, paste0(rep_len("-", nchar(row)), collapse = ""))
      }
    }


    cat(rows, sep = "\n")
  } else {
    return(df)
  }
}
