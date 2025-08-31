test_that(".text_effectsize handles custom rules correctly", {
  # Test NULL input
  expect_equal(report:::.text_effectsize(NULL), "")
  
  # Test known predefined rules
  expect_equal(
    report:::.text_effectsize("cohen1988"),
    "Effect sizes were labelled following Cohen's (1988) recommendations."
  )
  expect_equal(
    report:::.text_effectsize("sawilowsky2009"),
    "Effect sizes were labelled following Savilowsky's (2009) recommendations."
  )
  expect_equal(
    report:::.text_effectsize("gignac2016"),
    "Effect sizes were labelled following Gignac's (2016) recommendations."
  )
  expect_equal(
    report:::.text_effectsize("funder2019"),
    "Effect sizes were labelled following Funder's (2019) recommendations."
  )
  expect_equal(
    report:::.text_effectsize("lovakov2021"),
    "Effect sizes were labelled following Lovakov's (2021) recommendations."
  )
  expect_equal(
    report:::.text_effectsize("evans1996"),
    "Effect sizes were labelled following Evans's (1996) recommendations."
  )
  expect_equal(
    report:::.text_effectsize("chen2010"),
    "Effect sizes were labelled following Chen's (2010) recommendations."
  )
  expect_equal(
    report:::.text_effectsize("field2013"),
    "Effect sizes were labelled following Field's (2013) recommendations."
  )
  expect_equal(
    report:::.text_effectsize("landis1977"),
    "Effect sizes were labelled following Landis' (1977) recommendations."
  )
  
  # Test custom rule names (strings not in predefined list)
  expect_equal(
    report:::.text_effectsize("Unknown"),
    "Effect sizes were labelled following a custom set of rules."
  )
  expect_equal(
    report:::.text_effectsize("MyCustomRules"),
    "Effect sizes were labelled following a custom set of rules."
  )
  expect_equal(
    report:::.text_effectsize("CustomRule2024"),
    "Effect sizes were labelled following a custom set of rules."
  )
  
  # Test non-character input (should also return custom rules text)
  expect_equal(
    report:::.text_effectsize(123),
    "Effect sizes were labelled following a custom set of rules."
  )
  expect_equal(
    report:::.text_effectsize(list()),
    "Effect sizes were labelled following a custom set of rules."
  )
})