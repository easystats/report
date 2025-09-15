test_that("cite_easystats() works with default parameters", {
  result <- cite_easystats()
  expect_s3_class(result, "cite_easystats")
  expect_type(result, "list")
  expect_named(result, c("intext", "refs"))
  expect_type(result$intext, "character")
  expect_type(result$refs, "character")
  expect_match(result$intext, "easystats")
  expect_match(result$refs, "Lüdecke")
})

test_that("cite_easystats() works with different formats", {
  # Text format (default)
  result_text <- cite_easystats(format = "text")
  expect_match(result_text$intext, "collection of packages")
  expect_match(result_text$refs, "- Lüdecke")

  # Markdown format
  result_md <- cite_easystats(format = "markdown")
  expect_match(result_md$intext, "@easystatsPackage")
  expect_match(result_md$refs, "id: easystatsPackage")

  # BibLaTeX format
  result_bib <- cite_easystats(format = "biblatex")
  expect_match(result_bib$intext, "\\\\cite\\{")
  expect_match(result_bib$refs, "@software\\{")
})

test_that("cite_easystats() works with different package specifications", {
  # Single package
  result_single <- cite_easystats(packages = "insight")
  expect_true(any(grepl("insight", result_single$refs)))

  # Multiple specific packages
  result_multi <- cite_easystats(packages = c("insight", "parameters"))
  expect_true(any(grepl("insight", result_multi$refs)))
  expect_true(any(grepl("parameters", result_multi$refs)))
})

test_that("cite_easystats() handles prefix and suffix correctly", {
  # With default prefix/suffix
  result_default <- cite_easystats()
  expect_match(result_default$intext, "^Analyses were conducted")
  expect_match(result_default$intext, "\\.$")

  # Without prefix
  result_no_prefix <- cite_easystats(intext_prefix = FALSE)
  expect_false(grepl("^Analyses were conducted", result_no_prefix$intext))

  # Without suffix
  result_no_suffix <- cite_easystats(intext_suffix = FALSE)
  expect_false(grepl("\\.$", result_no_suffix$intext))

  # Custom prefix and suffix
  result_custom <- cite_easystats(
    intext_prefix = "Custom prefix ",
    intext_suffix = " custom suffix"
  )
  expect_match(result_custom$intext, "^Custom prefix")
  expect_match(result_custom$intext, "custom suffix$")
})

test_that("cite_easystats() handles missing packages gracefully", {
  # Test with non-existent package (should show warning and omit)
  expect_message(
    result <- cite_easystats(packages = c("insight", "nonexistent_package")),
    "not installed"
  )
  expect_true(any(grepl("insight", result$refs)))
  expect_false(any(grepl("nonexistent", result$refs)))
})

test_that("print.cite_easystats() works correctly", {
  result <- cite_easystats()

  # Test different 'what' arguments
  expect_output(print(result, what = "all"), "Thanks for crediting")
  expect_output(print(result, what = "intext"), "easystats")
  expect_output(print(result, what = "refs"), "Lüdecke")

  # Test with 'cite' and 'bib' aliases
  expect_output(print(result, what = "cite"), "easystats")
  expect_output(print(result, what = "bib"), "Lüdecke")
})

test_that("summary.cite_easystats() works correctly", {
  result <- cite_easystats()

  # Test different 'what' arguments
  expect_output(summary(result, what = "all"), "Citations")
  expect_output(summary(result, what = "intext"), "easystats")
  expect_output(summary(result, what = "refs"), "Lüdecke")

  # Test with 'cite' and 'bib' aliases
  expect_output(summary(result, what = "cite"), "easystats")
  expect_output(summary(result, what = "bib"), "Lüdecke")
})

test_that(".disamguation_letters() helper function works", {
  # Test with logical vector
  result1 <- report:::.disamguation_letters(c(TRUE, FALSE, TRUE))
  expect_equal(result1, c("a", "", "b"))

  result2 <- report:::.disamguation_letters(c(TRUE))
  expect_equal(result2, "a") # Single TRUE should return "a", not empty

  result3 <- report:::.disamguation_letters(c(FALSE, FALSE))
  expect_equal(result3, c("", ""))

  # Test error handling
  expect_error(
    report:::.disamguation_letters(c(1, 2, 3)),
    "must be a logical vector"
  )
})
