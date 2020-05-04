
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- README.md is generated from README.Rmd. Please edit that file -->

# cbsodata4

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/cbsodata4)](https://cran.r-project.org/package=cbsodata4)
[![Travis build
status](https://travis-ci.org/statistiekcbs/cbsodata4.svg?branch=master)](https://travis-ci.org/statistiekcbs/cbsodata4)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/statistiekcbs/cbsodata4?branch=master&svg=true)](https://ci.appveyor.com/project/edwindj/cbsodata4)

<!-- badges: end -->

The goal of cbsodata4 is allowing access to the Open Data API v4 of
Statistics Netherlands.

## Installation

You can install the released version of cbsccb from
[CRAN](https://CRAN.R-project.org) with:

<!--
```r
install.packages("cbsodata4")
```
!-->

At the moment only a development version can be installed from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("statistiekcbs/cbsodata4")
```

## Example

``` r
library(cbsodata4)

# download the set of datasets
datasets <- cbs4_get_datasets()
datasets$Title[1:6]
#> [1] "Bevolkingsontwikkeling; regio per maand"                              
#> [2] "Bouwnijverheid; productieve uren in de burgerlijke en utiliteitsbouw" 
#> [3] "Regionale kerncijfers Nederland"                                      
#> [4] "Akkerbouwgewassen; productie naar regio"                              
#> [5] "Melkaanvoer en zuivelproductie door zuivelfabrieken"                  
#> [6] "Ziekteverzuimpercentage; bedrijfstakken (SBI 2008) en bedrijfsgrootte"
```
