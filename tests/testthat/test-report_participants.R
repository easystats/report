test_that("report_participants", {
  data <- data.frame(
    "Age" = c(22, 22, 54, 54, 8, 8),
    "Sex" = c("F", "F", "M", "M", "F", "F"),
    "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3")
  )

  testthat::expect_equal(
    report_participants(data, age = "Age", sex = "Sex", participant = "Participant"),
    "3 participants (Mean age = 28.00, SD = 23.58, range = [8, 54]; 66.67% females)"
  )
  testthat::expect_equal(nchar(report_participants(data, participant = "Participant", spell_n = TRUE)), 82)
  testthat::expect_equal(
    report_participants(data, participant = "Participant", spell_n = TRUE),
    "Three participants (Mean age = 28.00, SD = 23.58, range = [8, 54]; 66.67% females)"
  )
})
