# report.htest-chi2 report

    Code
      report(x)
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Pearson's Chi-squared test of independence between gender and party
      suggests that the effect is statistically significant, and small (chi2 = 30.07,
      p < .001; Adjusted Cramer's v = 0.10, 95% CI [0.07, 1.00])

---

    Code
      report(x, rules = "funder2019")
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Pearson's Chi-squared test of independence between gender and party
      suggests that the effect is statistically significant, and small (chi2 = 30.07,
      p < .001; Adjusted Cramer's v = 0.10, 95% CI [0.07, 1.00])

---

    Code
      report(x, rules = "gignac2016")
    Output
      Effect sizes were labelled following Gignac's (2016) recommendations.
      
      The Pearson's Chi-squared test of independence between gender and party
      suggests that the effect is statistically significant, and small (chi2 = 30.07,
      p < .001; Adjusted Cramer's v = 0.10, 95% CI [0.07, 1.00])

---

    Code
      report(x, rules = "cohen1988")
    Output
      Effect sizes were labelled following Cohen's (1988) recommendations.
      
      The Pearson's Chi-squared test of independence between gender and party
      suggests that the effect is statistically significant, and small (chi2 = 30.07,
      p < .001; Adjusted Cramer's v = 0.10, 95% CI [0.07, 1.00])

---

    Code
      report(x, rules = "evans1996")
    Output
      Effect sizes were labelled following Evans's (1996) recommendations.
      
      The Pearson's Chi-squared test of independence between gender and party
      suggests that the effect is statistically significant, and very weak (chi2 =
      30.07, p < .001; Adjusted Cramer's v = 0.10, 95% CI [0.07, 1.00])

---

    Code
      report(x, rules = "lovakov2021")
    Output
      Effect sizes were labelled following Lovakov's (2021) recommendations.
      
      The Pearson's Chi-squared test of independence between gender and party
      suggests that the effect is statistically significant, and very small (chi2 =
      30.07, p < .001; Adjusted Cramer's v = 0.10, 95% CI [0.07, 1.00])

---

    Code
      report(x, type = "cramers_v")
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Pearson's Chi-squared test of independence between gender and party
      suggests that the effect is statistically significant, and small (chi2 = 30.07,
      p < .001; Adjusted Cramer's v = 0.10, 95% CI [0.07, 1.00])

---

    Code
      report(x, type = "pearsons_c")
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Pearson's Chi-squared test of independence between gender and party
      suggests that the effect is statistically significant, and small (chi2 = 30.07,
      p < .001; Pearson's c = 0.10, 95% CI [0.07, 1.00])

---

    Code
      report(x, type = "tschuprows_t", adjust = FALSE)
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Pearson's Chi-squared test of independence between gender and party
      suggests that the effect is statistically significant, and very small (chi2 =
      30.07, p < .001; Tschuprow's t = 0.09, 95% CI [0.06, 1.00])

---

    Code
      report(x, type = "tschuprows_t")
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Pearson's Chi-squared test of independence between gender and party
      suggests that the effect is statistically significant, and very small (chi2 =
      30.07, p < .001; Adjusted Tschuprow's t = 0.08, 95% CI [0.06, 1.00])

---

    Code
      report(x, type = "cohens_w")
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Pearson's Chi-squared test of independence between gender and party
      suggests that the effect is statistically significant, and small (chi2 = 30.07,
      p < .001; Cohens_w = 0.10, 95% CI [0.07, 1.00])

---

    Code
      report(x, type = "phi")
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Pearson's Chi-squared test with Yates' continuity correction of
      independence between Diagnosis and Group suggests that the effect is
      statistically significant, and large (chi2 = 31.57, p < .001; Adjusted Phi =
      0.36, 95% CI [0.25, 1.00])

---

    Code
      report(x, type = "cohens_h", rules = "sawilowsky2009")
    Output
      Effect sizes were labelled following Savilowsky's (2009) recommendations.
      
      The Pearson's Chi-squared test with Yates' continuity correction of
      independence between Diagnosis and Group suggests that the effect is
      statistically significant, and medium (chi2 = 31.57, p < .001; Cohen's h =
      0.74, 95% CI [0.50, 0.99])

---

    Code
      report(x, type = "riskratio")
    Output
      
      
      The Pearson's Chi-squared test with Yates' continuity correction of
      independence between Diagnosis and Group suggests that the effect is
      statistically significant (chi2 = 31.57, p < .001; Risk_ratio = 2.54, 95% CI
      [1.80, 3.60])

---

    Code
      report(x)
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Pearson's Chi-squared test of independence between mtcars$cyl and mtcars$am
      suggests that the effect is statistically significant, and very large (chi2 =
      8.74, p = 0.013; Adjusted Cramer's v = 0.46, 95% CI [0.00, 1.00])

# report.htest-chi2 for given probabilities

    Code
      report(x)
    Output
      Effect sizes were labelled following Funder's (2019) recommendations.
      
      The Chi-squared test for given probabilities / goodness of fit of
      table(mtcars$cyl) to a distribution of [4: n=3.2, 6: n=9.6, 8: n=19.2] suggests
      that the effect is statistically significant, and medium (chi2 = 21.12, p <
      .001; Fei = 0.27, 95% CI [0.17, 1.00])

