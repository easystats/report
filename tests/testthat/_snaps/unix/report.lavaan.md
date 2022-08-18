# model-lavaan detailed report

    Code
      report(model)
    Output
      [1] "Support for lavaan not fully implemented yet :("

# model-lavaan detailed table

    Code
      report_table(model)
    Warning <simpleWarning>
      No column names that matched the required search pattern were found.
    Output
      Parameter     | Coefficient |       95% CI |     z |      p |  Component |     Fit
      ----------------------------------------------------------------------------------
      ind60 =~ x1   |        1.00 | [1.00, 1.00] |       | < .001 |    Loading |        
      ind60 =~ x2   |        2.18 | [1.91, 2.45] | 15.59 | < .001 |    Loading |        
      ind60 =~ x3   |        1.82 | [1.52, 2.12] | 11.96 | < .001 |    Loading |        
      dem60 =~ y1   |        1.00 | [1.00, 1.00] |       | < .001 |    Loading |        
      dem60 =~ y2   |        1.04 | [0.66, 1.43] |  5.33 | < .001 |    Loading |        
      dem60 =~ y3   |        0.98 | [0.65, 1.30] |  5.89 | < .001 |    Loading |        
      dem60 ~ ind60 |        1.37 | [0.53, 2.21] |  3.20 | 0.001  | Regression |        
                    |             |              |       |        |            |        
      Chi2          |             |              |       |        |            |    7.98
      Chi2_df       |             |              |       |        |            |    8.00
      p_Chi2        |             |              |       |        |            |    0.44
      p_Baseline    |             |              |       |        |            |    0.00
      GFI           |             |              |       |        |            |    0.97
      AGFI          |             |              |       |        |            |    0.91
      NFI           |             |              |       |        |            |    0.97
      NNFI          |             |              |       |        |            |    1.00
      CFI           |             |              |       |        |            |    1.00
      RMSEA         |             |              |       |        |            |    0.00
      RMSEA_CI_low  |             |              |       |        |            |    0.00
      RMSEA_CI_high |             |              |       |        |            |    0.14
      p_RMSEA       |             |              |       |        |            |    0.57
      RMR           |             |              |       |        |            |    0.10
      SRMR          |             |              |       |        |            |    0.03
      RFI           |             |              |       |        |            |    0.95
      PNFI          |             |              |       |        |            |    0.52
      IFI           |             |              |       |        |            |    1.00
      RNI           |             |              |       |        |            |    1.00
      Loglikelihood |             |              |       |        |            | -778.27
      AIC           |             |              |       |        |            | 1582.54
      BIC           |             |              |       |        |            | 1612.67
      BIC (adj.)    |             |              |       |        |            | 1571.69

# model-lavaan detailed performance

    Code
      report_performance(model)
    Warning <simpleWarning>
      No column names that matched the required search pattern were found.
    Output
      The model is not significantly different from a baseline model (Chi2(8) = 7.98,
      p = 0.435). The GFI (.97 > .95) suggest a satisfactory fit., The model is not
      significantly different from a baseline model (Chi2(8) = 7.98, p = 0.435). The
      AGFI (.91 > .90) suggest a satisfactory fit., The model is not significantly
      different from a baseline model (Chi2(8) = 7.98, p = 0.435). The NFI (.97 >
      .90) suggest a satisfactory fit., The model is not significantly different from
      a baseline model (Chi2(8) = 7.98, p = 0.435). The NNFI (.00 > .90) suggest a
      satisfactory fit., The model is not significantly different from a baseline
      model (Chi2(8) = 7.98, p = 0.435). The CFI (.00 > .90) suggest a satisfactory
      fit., The model is not significantly different from a baseline model (Chi2(8) =
      7.98, p = 0.435). The RMSEA (.00 < .05) suggest a satisfactory fit., The model
      is not significantly different from a baseline model (Chi2(8) = 7.98, p =
      0.435). The SRMR (.03 < .08) suggest a satisfactory fit., The model is not
      significantly different from a baseline model (Chi2(8) = 7.98, p = 0.435). The
      RFI (.95 > .90) suggest a satisfactory fit., The model is not significantly
      different from a baseline model (Chi2(8) = 7.98, p = 0.435). The PNFI (.52 >
      .50) suggest a satisfactory fit. and The model is not significantly different
      from a baseline model (Chi2(8) = 7.98, p = 0.435). The IFI (.00 > .90) suggest
      a satisfactory fit.

