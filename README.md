
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


# filter on Perioden (see meta$PeriodenCodes)
cbs4_get_data("84287NED"
             , Perioden = "2019MM12" # december 2019
             )
#>   Perioden BedrijfstakkenBranchesSBI2008 Vacature-indicator
#> 1 2019MM12                        300007               0.23
#> 2 2019MM12                        307500               0.07
#> 3 2019MM12                        350000               0.22
#> 4 2019MM12                       T001081               0.21

# filter on multiple Perioden (see meta$PeriodenCodes)
cbs4_get_data("84287NED"
             , Perioden = c("2019MM12", "2020MM01") # december 2019, january 2020
             )
#>   Perioden BedrijfstakkenBranchesSBI2008 Vacature-indicator
#> 1 2019MM12                        300007               0.23
#> 2 2019MM12                        307500               0.07
#> 3 2019MM12                        350000               0.22
#> 4 2019MM12                       T001081               0.21
#> 5 2020MM01                        300007               0.21
#> 6 2020MM01                        307500               0.05
#> 7 2020MM01                        350000               0.15
#> 8 2020MM01                       T001081               0.19

# to filter on a dimension just add the filter to the query

# filter on Perioden (see meta$PeriodenCodes)
cbs4_get_data("84287NED"
             , Perioden = "2019MM12" # december 2019
             , BedrijfstakkenBranchesSBI2008 = "T001081"
             )
#>   Perioden BedrijfstakkenBranchesSBI2008 Vacature-indicator
#> 1 2019MM12                       T001081               0.21


# filter on Perioden with contains
cbs4_get_data("84287NED"
              , Perioden = contains("2020")
              , BedrijfstakkenBranchesSBI2008 = "T001081"
)
#>   Perioden BedrijfstakkenBranchesSBI2008 Vacature-indicator
#> 1 2020MM01                       T001081               0.19
#> 2 2020MM02                       T001081               0.15
#> 3 2020MM03                       T001081               0.09

# filter on Perioden with multiple contains
cbs4_get_data("84287NED"
              , Perioden = contains(c("2019MM1", "2020"))
              , BedrijfstakkenBranchesSBI2008 = "T001081"
)
#>   Perioden BedrijfstakkenBranchesSBI2008 Vacature-indicator
#> 1 2019MM10                       T001081               0.24
#> 2 2019MM11                       T001081               0.23
#> 3 2019MM12                       T001081               0.21
#> 4 2020MM01                       T001081               0.19
#> 5 2020MM02                       T001081               0.15
#> 6 2020MM03                       T001081               0.09

# filter on Perioden with contains or = "2019MM12
cbs4_get_data("84287NED"
              , Perioden = contains("2020") | "2019MM12"
              , BedrijfstakkenBranchesSBI2008 = "T001081"
)
#>   Perioden BedrijfstakkenBranchesSBI2008 Vacature-indicator
#> 1 2019MM12                       T001081               0.21
#> 2 2020MM01                       T001081               0.19
#> 3 2020MM02                       T001081               0.15
#> 4 2020MM03                       T001081               0.09

# This all works on observations too
cbs4_get_observations( id        = "80784ned"    # table id
                     , Perioden  = "2019JJ00"    # Year 2019
                     , Geslacht  = "1100"        # code for total gender
                     , RegioS    = contains("PV")
                     , Measure   = "M003371_2"
                     )
#>      Id   Measure ValueAttribute Value Geslacht Perioden RegioS
#> 1  3213 M003371_2           None  7988     1100 2019JJ00   PV20
#> 2  3753 M003371_2           None 12734     1100 2019JJ00   PV21
#> 3  4293 M003371_2           None  8378     1100 2019JJ00   PV22
#> 4  4833 M003371_2           None 19339     1100 2019JJ00   PV23
#> 5  5373 M003371_2           None  5759     1100 2019JJ00   PV24
#> 6  5913 M003371_2           None 27455     1100 2019JJ00   PV25
#> 7  6453 M003371_2           None  7123     1100 2019JJ00   PV26
#> 8  6993 M003371_2           None 15868     1100 2019JJ00   PV27
#> 9  7533 M003371_2           None 23615     1100 2019JJ00   PV28
#> 10 8073 M003371_2           None  8313     1100 2019JJ00   PV29
#> 11 8613 M003371_2           None 30685     1100 2019JJ00   PV30
#> 12 9153 M003371_2           None 13114     1100 2019JJ00   PV31
```
