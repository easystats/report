# report_sample, with more than one grouping variable

    Code
      out
    Output
      # Descriptive Statistics
      
      Variable               | setosa, a (n=16) | versicolor, a (n=17) | virginica, a (n=9) | setosa, b (n=15) | versicolor, b (n=17) | virginica, b (n=22) | setosa, c (n=19) | versicolor, c (n=16) | virginica, c (n=19) | Total (n=150)
      -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      Mean Sepal.Length (SD) |      5.13 (0.36) |          6.08 (0.48) |        6.59 (0.44) |      4.91 (0.31) |          5.84 (0.54) |         6.77 (0.63) |      4.97 (0.36) |          5.88 (0.53) |         6.38 (0.69) |   5.84 (0.83)
      Mean Sepal.Width (SD)  |      3.50 (0.42) |          2.76 (0.40) |        3.02 (0.25) |      3.34 (0.25) |          2.81 (0.25) |         3.05 (0.36) |      3.44 (0.43) |          2.74 (0.29) |         2.87 (0.30) |   3.06 (0.44)

# report_sample, print vertical

    Code
      print(out, layout = "vertical")
    Output
      # Descriptive Statistics
      
      Groups               | Mean Sepal.Length (SD) | Mean Sepal.Width (SD) | Mean Petal.Length (SD)
      ----------------------------------------------------------------------------------------------
      setosa, a (n=16)     |            5.13 (0.36) |           3.50 (0.42) |            1.50 (0.12)
      versicolor, a (n=17) |            6.08 (0.48) |           2.76 (0.40) |            4.37 (0.44)
      virginica, a (n=9)   |            6.59 (0.44) |           3.02 (0.25) |            5.57 (0.52)
      setosa, b (n=15)     |            4.91 (0.31) |           3.34 (0.25) |            1.47 (0.17)
      versicolor, b (n=17) |            5.84 (0.54) |           2.81 (0.25) |            4.25 (0.44)
      virginica, b (n=22)  |            6.77 (0.63) |           3.05 (0.36) |            5.73 (0.57)
      setosa, c (n=19)     |            4.97 (0.36) |           3.44 (0.43) |            1.43 (0.21)
      versicolor, c (n=16) |            5.88 (0.53) |           2.74 (0.29) |            4.16 (0.53)
      virginica, c (n=19)  |            6.38 (0.69) |           2.87 (0.30) |            5.34 (0.49)
      Total (n=150)        |            5.84 (0.83) |           3.06 (0.44) |            3.76 (1.77)

