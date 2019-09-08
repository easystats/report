#' @keywords internal
.add_performance_table <- function(parameters, performance) {
  table <- parameters

  # Pretty names
  if (!is.null(attributes(parameters)$pretty_names)) {
    table$Parameter <- attributes(parameters)$pretty_names[parameters$Parameter]
  }

  # Skip row
  table[nrow(table) + 1, ] <- NA

  # Prettify performance names
  perf_names <- colnames(performance)
  perf_names[perf_names == "R2_adjusted"] <- "R2 (adj.)"
  perf_names[perf_names == "R2_Tjur"] <- "Tjur's R2"
  perf_names[perf_names == "BIC_adjusted"] <- "BIC (adj.)"


  # add performance
  perf_vertical <- data.frame(
    "Parameter" = perf_names,
    "Fit" = as.numeric(performance[1, ]),
    stringsAsFactors = FALSE
  )

  # Name parameter column
  name_parameter <- names(parameters)[names(parameters) %in% c("Parameter", "Link")][1]
  names(perf_vertical)[1] <- name_parameter


  table <- merge(table, perf_vertical, by = name_parameter, all = TRUE, sort = FALSE)
  table
}
