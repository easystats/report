# report_sample weights

    Code
      report_sample(airquality, weights = "Temp")
    Output
      # Descriptive Statistics (weighted)
      
      Variable          |        Summary
      ----------------------------------
      Mean Ozone (SD)   |  44.91 (33.54)
      Mean Solar.R (SD) | 188.84 (87.33)
      Mean Wind (SD)    |    9.76 (3.48)
      Mean Month (SD)   |    7.07 (1.37)
      Mean Day (SD)     |   15.66 (8.93)

---

    Code
      report_sample(mtcars, weights = "carb")
    Output
      # Descriptive Statistics (weighted)
      
      Variable       |         Summary
      --------------------------------
      Mean mpg (SD)  |    18.24 (5.17)
      Mean cyl (SD)  |     6.71 (1.57)
      Mean disp (SD) | 257.96 (120.25)
      Mean hp (SD)   |  175.29 (75.91)
      Mean drat (SD) |     3.57 (0.48)
      Mean wt (SD)   |     3.45 (0.95)
      Mean qsec (SD) |    17.20 (1.76)
      Mean vs (SD)   |     0.28 (0.45)
      Mean am (SD)   |     0.42 (0.50)
      Mean gear (SD) |     3.80 (0.81)

---

    Code
      report_sample(iris, weights = "Petal.Width")
    Output
      # Descriptive Statistics (weighted)
      
      Variable                |     Summary
      -------------------------------------
      Mean Sepal.Length (SD)  | 6.27 (0.72)
      Mean Sepal.Width (SD)   | 2.96 (0.36)
      Mean Petal.Length (SD)  | 4.83 (1.19)
      Species [setosa], %     |         6.8
      Species [versicolor], % |        36.9
      Species [virginica], %  |        56.3

