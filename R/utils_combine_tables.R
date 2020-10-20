#' @keywords internal
.combine_tables_effectsize <- function(parameters, effsize) {

  effsize_table <- attributes(effsize)$table
  table <- merge(parameters, effsize_table, all = TRUE)
  table <- table[order(
    match(table$Parameter, parameters$Parameter)), ]
  row.names(table) <- NULL

  # Prepare output
  class(table) <- class(parameters)
  attributes(table) <- utils::modifyList(attributes(parameters), attributes(table))

  table
}







#' @importFrom utils modifyList
#' @keywords internal
.combine_tables_performance <- function(parameters, performance) {
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
  perf_names[perf_names == "R2_conditional"] <- "R2 (conditional)"
  perf_names[perf_names == "R2_marginal"] <- "R2 (marginal)"


  # add performance
  perf_vertical <- data.frame(
    "Parameter" = perf_names,
    "Fit" = as.numeric(performance[1, ]),
    stringsAsFactors = FALSE
  )

  # remove missing values
  perf_vertical <- perf_vertical[!is.na(perf_vertical$Fit), ]

  # Name parameter column
  name_parameter <- names(parameters)[names(parameters) %in% c("Parameter", "Link")][1]
  names(perf_vertical)[1] <- name_parameter

  # Merge
  table <- merge(table, perf_vertical, by = name_parameter, all = TRUE, sort = FALSE)

  # Prepare output
  class(table) <- class(parameters)
  attributes(table) <- utils::modifyList(attributes(parameters), attributes(table))

  # Add pretty names
  pretty_names <- table$Parameter
  pretty_names[is.na(pretty_names)] <- ""
  names(pretty_names) <- table$Parameter
  attr(table, "pretty_names") <- pretty_names

  table
}
