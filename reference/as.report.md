# Create or test objects of class [report](https://easystats.github.io/report/reference/report.md).

Allows to create or test whether an object is of the `report` class.

## Usage

``` r
as.report_text(x, ...)

as.report(text, table = NULL, plot = NULL, ...)

is.report(x)

as.report_effectsize(x, summary = NULL, prefix = "  - ", ...)

as.report_info(x, summary = NULL, ...)

as.report_intercept(x, summary = NULL, ...)

as.report_model(x, summary = NULL, ...)

as.report_parameters(x, summary = NULL, prefix = "  - ", ...)

as.report_performance(x, summary = NULL, ...)

as.report_priors(x, summary = NULL, ...)

as.report_random(x, summary = NULL, ...)

as.report_statistics(x, summary = NULL, prefix = "  - ", ...)

as.report_table(x, ...)
```

## Arguments

- x:

  An arbitrary R object.

- ...:

  Args to be saved as attributes.

- text:

  Text obtained via
  [`report_text()`](https://easystats.github.io/report/reference/report_text.md)

- table:

  Table obtained via
  [`report_table()`](https://easystats.github.io/report/reference/report_table.md)

- plot:

  Plot obtained via `report_plot()`. Not yet implemented.

- summary:

  Add a summary as attribute (to be extracted via
  [`summary()`](https://rdrr.io/r/base/summary.html)).

- prefix:

  The prefix to be displayed in front of each parameter.

## Value

A report object or a `TRUE/FALSE` value.
