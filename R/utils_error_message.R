#' @keywords internal
.error_message <- function(x, fun="report()"){

  paste0("Oops, objects of class [",
         paste(class(x), collapse = ", "),
         "] are not supported (yet) by ",
         fun,
         " :(\n\nWant to help? Check out https://easystats.github.io/report/articles/new_models.html")
}