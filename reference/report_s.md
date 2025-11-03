# Report S- and p-values in easy language.

Reports interpretation of S- and p-values in easy language.

## Usage

``` r
report_s(s = NULL, p = NULL, test_value = 0, test_parameter = "parameter")
```

## Arguments

- s:

  An S-value. Either `s` or `p` must be provided.

- p:

  A p-value. Either `s` or `p` must be provided.

- test_value:

  The value of the test parameter under the null hypothesis.

- test_parameter:

  The name of the test parameter under the null hypothesis.

## Value

A string with the interpretation of the S- or p-value.

## Examples

``` r
report_s(s = 1.5)
#> If the test hypothesis (parameter = 0) and all model assumptions were
#>   true, there is a 35% chance of observing this outcome. How weird is
#>   that? It's hardly more surprising than getting 2 heads in a row with
#>   fair coin tosses.
report_s(p = 0.05)
#> If the test hypothesis (parameter = 0) and all model assumptions were
#>   true, there is a 5% chance of observing this outcome. How weird is that?
#>   It's hardly more surprising than getting 4 heads in a row with fair coin
#>   tosses.
```
