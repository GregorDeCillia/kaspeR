# kasper 0.2.0

- `export create_safe_environment()`
- add `roxygen` documentation
- capture plots
    - minimal `ggplot` support
- capture errors and warnings
- set up unit tests

# kasper 0.1.0

- `devtools::check()` via AppVeyor
- safe evaluation via an enclosed environment:
  [concept from Hadley Wickham](https://stackoverflow.com/a/18391779/4357017)
    - `dplyr` support
- set up travis-CI
    - `devtools::check()` 
    - `devtools::lint()`
    - `pkgdown::deploy_site_github()`
    - `covr::package_coverage()`
