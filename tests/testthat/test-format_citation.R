test_that("format_citation() works with basic formatting", {
  citation <- "Makowski, D., Ben-Shachar, M. S., Patil, I., & Ludecke, D. (2020). Methods and Algorithms for Correlation Analysis in R. Journal of Open Source Software, 5(51), 2306."
  
  # Test basic citation (no changes)
  result_basic <- format_citation(citation)
  expect_equal(result_basic, citation)
  
  # Test authorsdate option
  result_authorsdate <- format_citation(citation, authorsdate = TRUE)
  expect_match(result_authorsdate, "^Makowski")
  expect_match(result_authorsdate, "\\(2020\\)$")
  expect_false(grepl("Journal", result_authorsdate))
  
  # Test short option (with authorsdate)
  result_short <- format_citation(citation, authorsdate = TRUE, short = TRUE)
  expect_match(result_short, "Makowski.*et al\\.")
  expect_false(grepl("Ben-Shachar", result_short))
  
  # Test intext option (remove parentheses around date)
  result_intext <- format_citation(citation, authorsdate = TRUE, intext = TRUE)
  expect_match(result_intext, "Makowski.*2020")
  expect_false(grepl("\\(2020\\)", result_intext))
  
  # Test all options combined
  result_all <- format_citation(citation, authorsdate = TRUE, short = TRUE, intext = TRUE)
  expect_match(result_all, "^Makowski.*et al.*2020$")
  expect_false(grepl("[\\(\\)]", result_all))
})

test_that("format_citation() handles multiple citations", {
  citations <- c(
    "Makowski, D., Ben-Shachar, M. S., Patil, I., & Ludecke, D. (2020). Title 1.",
    "Smith, J. (2019). Title 2."
  )
  
  result <- format_citation(citations, authorsdate = TRUE, short = TRUE)
  expect_length(result, 2)
  expect_match(result[1], "Makowski.*et al")
  expect_match(result[2], "Smith.*\\(2019\\)")
})

test_that("cite_citation() creates proper parenthetical citation", {
  citation <- "Makowski, D., Ben-Shachar, M. S., Patil, I., & Ludecke, D. (2020). Methods and Algorithms for Correlation Analysis in R."
  
  result <- cite_citation(citation)
  expect_match(result, "^\\(Makowski.*et al.*2020\\)$")
})

test_that("clean_citation() works with citation objects", {
  # Test with character string (basic case)
  citation_text <- "Makowski, D. et al. (2020). Some Title."
  result_text <- clean_citation(citation_text)
  expect_type(result_text, "character")
  expect_length(result_text, 1)
  
  # Test with citation object format (simulated)
  citation_with_prefix <- "To cite package 'report' in publications use:\n\n  Makowski, D. et al. (2020). Some Title.\n\nA BibTeX entry for LaTeX users is"
  result_clean <- clean_citation(citation_with_prefix)
  expect_false(grepl("To cite", result_clean))
  expect_match(result_clean, "Makowski")
})

test_that("format_citation() handles edge cases", {
  # Single author
  single_author <- "Smith, J. (2020). Title."
  result_single <- format_citation(single_author, authorsdate = TRUE, short = TRUE)
  expect_false(grepl("et al", result_single))
  expect_match(result_single, "Smith.*\\(2020\\)")
  
  # Citation with middle initials
  with_initials <- "Makowski, D. M., Ben-Shachar, M. S. (2020). Title."
  result_initials <- format_citation(with_initials, authorsdate = TRUE)
  expect_false(grepl("D\\. M\\.", result_initials))
  expect_match(result_initials, "Makowski.*Ben-Shachar")
})