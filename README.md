
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
Statistics Netherlands, which is in beta testing.

It will be the successor of R package
[cbsodataR](https://CRAN.R-project.org/package=cbsodataR).

## Installation

<!--

You can install the released version of cbsodata4 from [CRAN](https://CRAN.R-project.org) with:

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

## Usage

``` r
library(cbsodata4)
```

Retrieve a list of all CBS / Statistics Netherlands tables with:

``` r
# download the set of datasets
datasets <- cbs4_get_datasets()
datasets[1:5, c("Identifier", "Title")]
#>   Identifier
#> 1   37230ned
#> 2      60006
#> 3   70072ned
#> 4   7100oogs
#> 5   7425zuiv
#>                                                                  Title
#> 1                              Bevolkingsontwikkeling; regio per maand
#> 2 Bouwnijverheid; productieve uren in de burgerlijke en utiliteitsbouw
#> 3                                      Regionale kerncijfers Nederland
#> 4                              Akkerbouwgewassen; productie naar regio
#> 5                  Melkaanvoer en zuivelproductie door zuivelfabrieken
```

Get metadata of table `<Identifier>` (e.g. 60006) with:

``` r
meta <- cbs4_get_metadata(id="60006")
meta$Properties$Title
#> [1] "Bouwnijverheid; productieve uren in de burgerlijke en utiliteitsbouw"
# topics / measures
meta$MeasureCodes[,c("Identifier", "Title")]
#>   Identifier                        Title
#> 1    M003026 Theoretisch beschikbare uren
#> 2  M002994_2 Totaal niet-productieve uren
#> 3    M003031     Vorst- en neerslagverlet
#> 4    M003013                       Overig
#> 5    M003019             Productieve uren
# dimensions
meta$Dimensions[, c("Identifier", "Title")]
#>   Identifier    Title
#> 1   Perioden Perioden
```

Retrieve data with:

``` r
# wide format, each measure its own column
data <- cbs4_get_data("60006")
head(data[, 1:4])
#>   Perioden Totaal niet-productieve uren Overig Productieve uren
#> 1 1990JJ00                          695    645             1390
#> 2 1990KW01                          155    135              365
#> 3 1990KW02                          130    125              390
#> 4 1990KW03                          250    240              270
#> 5 1990KW04                          160    145              370
#> 6 1991JJ00                          780    665             1305
```

or

``` r
# long format, one Value column
obs <- cbs4_get_observations("60006")
head(obs)
#>   Id   Measure ValueAttribute Value Perioden
#> 1  0   M003026           None   520 1990KW01
#> 2  1 M002994_2           None   155 1990KW01
#> 3  2   M003031           None    20 1990KW01
#> 4  3   M003013           None   135 1990KW01
#> 5  4   M003019           None   365 1990KW01
#> 6  5   M003026           None   520 1990KW02
```

Add labels with:

``` r
data <- cbs4_add_labels(data)
head(data[,1:4])
#>   Perioden    PeriodenLabel Totaal niet-productieve uren Overig
#> 1 1990JJ00             1990                          695    645
#> 2 1990KW01 1990 1e kwartaal                          155    135
#> 3 1990KW02 1990 2e kwartaal                          130    125
#> 4 1990KW03 1990 3e kwartaal                          250    240
#> 5 1990KW04 1990 4e kwartaal                          160    145
#> 6 1991JJ00             1991                          780    665

obs <- cbs4_add_labels(obs)
head(obs)
#>   Id   Measure                 MeasureLabel ValueAttribute Value Perioden
#> 1  0   M003026 Theoretisch beschikbare uren           None   520 1990KW01
#> 2  1 M002994_2 Totaal niet-productieve uren           None   155 1990KW01
#> 3  2   M003031     Vorst- en neerslagverlet           None    20 1990KW01
#> 4  3   M003013                       Overig           None   135 1990KW01
#> 5  4   M003019             Productieve uren           None   365 1990KW01
#> 6  5   M003026 Theoretisch beschikbare uren           None   520 1990KW02
#>      PeriodenLabel
#> 1 1990 1e kwartaal
#> 2 1990 1e kwartaal
#> 3 1990 1e kwartaal
#> 4 1990 1e kwartaal
#> 5 1990 1e kwartaal
#> 6 1990 2e kwartaal
```

For more information see `vignette("cbsodata4")`

Find non-standard CBS catalogs with:

``` r
catalogs <- cbs4_get_catalogs()
catalogs[,c("Identifier", "Title")]
#>   Identifier                 Title
#> 1        CBS CBS databank StatLine
#> 2    CBS-asd        CBS aanvullend
```
