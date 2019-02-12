# parameters <- parameters::model_parameters(circus::stanreg_lm_1, standardize = TRUE, estimate = c("median", "mean", "MAP"), test = c("pd", "rope", "p_map"))
#
#
# library(dplyr)
# library(report)
#
# parameters %>%
#   mutate_if(is.numeric, round, digits=2)
#
#
#
# cat(as.list(parameters))
#   # mutate_if(is.numeric, format_value, digits=2)
