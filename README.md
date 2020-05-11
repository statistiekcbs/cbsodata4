
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

  - It uses the new / more efficient OData4 API

  - The function names for `cbs4_add_*` are more consistent.

  - The download storage is faster (using `data.table`)

  - It offers a familiar wide data formate for users (`cbs4_get_data`)
    as well as the default long format (`cbs4_get_observations`).

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

Retrieve a list of all CBS / Statistics Netherlands tables with
`cbs4_get_datasets`:

``` r
# download the set of datasets
datasets <- cbs4_get_datasets()
datasets[1:5, c("Identifier", "Title")]
```

<div class="kable-table">

| Identifier | Title                                                                |
| :--------- | :------------------------------------------------------------------- |
| 37230ned   | Bevolkingsontwikkeling; regio per maand                              |
| 60006      | Bouwnijverheid; productieve uren in de burgerlijke en utiliteitsbouw |
| 70072ned   | Regionale kerncijfers Nederland                                      |
| 7100oogs   | Akkerbouwgewassen; productie naar regio                              |
| 7425zuiv   | Melkaanvoer en zuivelproductie door zuivelfabrieken                  |

</div>

Get metadata of table `<Identifier>` (e.g. 60006) with
`cbs4_get_metadata`:

``` r
meta <- cbs4_get_metadata(id="60006")
meta$Properties$Title
#> [1] "Bouwnijverheid; productieve uren in de burgerlijke en utiliteitsbouw"
# topics / measures
meta$MeasureCodes[,c("Identifier", "Title")]
```

<div class="kable-table">

| Identifier | Title                        |
| :--------- | :--------------------------- |
| M003026    | Theoretisch beschikbare uren |
| M002994\_2 | Totaal niet-productieve uren |
| M003031    | Vorst- en neerslagverlet     |
| M003013    | Overig                       |
| M003019    | Productieve uren             |

</div>

``` r
# dimensions
meta$Dimensions[, c("Identifier", "Title")]
```

<div class="kable-table">

| Identifier | Title    |
| :--------- | :------- |
| Perioden   | Perioden |

</div>

Retrieve data with `cbs4_get_data`:

``` r
# wide format, each measure its own column
data <- cbs4_get_data("60006")
head(data[, 1:4])
```

<div class="kable-table">

| Perioden | Totaal niet-productieve uren | Overig | Productieve uren |
| :------- | ---------------------------: | -----: | ---------------: |
| 1990JJ00 |                          695 |    645 |             1390 |
| 1990KW01 |                          155 |    135 |              365 |
| 1990KW02 |                          130 |    125 |              390 |
| 1990KW03 |                          250 |    240 |              270 |
| 1990KW04 |                          160 |    145 |              370 |
| 1991JJ00 |                          780 |    665 |             1305 |

</div>

or `cbs4_get_observations`

``` r
# long format, one Value column
obs <- cbs4_get_observations("60006")
head(obs)
```

<div class="kable-table">

| Id | Measure    | ValueAttribute | Value | Perioden |
| -: | :--------- | :------------- | ----: | :------- |
|  0 | M003026    | None           |   520 | 1990KW01 |
|  1 | M002994\_2 | None           |   155 | 1990KW01 |
|  2 | M003031    | None           |    20 | 1990KW01 |
|  3 | M003013    | None           |   135 | 1990KW01 |
|  4 | M003019    | None           |   365 | 1990KW01 |
|  5 | M003026    | None           |   520 | 1990KW02 |

</div>

Add labels to a dataset with `cbs4_add_label_columns`:

``` r
data <- cbs4_add_label_columns(data)
head(data[,1:5])
```

<div class="kable-table">

| Perioden | PeriodenLabel    | Totaal niet-productieve uren | Overig | Productieve uren |
| :------- | :--------------- | ---------------------------: | -----: | ---------------: |
| 1990JJ00 | 1990             |                          695 |    645 |             1390 |
| 1990KW01 | 1990 1e kwartaal |                          155 |    135 |              365 |
| 1990KW02 | 1990 2e kwartaal |                          130 |    125 |              390 |
| 1990KW03 | 1990 3e kwartaal |                          250 |    240 |              270 |
| 1990KW04 | 1990 4e kwartaal |                          160 |    145 |              370 |
| 1991JJ00 | 1991             |                          780 |    665 |             1305 |

</div>

``` r

obs <- cbs4_add_label_columns(obs)
head(obs)
```

<div class="kable-table">

| Id | Measure    | MeasureLabel                 | ValueAttribute | Value | Perioden | PeriodenLabel    |
| -: | :--------- | :--------------------------- | :------------- | ----: | :------- | :--------------- |
|  0 | M003026    | Theoretisch beschikbare uren | None           |   520 | 1990KW01 | 1990 1e kwartaal |
|  1 | M002994\_2 | Totaal niet-productieve uren | None           |   155 | 1990KW01 | 1990 1e kwartaal |
|  2 | M003031    | Vorst- en neerslagverlet     | None           |    20 | 1990KW01 | 1990 1e kwartaal |
|  3 | M003013    | Overig                       | None           |   135 | 1990KW01 | 1990 1e kwartaal |
|  4 | M003019    | Productieve uren             | None           |   365 | 1990KW01 | 1990 1e kwartaal |
|  5 | M003026    | Theoretisch beschikbare uren | None           |   520 | 1990KW02 | 1990 2e kwartaal |

</div>

Find non-standard CBS catalogs with `cbs4_get_catalogs`:

``` r
catalogs <- cbs4_get_catalogs()
catalogs[,c("Identifier", "Title")]
```

<div class="kable-table">

| Identifier | Title                 |
| :--------- | :-------------------- |
| CBS        | CBS databank StatLine |
| CBS-asd    | CBS aanvullend        |

</div>

For more information see `vignette("cbsodata4")`
