# report 0.3.6
* Separated sex and gender into different searches/columns
* Sex is reported % female, % male, % other, % missing if any cases are missing
* Gender is reported % Women, % Men, % Non-Binary, % missing if any cases are missing
* Age reports % missing if any cases are missing
* Tests have been updated to reflect these changes
* Tests for missing cases have also been updated to test numbers for `NA`, and strings for `""` as `""` is not NA.


# report 0.3.5

* Fixed issue with possibly wrong numbers in the `total` column from 
  `report_sample()`, when grouping variable contained missing values.

# report 0.3.1

* Added support for models of class `ivreg` (*ivreg*).

# report 0.3.0

* Initial release of the package.
