#' @export
model_table.htest <- function(model, ...){
  table_full <- parameters::model_parameters(model)
  table <- table_full
  # Return output
  .model_table_return_output(table, table_full)
}
