test_that("SEM fit text preserves integer parts and signs", {
  values <- c(1, 1.1, -0.2)
  formatted <- c("1.00", "1.10", "-0.20")

  for (i in seq_along(values)) {
    fit <- data.frame(
      Name = "GFI",
      Value = values[i],
      Threshold = 0.95,
      Interpretation = if (values[i] > 0.95) "satisfactory" else "poor",
      stringsAsFactors = FALSE
    )
    expect_match(
      .text_performance_lavaan(fit),
      paste0("GFI (", formatted[i]),
      fixed = TRUE
    )
  }

  fit$Value <- 0.9
  fit$Threshold <- 1
  expect_match(.text_performance_lavaan(fit), "GFI (.90 < 1.00)", fixed = TRUE)
})

test_that("Bayesian diagnostics keep each parameter's convergence and ESS", {
  diagnostic <- data.frame(
    Rhat = c(1, 1.02, 1, 1.02),
    ESS_tail = c(1500, 1600, 400, 500),
    ESS_bulk = c(2500, 2600, 2700, 2800)
  )
  text <- .parameters_diagnostic_bayesian(diagnostic)

  expect_length(text, 4)
  for (i in seq_len(nrow(diagnostic))) {
    expect_match(
      text[i],
      paste0("Rhat = ", insight::format_value(diagnostic$Rhat[i], digits = 3)),
      fixed = TRUE
    )
    expect_match(
      text[i],
      paste0("ESS (tail) = ", diagnostic$ESS_tail[i]),
      fixed = TRUE
    )
  }
  expect_match(text[1], "indices are reliable", fixed = TRUE)
  expect_match(text[2], "indices appear as reliable", fixed = TRUE)
  expect_match(text[3], "indices are unreliable", fixed = TRUE)
  expect_match(text[4], "indices are unreliable", fixed = TRUE)
  expect_identical(
    .parameters_diagnostic_bayesian(diagnostic, only_when_insufficient = TRUE),
    c("", text[-1])
  )
})

test_that("Bayesian diagnostics support legacy and bulk ESS columns", {
  diagnostic <- data.frame(Rhat = c(1, 1.02), ESS = c(1500, 400))
  legacy <- .parameters_diagnostic_bayesian(diagnostic)
  expect_match(legacy[1], "ESS = 1500", fixed = TRUE)
  expect_match(legacy[2], "ESS = 400", fixed = TRUE)

  diagnostic$ESS_bulk <- diagnostic$ESS
  diagnostic$ESS <- NULL
  bulk <- .parameters_diagnostic_bayesian(diagnostic)
  expect_match(bulk[1], "ESS (bulk) = 1500", fixed = TRUE)
  expect_match(bulk[2], "ESS (bulk) = 400", fixed = TRUE)

  diagnostic$ESS_tail <- c(500, 600)
  diagnostic$ESS <- c(700, 800)
  expect_match(
    .parameters_diagnostic_bayesian(diagnostic)[1],
    "ESS (tail) = 500",
    fixed = TRUE
  )
})
