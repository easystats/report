test_that("report_participants", {
  data <- data.frame(
    "Age" = c(22, 22, 54, 54, 8, 8),
    "Sex" = c("F", "F", "M", "M", "F", "F"),
    "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3")
  )

  expect_equal(
    report_participants(data, age = "Age", sex = "Sex", participant = "Participant"),
    "3 participants (Mean age = 28.0, SD = 23.6, range: [8, 54]; 66.7% females)"
  )
  expect_equal(nchar(report_participants(data, participant = "Participant", spell_n = TRUE)), 78)
  expect_equal(
    report_participants(data, participant = "Participant", spell_n = TRUE),
    "Three participants (Mean age = 28.0, SD = 23.6, range: [8, 54]; 66.7% females)"
  )

  data2 <- data.frame(
    "Age" = c(22, 22, 54, 54, 8, 8),
    "Sex" = c("F", "F", "M", "O", "F", "O")
    )

  expect_equal(
    report_participants(data2),
    "6 participants (Mean age = 28.0, SD = 21.1, range: [8, 54]; 50.0% females)"
  )

  # TO DO : discuss if this is the correct approach to report in case of missing values

  data3 <- data.frame(
    "Age" = c(22, 22, 54, 54, 8, 8),
    "Sex" = c("F", "F", NA, NA, NA, NA)
  )

  expect_equal(
    report_participants(data3),
    "6 participants (Mean age = 28.0, SD = 21.1, range: [8, 54]; 33.3% females)"
  )
})
