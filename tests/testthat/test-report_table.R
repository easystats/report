test_that("report_table() works with sessionInfo", {
  si <- sessionInfo()
  
  result <- report_table(si)
  
  expect_s3_class(result, "report_table")
  expect_s3_class(result, "data.frame")
  
  # Should have some basic information about the session
  expect_true(nrow(result) > 0)
})

test_that("report_table() works with basic data types", {
  # Numeric vector
  numeric_data <- iris$Sepal.Length
  result1 <- report_table(numeric_data)
  expect_s3_class(result1, "report_table")
  
  # Character vector  
  char_data <- as.character(round(iris$Sepal.Length, 1))
  result2 <- report_table(char_data)
  expect_s3_class(result2, "report_table")
  expect_true("n_Entries" %in% names(result2))
  
  # Factor
  factor_data <- iris$Species
  result3 <- report_table(factor_data)
  expect_s3_class(result3, "report_table")
  expect_true("Level" %in% names(result3))
})

test_that("report_table() works with data frames", {
  result <- report_table(iris)
  
  expect_s3_class(result, "report_table")
  expect_s3_class(result, "data.frame")
  expect_true(nrow(result) > 0)
})

test_that("report_table() works with statistical tests", {
  # t-test
  test_result <- t.test(mtcars$mpg ~ mtcars$am)
  result1 <- report_table(test_result)
  expect_s3_class(result1, "report_table")
  
  # ANOVA
  aov_result <- aov(Sepal.Length ~ Species, data = iris)
  result2 <- report_table(aov_result)
  expect_s3_class(result2, "report_table")
})

test_that("report_table() works with linear models", {
  # Simple linear model
  model1 <- lm(Sepal.Length ~ Petal.Length, data = iris)
  result1 <- report_table(model1)
  expect_s3_class(result1, "report_table")
  expect_true("Parameter" %in% names(result1) || "Coefficient" %in% names(result1))
  
  # Interaction model
  model2 <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
  result2 <- report_table(model2)
  expect_s3_class(result2, "report_table")
  
  # GLM
  model3 <- glm(vs ~ disp, data = mtcars, family = "binomial")
  result3 <- report_table(model3)
  expect_s3_class(result3, "report_table")
})

test_that("as.report_table() works correctly", {
  # Create a data frame to convert
  df <- data.frame(
    Parameter = c("A", "B"),
    Value = c(1, 2)
  )
  
  result <- as.report_table(df)
  expect_s3_class(result, "report_table")
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_equal(result$Parameter, c("A", "B"))
})

test_that("report_table methods work correctly", {
  # Create a simple report table
  df <- data.frame(x = 1:3, y = 4:6)
  result <- as.report_table(df)
  
  # Test summary
  summ <- summary(result)
  expect_s3_class(summ, "report_table")
  
  # Test print (should not error)
  expect_output(print(result))
})