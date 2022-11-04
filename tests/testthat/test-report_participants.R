test_that("report_participants", {
  data <- data.frame(
    "Age" = c(22, 22, 54, 54, 8, 8),
    "Sex" = c("F", "F", "M", "M", "I", "I"),
    "Gender" = c("W", "W", "M", "M", "N", "N"),
    "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3")
  )

  expect_snapshot(report_participants(data, age = "Age", sex = "Sex", participant = "Participant"))
  expect_snapshot(report_participants(data, participant = "Participant", spell_n = TRUE))

  expect_equal(nchar(report_participants(data, participant = "Participant", spell_n = TRUE)), 160)

  data2 <- data.frame(
    "Age" = c(22, 22, 54, 54, 8, 8),
    "Sex" = c("F", "F", "M", "O", "F", "O"),
    "Gender" = c("W", "W", "M", "O", "W", "O")
  )

  expect_snapshot(report_participants(data2))

  data3 <- data.frame(
    "Age" = c(22, 82, NA, NA, NA, NA),
    "Sex" = c("F", "F", "", "", "NA", NA),
    "Gender" = c("W", "W", "", "", "NA", NA)
  )

  expect_snapshot(report_participants(data3))

  # Add tests for education, country, race
  data4 <- data.frame(
    "Education" = c(0, 8, -3, -5, 3, 5, NA),
    "Education2" = c("Bachelor", "PhD", "Highschool", "Highschool", "Bachelor", "Bachelor", NA),
    "Country" = c("USA", "Canada", "Canada", "India", "Germany", "USA", NA),
    "Race" = c("Black", NA, "White", "Asian", "Black", "Black", "White")
  )

  expect_snapshot(report_participants(data4))
  expect_snapshot(report_participants(data4, education = "Education2"))
  expect_snapshot(report_participants(data4, threshold = 15))
})
