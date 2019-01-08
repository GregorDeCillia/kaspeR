
<!-- icon: https://iconscout.com/icon/hot-soup-3 -->
kasper: another safety providing evaluator in R <img src="man/figures/logo.png" align="right" alt="" />
-------------------------------------------------------------------------------------------------------

[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) [![](https://img.shields.io/badge/language-R-blue.svg)](https://cran.r-project.org/) [![](https://img.shields.io/badge/devel%20version-0.1.0-red.svg)](https://github.com/GregorDeCillia/kasper) [![](https://img.shields.io/github/languages/code-size/GregorDeCillia/kasper.svg)](https://github.com/GregorDeCillia/kasper)

This package allows to safely evaluate strings in R using something more sophisticated than

``` r
code <- "x <- 1"
eval(parse(text = code))
```

by applying a whitelisting logic. The "whitelist" contains safe commands which won't be able to hurt your system when the `code` is sent by a client.

### Installation

``` r
## install from github
devtools::install_github("GregorDeCillia/kasper")
```

### Usage

Create a new evaluator with the `new()` method.

``` r
library(kasper)
myEvaluator <- evaluator$new()
```

Evaluate strings with the `eval()` method.

``` r
myEvaluator$eval("
x <- 1
x <- x + 1
x
x - 1
")
```

No outputs? Don't worry they are all captured in the `myEvaluator` object.

``` r
myEvaluator$replay()
```

    ## > 
    ## > x <- 1
    ## > x <- x + 1
    ## > x
    ## [1] 2
    ## > x - 1
    ## [1] 1

### Error handling

Errors are just part of the output for the repay function. They will not interrupt the evaluation.

``` r
myEvaluator$eval("
y
2 + 2
")
myEvaluator$replay()
```

    ## > 
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
myEvaluator$getWhiteList()
```

    ##  [1] "%/%"          ":"            "log"          "%%"          
    ##  [5] "<"            "logical"      "tanh"         "log10"       
    ##  [9] ">"            "[["           "tan"          "sinh"        
    ## [13] "cumsum"       "{"            "log2"         "abs"         
    ## [17] "acos"         "=="           "ceiling"      "character"   
    ## [21] "tanpi"        "log1p"        "atanh"        "data.frame"  
    ## [25] "numeric"      "exp"          "asin"         "sign"        
    ## [29] "function"     "asinh"        "sinpi"        "ls"          
    ## [33] "!="           "digamma"      "sqrt"         "cumprod"     
    ## [37] "trigamma"     "subset"       ">="           "floor"       
    ## [41] "lgamma"       "atan"         "[.data.frame" "["           
    ## [45] "trunc"        "<-"           "^"            "("           
    ## [49] "list"         "*"            "cosh"         "c"           
    ## [53] "+"            "-"            "cummax"       "cos"         
    ## [57] "/"            "expm1"        "cummin"       "integer"     
    ## [61] "letters"      "cospi"        "sin"          "LETTERS"     
    ## [65] "acosh"        "<="           "gamma"        "print"

### dplyr

The evaluator can add minimal support for `dplyr` operations by setting the `dplyr` flag to `TRUE` after loading the package

``` r
library(dplyr)
```

``` r
myEvaluator <- evaluator$new(dplyr = TRUE)
myEvaluator$eval("data.frame(a = 1:4, b = letters[1:4]) %>% filter(a < 3)")
myEvaluator$replay()
```

    ## > data.frame(a = 1:4, b = letters[1:4]) %>% filter(a < 3)
    ##   a b
    ## 1 1 a
    ## 2 2 b
