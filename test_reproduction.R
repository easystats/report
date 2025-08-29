# Test script to try to reproduce the glmmTMB issue
# Since we don't have glmmTMB installed, let's try to trace through the code

library(report)

# Test with a regular lm model first
set.seed(123)
lm_fit <- lm(mpg ~ hp + wt, data = mtcars)

# Get the components that would be used in report_text.lm
params <- report_parameters(lm_fit, include_intercept = FALSE)
table <- attributes(params)$table

info <- report_info(lm_fit, effectsize = attributes(params)$effectsize, parameters = params)
model <- report_model(lm_fit, table = table)
perf <- report_performance(lm_fit, table = table)  
intercept <- report_intercept(lm_fit, table = table)

# Print each component to understand structure
cat("Model:\n", as.character(model), "\n\n")
cat("Performance:\n", as.character(perf), "\n\n")  
cat("Intercept:\n", as.character(intercept), "\n\n")
cat("Info:\n", as.character(info), "\n\n")

# Check summary versions
cat("Summary Model:\n", as.character(summary(model)), "\n\n")
cat("Summary Performance:\n", as.character(summary(perf)), "\n\n")
cat("Summary Intercept:\n", as.character(summary(intercept)), "\n\n")
cat("Summary Info:\n", as.character(summary(info)), "\n\n")

# Now simulate the text construction to see if there's an issue
params_text_full <- paste0(" Within this model:\n\n", as.character(params))

text_full <- paste0(
  "We fitted a ",
  model,
  ". ",
  perf,
  ifelse(nzchar(perf, keepNA = TRUE), ". ", ""),
  intercept,
  params_text_full,
  "\n\n",
  info
)

cat("Full text result:\n")
cat(text_full)