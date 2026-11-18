skip_if_not_installed("lavaan")
skip_on_cran() # lavaan SEM models can be computationally intensive

structure <- " ind60 =~ x1 + x2 + x3
  dem60 =~ y1 + y2 + y3
  dem60 ~ ind60 "

set.seed(123)
model <- lavaan::sem(structure, data = lavaan::PoliticalDemocracy)

# Specific reports
test_that("model-lavaan detailed report", {
  expect_snapshot(variant = "windows", report(model))
})

test_that("model-lavaan detailed table", {
  table <- report_table(model)
  expect_equal(
    table$Fit[table$Parameter == "GFI" & !is.na(table$Parameter)],
    as.numeric(lavaan::fitMeasures(model, "gfi")),
    tolerance = 1e-12
  )

  # GFI varies across supported lavaan versions. Compare it to the fitted model
  # above, then normalize only that value in the printed-table snapshot.
  expect_snapshot(
    variant = "windows",
    print(table),
    transform = function(lines) {
      sub(
        "^(\\s*GFI\\s+\\|.*\\|\\s*)[-0-9.]+\\s*$",
        "\\1<GFI>",
        lines,
        perl = TRUE
      )
    }
  )
})

test_that("model-lavaan detailed performance", {
  performance <- report_performance(model)
  gfi_text <- grep(
    "\\bGFI \\(",
    as.character(performance),
    value = TRUE,
    perl = TRUE
  )
  expect_length(gfi_text, 1)
  gfi <- sub(".*\\bGFI \\(([-0-9.]+).*", "\\1", gfi_text, perl = TRUE)
  expect_equal(
    as.numeric(gfi),
    round(as.numeric(lavaan::fitMeasures(model, "gfi")), 2),
    tolerance = 1e-12
  )

  expect_snapshot(
    variant = "windows",
    print(performance),
    transform = function(lines) {
      sub("\\bGFI \\([-0-9.]+", "GFI (<GFI>", lines, perl = TRUE)
    }
  )
})
