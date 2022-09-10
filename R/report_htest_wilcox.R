# report_table -----------------

.report_table_wilcox <- function(table_full, effsize) {
  table_full <- cbind(table_full, attributes(effsize)$table)
  list(table = NULL, table_full = table_full)
}
