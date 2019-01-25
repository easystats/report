#' p-values Formatting
#'
#' @param p value or vector of p-values.
#' @param stars Add significance stars.
#' @param stars_only Return only significance stars.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @examples
#' format_p(.02)
#' @importFrom stringr str_remove_all
#' @export
format_p <- function(p, stars = FALSE, stars_only = FALSE) {
  p <- ifelse(p < 0.001, "< .001***",
    ifelse(p < 0.01, "< .01**",
      ifelse(p < 0.05, "< .05*",
        ifelse(p < 0.1, paste0("= ", format_value(p, 2)),
          "> .1"
        )
      )
    )
  )

  if (stars_only == TRUE) {
    p <- stringr::str_remove_all(p, "[^\\*]")
  } else {
    if (stars == FALSE) {
      p <- stringr::str_remove_all(p, "\\*")
    }
  }

  return(p)
}
