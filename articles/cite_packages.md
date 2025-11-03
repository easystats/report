# Report and Cite Packages

**Citing the packages, modules and software** you used for your analysis
is important to acknowledge the time and effort spent by people who
create theses tools (sometimes in their free-time, or at the expense of
their own research), but also for **reproducibility**. Indeed,
statistical routines are often implemented in different ways by
different packages, which can lead to possible discrepancies in the
results. Explicitly mentioning that *“I did this using this function
from that package version 1.2.3”* is a way of **protecting yourself** by
being transparent about what you have found doing what you have done.

But, understandably, you must have a lot of questions-

> **That’s great, but how to *actually* cite them?**

> **I used about 100 packages, should I cite them *all*?**

> **How should I report the system (the OS, the R version, etc.)?**

We attempt to answer these questions below :)

## What should I cite?

Ideally, you should indeed cite all the packages that you used. However,
it’s often not possible to cite them all in the manuscript body.
Therefore, we would recommend the following guidelines:

### 1. Cite the main/important packages in the manuscript

This should be done for the packages that were central to your specific
study (*i.e.,* that got you the results that you reported) rather than
data manipulation tools (even though these are as much, if not *more*,
important). For example:

> Statistical analysis were carried out using R 4.1.0 (R Core Team,
> 2021), the *rstanarm* (*v2.13.1*; Gabry & Goodrich, 2016) and the
> *report* (*v0.2.0*; Makowski, Patil, & Lüdecke, 2019) packages. The
> full reproducible code is available in **Supplementary Materials**.

### 2. Present everything in Supplementary Materials

Then, in *Supplementary Materials*, you can show all the packages and
functions you used. To do it quickly, explicitly and in a reproducible
fashion, we recommend writing the *Supplementary Materials* with [**R
Markdown**](https://rmarkdown.rstudio.com/), which can generate *docs*
and *pdf* files that you can submit along with your manuscript.
Moreover, if you’re using R, you can include (usually at the end) every
used package’s citation using the
[`cite_packages()`](https://easystats.github.io/report/reference/report.sessionInfo.md)
function from the [**report**](https://github.com/easystats/report)
package. For example:

``` r

library(report)

cite_packages()
```

- Makowski D, Lüdecke D, Patil I, Thériault R, Ben-Shachar M, Wiernik B
  (2023). “Automated Results Reporting as a Practical Tool to Improve
  Reproducibility and Methodological Best Practices Adoption.” *CRAN*.
  <doi:10.32614/CRAN.package.report>
  <https://doi.org/10.32614/CRAN.package.report>,
  <https://easystats.github.io/report/>.
- R Core Team (2025). *R: A Language and Environment for Statistical
  Computing*. R Foundation for Statistical Computing, Vienna, Austria.
  <https://www.R-project.org/>.

## Where

Finding the right citation information is sometimes complicated. In `R`,
this process is made quite easy, you simply run
`citation("packagename")`. For instance, `citation("bayestestR")`:

    To cite bayestestR in publications use:

      Makowski, D., Ben-Shachar, M., \& Lüdecke, D. (2019). bayestestR:
      Describing Effects and their Uncertainty, Existence and Significance
      within the Bayesian Framework. Journal of Open Source Software,
      4(40), 1541. doi:10.21105/joss.01541

    A BibTeX entry for LaTeX users is

      @Article{,
        title = {bayestestR: Describing Effects and their Uncertainty, Existence and Significance within the Bayesian Framework.},
        author = {Dominique Makowski and Mattan S. Ben-Shachar and Daniel Lüdecke},
        journal = {Journal of Open Source Software},
        doi = {10.21105/joss.01541},
        year = {2019},
        number = {40},
        volume = {4},
        pages = {1541},
        url = {https://joss.theoj.org/papers/10.21105/joss.01541},
      }

For other languages, such as `Python` or `Julia`, it might be a little
trickier, but a quick search on Google (or github) should provide you
with all the necessary information (version, authors and date).

**Keep in mind that it’s better to have a slightly incomplete citation
than no citation at all.**

## cite_easystats()

If you want to cite the **easystats** ecosystem, you can use the
[`cite_easystats()`](https://easystats.github.io/report/reference/cite_easystats.html)
function:

``` r

cite_easystats()
```

Thanks for crediting us! 😀 You can cite the easystats ecosystem as
follows:

## Citations

Analyses were conducted using the *easystats* collection of packages
(Lüdecke et al., 2019/2023).

## References

- Lüdecke, D., Makowski, D., Ben-Shachar, M. S., Patil, I., Wiernik, B.
  M., Bacher, Etienne, & Thériault, R. (2023). easystats: Streamline
  model interpretation, visualization, and reporting \[R package\].
  <https://easystats.github.io/easystats/> (Original work published
  2019)
