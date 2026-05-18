# AI-Optimized Reports

## How to Use `report()` and get AI-Optimized Output

### The *“last statistical mile”*

The **report** package was originally designed in a pre-AI era with one
overarching goal: to produce human-readable prose. It was built to
bridge the scientist’s *“last statistical mile”*: that final, often
tedious transition from the raw output of statistical software to the
polished, written sentences of a manuscript. To achieve this, we
leveraged the power **easystats**’s ecosystem to automatically and
flexibly extract relevant information to engineer text with very
specific characteristics: the output had to be **deterministic**,
perfectly **consistent**, and adhere to fixed **reporting norms** (such
as APA style). By automating this translation, our aim was to facilitate
**fully reproducible research** (enabling reproducible *manuscripts*)
and drastically reduce human error. Ultimately, this allowed us to shift
the focus of **statistics education** away from memorizing where to find
the right numbers and how to format them, empowering researchers to
focus entirely on how to interpret and use those numbers to answer their
research questions.

### *easystats* in the Age of AI

However, the analytical landscape has fundamentally changed. Today,
researchers increasingly rely on AI agents and Large Language Models
(LLMs) to help interpret results, summarize findings, and draft
manuscripts, often by simply **pasting raw outputs directly into a chat
window**. This shift prompted us to ask: should the scope of the
*report* package be expanded to **support** this new workflow, rather
than pretending it doesn’t exist? And it wasn’t even a matter of staying
relevant, it was a matter of empowering our users to get the best
possible results from their new AI assistants.

While our standard narrative outputs are excellent for humans, they are
remarkably suboptimal for AI: verbose prose forces an LLM to waste
valuable context tokens re-parsing implicit structures, wasting tokens
and context memory. The answer to this challenge is
[`report_ai()`](https://easystats.github.io/report/reference/report_ai.md),
a function that can be triggered via an argument from the main
[`report()`](https://easystats.github.io/report/reference/report.md)
function. By stripping away the narrative bloat in favour of highly
structured, token-efficient formats,
[`report_ai()`](https://easystats.github.io/report/reference/report_ai.md)
bridges the gap between R and the context window, giving your AI
assistant exactly the information it needs in the most effective way
possible.

## Basic Usage

``` r

library(report)

m <- lm(mpg ~ wt + hp, data = mtcars)

# Human-readable report (default)
report(m)
#> We fitted a linear model (estimated using OLS) to predict mpg with wt and hp
#> (formula: mpg ~ wt + hp). The model explains a statistically significant and
#> substantial proportion of variance (R2 = 0.83, F(2, 29) = 69.21, p < .001, adj.
#> R2 = 0.81). The model's intercept, corresponding to wt = 0 and hp = 0, is at
#> 37.23 (95% CI [33.96, 40.50], t(29) = 23.28, p < .001). Within this model:
#> 
#>   - The effect of wt is statistically significant and negative (beta = -3.88, 95%
#> CI [-5.17, -2.58], t(29) = -6.13, p < .001; Std. beta = -0.63, 95% CI [-0.84,
#> -0.42])
#>   - The effect of hp is statistically significant and negative (beta = -0.03, 95%
#> CI [-0.05, -0.01], t(29) = -3.52, p = 0.001; Std. beta = -0.36, 95% CI [-0.57,
#> -0.15])
#> 
#> Standardized parameters were obtained by fitting the model on a standardized
#> version of the dataset. 95% Confidence Intervals (CIs) and p-values were
#> computed using a Wald t-distribution approximation.
```

``` r

# AI-optimized report
report(m, audience = "ai")
#> ## Model
#> - Call: lm
#> - Formula: mpg ~ wt + hp
#> - Family: gaussian
#> - N: 32
#> - Inference: 95% CI [Wald]
#> 
#> ## Variables
#> 
#> - mpg: Mean = 20.09, SD = 6.03, range: [10.40, 33.90]
#> - wt: Mean = 3.22, SD = 0.98, range: [1.51, 5.42]
#> - hp: Mean = 146.69, SD = 68.56, range: [52, 335]
#> 
#> ## Parameters
#> |Parameter   | Coefficient|       SE|        95% CI |t(29) |     p |
#> |:-----------|-----------:|--------:|:--------------|:-----|:------|
#> |(Intercept) |       37.23|     1.60|[33.96, 40.50] |23.28 |< .001 |
#> |wt          |       -3.88|     0.63|[-5.17, -2.58] |-6.13 |< .001 |
#> |hp          |       -0.03| 9.03e-03|[-0.05, -0.01] |-3.52 |0.001  |
#> 
#> ## Performance
#> |AIC   | AICc |  BIC |  R2 | R2 (adj.)|RMSE | Sigma|
#> |:-----|:-----|:-----|:----|---------:|:----|-----:|
#> |156.7 |158.1 |162.5 |0.83 |      0.81|2.47 |  2.59|
#> 
#> ## Highlights
#> - Significant effects (p < 0.05): wt, hp
```

The AI output is a single character vector of class `report_ai` that you
can pass directly to any LLM API, embed in a system prompt, or include
in a context window.

## Setting the Option Globally

For a single analysis session or a whole document you can flip **all**
[`report()`](https://easystats.github.io/report/reference/report.md)
calls at once with one option:

``` r

options(report_audience = "ai")

# Every subsequent report() call now returns an AI-optimized output
report(m)
report(lm(mpg ~ am, data = mtcars))
```

Reset to the default at any time:

``` r

options(report_audience = "humans")
```

## Converting a Quarto Document

If you have an existing Quarto (`.qmd`) or R Markdown (`.Rmd`) document
that already uses
[`report()`](https://easystats.github.io/report/reference/report.md)
throughout, converting it to produce AI-optimized output requires only
**one line** added to the `setup` chunk:

```` default
---
title: "My Analysis"
format: html
---

```{r setup, include=FALSE}
library(report)

# One line — all report() calls in this document become AI-optimised
options(report_audience = "ai")
```

```{r model}
m <- lm(mpg ~ wt + hp, data = mtcars)
report(m)   # automatically AI-optimised because of the global option
```
````

To make the option permanent across an entire Quarto project, add it to
the project-level `_quarto.yml` execute block or to your `.Rprofile`.
