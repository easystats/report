# Miscellaneous reports

Other convenient or totally useless reports.

## Usage

``` r
report_date(...)

report_story(...)
```

## Arguments

- ...:

  Arguments passed to or from other methods.

## Value

Objects of class
[`report_text()`](https://easystats.github.io/report/reference/report_text.md).

## See also

Specific components of reports (especially for stats models):

- [`report_table()`](https://easystats.github.io/report/reference/report_table.md)

- [`report_parameters()`](https://easystats.github.io/report/reference/report_parameters.md)

- [`report_statistics()`](https://easystats.github.io/report/reference/report_statistics.md)

- [`report_effectsize()`](https://easystats.github.io/report/reference/report_effectsize.md)

- [`report_model()`](https://easystats.github.io/report/reference/report_model.md)

- [`report_priors()`](https://easystats.github.io/report/reference/report_priors.md)

- [`report_random()`](https://easystats.github.io/report/reference/report_random.md)

- [`report_performance()`](https://easystats.github.io/report/reference/report_performance.md)

- [`report_info()`](https://easystats.github.io/report/reference/report_info.md)

- [`report_text()`](https://easystats.github.io/report/reference/report_text.md)

Other types of reports:

- [`report_system()`](https://easystats.github.io/report/reference/report.sessionInfo.md)

- [`report_packages()`](https://easystats.github.io/report/reference/report.sessionInfo.md)

- [`report_participants()`](https://easystats.github.io/report/reference/report_participants.md)

- [`report_sample()`](https://easystats.github.io/report/reference/report_sample.md)

- `report_date()`

Methods:

- [`as.report()`](https://easystats.github.io/report/reference/as.report.md)

Template file for supporting new models:

- [`report.default()`](https://easystats.github.io/report/reference/report.default.md)

## Examples

``` r
library(report)

report_date()
#> It's Wednesday, February 04 of the year 2026, at  2pm 06 and 08 seconds
summary(report_date())
#> 04/02/26 - 14:06:08
report_story()
#> Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's
#> not a story the Jedi would tell you. It's a Sith legend. Darth Plagueis was a
#> Dark Lord of the Sith, so powerful and so wise he could use the Force to
#> influence the midichlorians to create life... He had such a knowledge of the
#> dark side that he could even keep the ones he cared about from dying. The dark
#> side of the Force is a pathway to many abilities some consider to be unnatural.
#> He became so powerful... the only thing he was afraid of was losing his power,
#> which eventually, of course, he did. Unfortunately, he taught his apprentice
#> everything he knew, then his apprentice killed him in his sleep. Ironic. He
#> could save others from death, but not himself.
```
