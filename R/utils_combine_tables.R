#' @keywords internal
.combine_tables_effectsize <- function(parameters, effsize) {
  effsize_table <- attributes(effsize)$table
  combined_table <- merge(parameters, effsize_table, sort = FALSE, all = TRUE)
  # combined_table <- combined_table[order(
  #   match(combined_table$Parameter, parameters$Parameter)), ]
  row.names(combined_table) <- NULL

  # Prepare output
  class(combined_table) <- class(parameters)
  attributes(combined_table) <- utils::modifyList(attributes(parameters), attributes(combined_table))

  combined_table
}


#' @keywords internal
.combine_tables_performance <- function(parameters, performance) {
  combined_table <- parameters

  # Pretty names
  if (!is.null(attributes(parameters)$pretty_names)) {
    combined_table$Parameter <- attributes(parameters)$pretty_names[parameters$Parameter]
  }

  # Skip row
  combined_table[nrow(combined_table) + 1, ] <- NA

  # Prettify performance names
  perf_names <- colnames(performance)
  perf_names[perf_names == "R2_adjusted"] <- "R2 (adj.)"
  perf_names[perf_names == "R2_Tjur"] <- "Tjur's R2"
  perf_names[perf_names == "BIC_adjusted"] <- "BIC (adj.)"
  perf_names[perf_names == "R2_conditional"] <- "R2 (conditional)"
  perf_names[perf_names == "R2_marginal"] <- "R2 (marginal)"


  # add performance
  perf_vertical <- data.frame(
    Parameter = perf_names,
    Fit = as.numeric(performance[1, ]),
    stringsAsFactors = FALSE
  )

  # remove missing values
  perf_vertical <- perf_vertical[!is.na(perf_vertical$Fit), ]

  # Name parameter column
  name_parameter <- names(parameters)[names(parameters) %in% c("Parameter", "Link", "To")][1]
  names(perf_vertical)[1] <- name_parameter

  # Merge
  combined_table <- merge(combined_table, perf_vertical, by = name_parameter, all = TRUE, sort = FALSE)

  # Prepare output
  class(combined_table) <- class(parameters)
  attributes(combined_table) <- utils::modifyList(attributes(parameters), attributes(combined_table))

  # Add pretty names
  pretty_names <- combined_table$Parameter
  # pretty_names <- pretty_names[!is.na(pretty_names)]
  names(pretty_names) <- pretty_names
  attr(combined_table, "pretty_names") <- pretty_names

  combined_table
}


#' @keywords internal
.remove_performance <- function(table) {
  if ("Fit" %in% names(table)) {
    params_table <- table[is.na(table$Fit), ]
    params_table <- params_table[!is.na(params_table$Parameter), ]
  } else {
    params_table <- table
  }
  params_table
}
