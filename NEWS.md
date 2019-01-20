# kasper 0.2.0

- `export create_safe_environment()`
- add roxygen documentation
- capture plots
    - minimal ggplot support
- capture errors and warnings
- set up unit tests

# kasper 0.1.0

- devtools::check() via appveyor
- safe evaluation via an enclosed environment: [concept from hadley](https://stackoverflow.com/questions/18369913/safely-evaluating-arithmetic-expressions-in-r/18391779#18391779)
    - dplyr support
- set up travis-CI
    - `devtools::check()` 
    - `devtools::lint()`
    - `pkgdown::deploy_site()`
    - `covr::package_coverage()`
