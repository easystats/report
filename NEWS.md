# report 0.5.2

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

