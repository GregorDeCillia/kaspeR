
<!-- icon: https://iconscout.com/icon/hot-soup-3 -->
kasper: another safety providing evaluator in R <img src="man/figures/logo.png" align="right" alt="" />
-------------------------------------------------------------------------------------------------------

[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) [![](https://img.shields.io/badge/language-R-blue.svg)](https://cran.r-project.org/) [![](https://img.shields.io/badge/devel%20version-0.1.0-red.svg)](https://github.com/GregorDeCillia/kasper) [![](https://img.shields.io/github/languages/code-size/GregorDeCillia/kasper.svg)](https://github.com/GregorDeCillia/kasper)

This package allows to safely evaluate strings in R using something more sophisticated than

``` r
code <- "x <- 1"
eval(parse(text = code))
```

by applying a whitelisting logic. The "whitelist" contains safe commands which won't be able to hurt your system when the `code` is sent by a client. This package was developed for usage in a shiny web application that aims to give users access to an editor where they can execute R scripts on a server. In order to secure the server, this package is supposed to be used in the future.

### Installation

``` r
## install from github
devtools::install_github("GregorDeCillia/kasper")
```

### Usage

Create a new evaluator with `evaluator$new()`. This will initialize a new evaluator object.

``` r
library(kasper)
myEvaluator <- evaluator$new()
```

The evaluator object has a method `eval()`, which evaluates R code passed as a string or as an expression.

``` r
myEvaluator$eval({
  x <- 1; x <- x + 1; x; x - 1
})
```

There are no outputs? Don't worry they are all captured in the `myEvaluator` object and can be retrieved with `replay()`. The method is named after the underlying function `evaluate::replay` which was developed by the `r-lib` organization.

``` r
myEvaluator$replay()
```

    ## > x <- 1
    ## > x <- x + 1
    ## > x
    ## [1] 2
    ## > x - 1
    ## [1] 1

If your R code contains any errors, error messages will be returned by the `replay()` method. This does not interrupt the evaluation.

### Error handling

Errors are just part of the output for the `replay()` function. They will not interrupt the evaluation.

``` r
myEvaluator$eval({ y; 2 + 2 })
myEvaluator$replay()
```

    ## > y

    ## Error in eval(expr, envir, enclos): object 'y' not found

    ## > 2 + 2
    ## [1] 4

### The whitelist

An error also occurs if the user try to perform anything that is not whitelisted. Functions like `system()` are not available and trated as though they do not exist.

``` r
myEvaluator$eval("system('mkdir testdir')")
myEvaluator$replay()
```

    ## > system('mkdir testdir')

    ## Error in system("mkdir testdir"): could not find function "system"

To display all whitelisted commands, use `getWhiteList()`.

``` r
head(myEvaluator$getWhiteList())
```

    ## [1] "%/%"     ":"       "log"     "%%"      "<"       "logical"

### dplyr

The evaluator can add minimal support for `dplyr` operations by setting the `dplyr` flag to `TRUE` after loading the package

``` r
library(dplyr)
```

``` r
myEvaluator <- evaluator$new(dplyr = TRUE)
myEvaluator$eval({
  data.frame(a = 1:4, b = letters[1:4]) %>% filter(a < 3)
})
myEvaluator$replay()
```

    ## > data.frame(a = 1:4, b = letters[1:4]) %>% filter(a < 3)
    ##   a b
    ## 1 1 a
    ## 2 2 b

### Similar projects

-   See <https://github.com/rapporter/sandboxR> for an evaluator that uses a blacklisting logic to safely evaluate R expressons.
-   See <https://github.com/jeroen/RAppArmor> for a package that relies on AppArmor to provide protection for Linux systems.
