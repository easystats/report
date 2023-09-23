# report 0.5.8

Minor changes 

* `report` now supports variables of class `htest` of type Friedman test.

* `report` now supports variables of class `Date`, treating them like factors.

* `report` now supports objects of class `estimate_contrasts`, from easystats'
  `modelbased::estimate_contrasts`, outputting either the results in text form,
  or as a table.

* `report_sample`
  * now reports the weighted number of observations when data
  is both grouped an weighted.
  * gains `ci`, `ci_method` and `ci_adjust` arguments, to compute
  confidence intervals for proportions of factor levels. Currently, two different
  methods (*Wald* and *Wilson*) are available.
  * now works on grouped data frame, using the defined groups as
  values for the `group_by` argument.
  * can now summarize data based on more than one grouping variable
  (i.e. `group_by` is allowed to be longer than 1).

* The `print` method for `report_sample` gains a `layout` argument, to print
  tables either in `"horizontal"` or `"vertical"` layout.

Bug fixes

* Fixed issue in `report_participants`, which did not print the `"gender"`
  category for grouped output when that argument was written in lower-case.
  Gender now also supports more alternate spellings, and age converts the
  respective column to numeric.

* Fixed printing issue for intercept-only models.

# report 0.5.7

Hotfix for CRAN reverse dependency compatibility.

# report 0.5.6

Breaking Changes

- The minimum needed R version has been bumped to `3.6`.

Minor changes

* `report_sample` improvement
  * Gains an `n` argument to also optionally include sample size.
  * Fixes bug whereas the `total` parameter was not respected.

* `report_effectsize` improvement
  * For `t.test` (htest) objects, now support the `type` (one of `c("d", "g")`) 
    and `rules` (one of `c"cohen1988", "sawilowsky2009", "gignac2016")`)
    arguments.

# report 0.5.5

BREAKING CHANGES

* The minimum needed R version is now bumped to 3.5.

Minor changes

* `report_participants` improvement (@rempsyc, #260)

    * Now correctly reports NA values as % missing

    * Adds support for country and race demographic information

BUG FIXES

* Fixed bug with truncated output about confidence interval distribution in 
  `report()`.

# report 0.5.1

* Hotfix release to fix failing tests and to unarchive package on CRAN.

# report 0.5.0

BREAKING CHANGES

* The following functions have been removed from `{report}` and now live in
  [`{datawizard}`](https://easystats.github.io/datawizard/reference/index.html)
  package:

Data wrangling helpers:

- `data_addprefix()`

- `data_addsuffix()`

- `data_findcols()`

- `data_remove()`

- `data_rename()`

- `data_reorder()`

Text formatting helpers:

- `format_text()`

- `text_fullstop()`

- `text_lastchar()`

- `text_concatenate()`

- `text_paste()`

- `text_remove()`

- `text_wrap()`

MAJOR CHANGES

* Reporting participant's sex/gender information has improved (thanks to
  @drfeinberg, #212)

    - Separated sex and gender into different searches/columns

    - Sex is reported % female, % male, % other, % missing if any cases are missing

    - Gender is reported % Women, % Men, % Non-Binary, % missing if any cases are missing

    - Age reports % missing if any cases are missing.

# report 0.4.0

* Maintenance release.

# report 0.3.5

* Fixed issue with possibly wrong numbers in the `total` column from
  `report_sample()`, when grouping variable contained missing values.

# report 0.3.1

* Added support for models of class `ivreg` (*ivreg*).

# report 0.3.0

* Initial release of the package.

