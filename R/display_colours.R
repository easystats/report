#' @keywords internal
.rstudio_with_ansi_support <- function() {
  if (Sys.getenv("RSTUDIO", "") == "") {
    return(FALSE)
  }
  if ((cols <- Sys.getenv("RSTUDIO_CONSOLE_COLOR", "")) !=
    "" && !is.na(as.numeric(cols))) {
    return(TRUE)
  }
  requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable() &&
    rstudioapi::hasFun("getConsoleHasColor")
}




#' @keywords internal
.supports_color <- function() {
  enabled <- getOption("crayon.enabled")
  if (!is.null(enabled)) {
    return(isTRUE(enabled))
  }
  if (.rstudio_with_ansi_support() && sink.number() == 0) {
    return(TRUE)
  }
  if (!isatty(stdout())) {
    return(FALSE)
  }
  if (Sys.info()["sysname"] == "windows") {
    if (Sys.getenv("ConEmuANSI") == "ON") {
      return(TRUE)
    }
    if (Sys.getenv("CMDER_ROOT") != "") {
      return(TRUE)
    }
    return(FALSE)
  }
  # Is this useful?
  # if (inside_emacs() && !is.na(emacs_version()[1]) && emacs_version()[1] >=
  #     23) {
  #   return(TRUE)
  # }
  if ("COLORTERM" %in% names(Sys.getenv())) {
    return(TRUE)
  }
  if (Sys.getenv("TERM") == "dumb") {
    return(FALSE)
  }
  grepl("^screen|^xterm|^vt100|color|ansi|cygwin|linux", Sys.getenv("TERM"),
    ignore.case = TRUE, perl = TRUE
  )
}



#' @keywords internal
.red <- function(x) {
  if (.supports_color()) {
    x[!is.na(x)] <- paste0("\033[31m", format_value_unless_integers(x[!is.na(x)], digits = 2), "\033[39m")
  }
  x
}

#' @keywords internal
.green <- function(x) {
  if (.supports_color()) {
    x[!is.na(x)] <- paste0("\033[32m", format_value_unless_integers(x[!is.na(x)], digits = 2), "\033[39m")
  }
  x
}

#' @keywords internal
.yellow <- function(x) {
  if (.supports_color()) {
    x[!is.na(x)] <- paste0("\033[33m", format_value_unless_integers(x[!is.na(x)], digits = 2), "\033[39m")
  }
  x
}

#' @keywords internal
.violet <- function(x) {
  if (.supports_color()) {
    x[!is.na(x)] <- paste0("\033[35m", format_value_unless_integers(x[!is.na(x)], digits = 2), "\033[39m")
  }
  x
}

#' @keywords internal
.cyan <- function(x) {
  if (.supports_color()) {
    x[!is.na(x)] <- paste0("\033[36m", format_value_unless_integers(x[!is.na(x)], digits = 2), "\033[39m")
  }
  x
}


#' @keywords internal
.colour <- function(x, colour = "red") {
  if (colour == "red") {
    return(.red(x))
  } else if (colour == "yellow") {
    return(.yellow(x))
  } else if (colour == "green") {
    return(.green(x))
  } else if (colour == "violet") {
    return(.violet(x))
  } else if (colour == "cyan") {
    return(.cyan(x))
  } else {
    warning(paste0("`color` ", colour, " not yet supported."))
  }
}





#' Colour a column (Exported for test purposes)
#' @keywords internal
.colour_columns <- function(x, names, colour = "red") {
  if (length(which(c(names) %in% names(x))) > 0) {
    x[, c(names)[c(names) %in% names(x)]] <- sapply(x[, c(names)[c(names) %in% names(x)]], .colour, colour = colour)
  }
  return(x)
}




#' Colour a column (Exported for test purposes)
#' @keywords internal
.colour_column_if <- function(x, name, condition = `>`, threshold = 0, colour_if = "green", colour_else = "red") {
  xnew <- x

  if (name %in% names(x)) {
    x_if <- which(condition(x[, name], threshold))
    x_else <- which(!condition(x[, name], threshold))

    if (!is.null(colour_if)) {
      xnew[, name][x_if] <- .colour(x[, name][x_if], colour_if)
    }
    if (!is.null(colour_else)) {
      xnew[, name][x_else] <- .colour(x[, name][x_else], colour_else)
    } else {
      xnew[, name][x_else] <- format_value_unless_integers(x[, name][x_else])
    }
  }

  xnew
}


#' Detect coloured cells
#' @keywords internal
.colour_detect <- function(x) {
  ansi_regex <- paste0(
    "(?:(?:\\x{001b}\\[)|\\x{009b})",
    "(?:(?:[0-9]{1,3})?(?:(?:;[0-9]{0,3})*)?[A-M|f-m])",
    "|\\x{001b}[A-M]"
  )
  color_cells <- grepl(ansi_regex, x, perl = TRUE)
  return(color_cells)
}



#' Remove ANSI color codes
#' @keywords internal
.colour_remove <- function(x) {
  ansi_regex <- paste0(
    "(?:(?:\\x{001b}\\[)|\\x{009b})",
    "(?:(?:[0-9]{1,3})?(?:(?:;[0-9]{0,3})*)?[A-M|f-m])",
    "|\\x{001b}[A-M]"
  )
  stripped_cells <- gsub(ansi_regex, "", x, perl = TRUE)

  return(stripped_cells)
}
