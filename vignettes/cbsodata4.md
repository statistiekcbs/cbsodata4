
[Statistics Netherlands (CBS)](https://www.cbs.nl) is the office that
produces all official statistics of the Netherlands.

For long SN has put its data on the web in its online database
[StatLine](https://opendata.cbs.nl/statline#/CBS/en/). Since 2014 this
data base has an open data web API based on the OData protocol and other
The [cbsodataR](https://CRAN.R-project.org/package=cbsodataR) package
allows for retrieving data right into R using this API.

A new version of the web api has been developed which is based on the
OData4 protocol. This OData4 API contains major changes in how the
metadata and data is transported, hence this package `cbsodata4`. Since
the old web api will be phased out in due time, `cbsodata4` is the
successor of `cbsodataR`.

This document describes how to use `cbsodata4` to download data (and
meta data) from Statistics Netherlands. It offers very similar functions
as `cbsodataR`, so should be familiar to users of `cbsodataR`, but there
are differences so check carefully your code.

``` r
library(cbsodata4)
```

## List of datasets (toc)

A list of datasets that are available can be loaded with with
`cbs4_get_datasets()` (`cbs4_get_toc()` is an alias)

``` r
datasets <- cbs4_get_datasets()
head(datasets[,c("Identifier", "Title", "Modified")])
```

<div class="kable-table">

| Identifier | Title                                                                 | Modified                  |
| :--------- | :-------------------------------------------------------------------- | :------------------------ |
| 37230ned   | Bevolkingsontwikkeling; regio per maand                               | 2020-04-29T02:00:00+02:00 |
| 60006      | Bouwnijverheid; productieve uren in de burgerlijke en utiliteitsbouw  | 2020-05-08T00:00:00+02:00 |
| 70072ned   | Regionale kerncijfers Nederland                                       | 2020-03-20T02:00:00+01:00 |
| 7100oogs   | Akkerbouwgewassen; productie naar regio                               | 2020-03-31T02:00:00+02:00 |
| 7425zuiv   | Melkaanvoer en zuivelproductie door zuivelfabrieken                   | 2020-04-15T02:00:00+02:00 |
| 80072ned   | Ziekteverzuimpercentage; bedrijfstakken (SBI 2008) en bedrijfsgrootte | 2020-03-16T02:00:00+01:00 |

</div>

Using an “Identifier” from `cbs4_get_datasets` information on the table
can be retrieved with `cbs4_get_metadata`

``` r
meta_petrol <- cbs4_get_metadata("80416ned")
meta_petrol
#> cbs odata: '80416ned':
#> "Pompprijzen motorbrandstoffen; brandstofsoort, per dag"
#> dimensions: Perioden
#> For more info use x$.
```

The meta object contains all metadata properties of cbsodata in the form
of `data.frame`s. Each `data.frame` describes properties of the SN
table: “Dimensions”, “MeasureCodes” and one ore more
“\<Dimension\>Codes” describing the meta data of the borders of a SN
table.

``` r
names(meta_petrol)
#> [1] "Dimensions"     "MeasureCodes"   "PeriodenGroups" "PeriodenCodes"  "Properties"
meta_petrol$MeasureCodes[, 1:3]
```

<div class="kable-table">

| Identifier | Index | Title          |
| :--------- | ----: | :------------- |
| E006512    |     1 | Benzine Euro95 |
| E006528    |     2 | Diesel         |
| E006498    |     3 | LPG            |

</div>

``` r
meta_petrol$Dimensions
```

<div class="kable-table">

| Identifier | Title    | Description | Kind          | MapYear | ReleasePolicy |
| :--------- | :------- | :---------- | :------------ | :------ | :------------ |
| Perioden   | Perioden |             | TimeDimension | NA      | False         |

</div>

``` r
# just 1 dimension with the following categories:
head(meta_petrol$PeriodenCodes)
```

<div class="kable-table">

| Identifier | Index | Title                    | Description | DimensionGroupId | Status |
| :--------- | ----: | :----------------------- | :---------- | :--------------- | :----- |
| 20060101   |     1 | 2006 zondag 1 januari    |             | 0                | NA     |
| 20060102   |     2 | 2006 maandag 2 januari   |             | 0                | NA     |
| 20060103   |     3 | 2006 dinsdag 3 januari   |             | 0                | NA     |
| 20060104   |     4 | 2006 woensdag 4 januari  |             | 0                | NA     |
| 20060105   |     5 | 2006 donderdag 5 januari |             | 0                | NA     |
| 20060106   |     6 | 2006 vrijdag 6 januari   |             | 0                | NA     |

</div>

## Data retrieval

With `cbs4_get_observations` and `cbs4_get_data` data can be retrieved.
By default this will be downloaded in a temporary directory, but this
can be set explicitly with the argument `output_dir`.

`cbs4_get_observations` is the format in which the data is downloaded
from SN. It is in so-called long format. It contains one `Measure`
column, describing the topics/variable, one `Value` column describing
the statistical value, one or more Dimension columns and some extra
columns with value specific metadata.

``` r
obs <- cbs4_get_observations("80416ned")
#>   |                                                                                                        |                                                                                                |   0%  |                                                                                                        |================================================================================================| 100%
head(obs)
```

<div class="kable-table">

| Id | Measure | ValueAttribute | Value | Perioden |
| -: | :------ | :------------- | ----: | -------: |
|  0 | E006512 | None           | 1.325 | 20060101 |
|  1 | E006528 | None           | 1.003 | 20060101 |
|  2 | E006498 | None           | 0.543 | 20060101 |
|  3 | E006512 | None           | 1.328 | 20060102 |
|  4 | E006528 | None           | 1.007 | 20060102 |
|  5 | E006498 | None           | 0.542 | 20060102 |

</div>

`cbs4_get_data` returns the data in so-called wide format in which each
`Measure` has its own column. For many uses this is a more natural
format. It is a pivoted version of `cbs4_get_observations()`.

``` r
# same 
data <- cbs4_get_data("80416ned")
#>   |                                                                                                        |                                                                                                |   0%  |                                                                                                        |================================================================================================| 100%
head(data)
```

<div class="kable-table">

| Perioden |   LPG | Benzine Euro95 | Diesel |
| -------: | ----: | -------------: | -----: |
| 20060101 | 0.543 |          1.325 |  1.003 |
| 20060102 | 0.542 |          1.328 |  1.007 |
| 20060103 | 0.540 |          1.332 |  1.007 |
| 20060104 | 0.550 |          1.348 |  1.020 |
| 20060105 | 0.550 |          1.347 |  1.021 |
| 20060106 | 0.549 |          1.353 |  1.023 |

</div>

### adding category label columns

The Dimension and Measure columns use codes/keys/identifiers to describe
categories. These can be found in the metadata, but can also be
automatically added using `cbs4_add_label_columns`.

``` r
obs <- cbs4_get_observations("80416ned")
#>   |                                                                                                        |                                                                                                |   0%  |                                                                                                        |================================================================================================| 100%
obs <- cbs4_add_label_columns(obs)
head(obs)
```

<div class="kable-table">

| Id | Measure | MeasureLabel   | ValueAttribute | Value | Perioden | PeriodenLabel          |
| -: | :------ | :------------- | :------------- | ----: | -------: | :--------------------- |
|  0 | E006512 | Benzine Euro95 | None           | 1.325 | 20060101 | 2006 zondag 1 januari  |
|  1 | E006528 | Diesel         | None           | 1.003 | 20060101 | 2006 zondag 1 januari  |
|  2 | E006498 | LPG            | None           | 0.543 | 20060101 | 2006 zondag 1 januari  |
|  3 | E006512 | Benzine Euro95 | None           | 1.328 | 20060102 | 2006 maandag 2 januari |
|  4 | E006528 | Diesel         | None           | 1.007 | 20060102 | 2006 maandag 2 januari |
|  5 | E006498 | LPG            | None           | 0.542 | 20060102 | 2006 maandag 2 januari |

</div>

or

``` r
data <- cbs4_get_data("80416ned")
#>   |                                                                                                        |                                                                                                |   0%  |                                                                                                        |================================================================================================| 100%
data <- cbs4_add_label_columns(data)
head(data)
```

<div class="kable-table">

| Perioden | PeriodenLabel            |   LPG | Benzine Euro95 | Diesel |
| -------: | :----------------------- | ----: | -------------: | -----: |
| 20060101 | 2006 zondag 1 januari    | 0.543 |          1.325 |  1.003 |
| 20060102 | 2006 maandag 2 januari   | 0.542 |          1.328 |  1.007 |
| 20060103 | 2006 dinsdag 3 januari   | 0.540 |          1.332 |  1.007 |
| 20060104 | 2006 woensdag 4 januari  | 0.550 |          1.348 |  1.020 |
| 20060105 | 2006 donderdag 5 januari | 0.550 |          1.347 |  1.021 |
| 20060106 | 2006 vrijdag 6 januari   | 0.549 |          1.353 |  1.023 |

</div>

### Adding Date column

The period/time columns of Statistics Netherlands (CBS) contain coded
time periods: e.g. 2018JJ00 (i.e. 2018), 2018KW03 (i.e. 2018 Q3),
2016MM04 (i.e. 2016 April). With `cbs4_add_date_column` the time periods
will be converted and added to the data:

``` r
obs <- cbs4_get_observations("80416ned")
#>   |                                                                                                        |                                                                                                |   0%  |                                                                                                        |================================================================================================| 100%
obs <- cbs4_add_date_column(obs)
head(obs)
```

<div class="kable-table">

| Id | Measure | ValueAttribute | Value | Perioden | Perioden\_Date | Perioden\_freq |
| -: | :------ | :------------- | ----: | -------: | :------------- | :------------- |
|  0 | E006512 | None           | 1.325 | 20060101 | 2006-01-01     | D              |
|  1 | E006528 | None           | 1.003 | 20060101 | 2006-01-01     | D              |
|  2 | E006498 | None           | 0.543 | 20060101 | 2006-01-01     | D              |
|  3 | E006512 | None           | 1.328 | 20060102 | 2006-01-02     | D              |
|  4 | E006528 | None           | 1.007 | 20060102 | 2006-01-02     | D              |
|  5 | E006498 | None           | 0.542 | 20060102 | 2006-01-02     | D              |

</div>

``` r

data <- cbs4_get_data("80416ned")
#>   |                                                                                                        |                                                                                                |   0%  |                                                                                                        |================================================================================================| 100%
data <- cbs4_add_date_column(data)
head(data)
```

<div class="kable-table">

| Perioden | Perioden\_Date | Perioden\_freq |   LPG | Benzine Euro95 | Diesel |
| -------: | :------------- | :------------- | ----: | -------------: | -----: |
| 20060101 | 2006-01-01     | D              | 0.543 |          1.325 |  1.003 |
| 20060102 | 2006-01-02     | D              | 0.542 |          1.328 |  1.007 |
| 20060103 | 2006-01-03     | D              | 0.540 |          1.332 |  1.007 |
| 20060104 | 2006-01-04     | D              | 0.550 |          1.348 |  1.020 |
| 20060105 | 2006-01-05     | D              | 0.550 |          1.347 |  1.021 |
| 20060106 | 2006-01-06     | D              | 0.549 |          1.353 |  1.023 |

</div>

### Adding a Unit column

Each `Measure` has a measure unit, which can be added to observations
with `cbs4_add_unit_column()`

``` r
obs <- cbs4_get_observations("80416ned")
#>   |                                                                                                        |                                                                                                |   0%  |                                                                                                        |================================================================================================| 100%
obs <- cbs4_add_unit_column(obs)
head(obs)
```

<div class="kable-table">

| Id | Measure | ValueAttribute | Value | Unit       |
| -: | :------ | :------------- | ----: | :--------- |
|  0 | E006512 | None           | 1.325 | euro/liter |
|  1 | E006528 | None           | 1.003 | euro/liter |
|  2 | E006498 | None           | 0.543 | euro/liter |
|  3 | E006512 | None           | 1.328 | euro/liter |
|  4 | E006528 | None           | 1.007 | euro/liter |
|  5 | E006498 | None           | 0.542 | euro/liter |

</div>

## Select and filter

It is possible restrict the download using filter statements. This may
shorten the download time considerably.

### Filter

Filter statements for the columns can be used to restrict the download.
Note the following:

  - To filter you will need to use the values found in the `Identifier`
    column in the `cbs4_get_metadata` objects. e.g. for year 2020, the
    code is “2020JJ00”.

<!-- end list -->

``` r
meta <- cbs4_get_metadata("60006")
tail(meta$PeriodenCodes)
```

<div class="kable-table">

|     | Identifier | Index | Title            | Description        | DimensionGroupId | Status     |
| --- | :--------- | ----: | :--------------- | :----------------- | :--------------- | :--------- |
| 146 | 2019KW01   |   146 | 2019 1e kwartaal |                    | 0                | Definitief |
| 147 | 2019KW02   |   147 | 2019 2e kwartaal | Voorlopige cijfers | 0                | Voorlopig  |
| 148 | 2019KW03   |   148 | 2019 3e kwartaal | Voorlopige cijfers | 0                | Voorlopig  |
| 149 | 2019KW04   |   149 | 2019 4e kwartaal | Voorlopige cijfers | 0                | Voorlopig  |
| 150 | 2019JJ00   |   150 | 2019             | Voorlopige cijfers | 1                | Voorlopig  |
| 151 | 2020KW01   |   151 | 2020 1e kwartaal | Voorlopige cijfers | 0                | Voorlopig  |

</div>

``` r
meta$MeasureCodes[,c("Identifier","Title")]
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

  - To filter for values in a column add `<column_name> = values` to
    `cbs4_get_observations` (or `cbs4_get_data`) e.g. `Perioden =
    c("2019KW04", "2020KW01")`

<!-- end list -->

``` r
obs <- cbs4_get_observations("60006"
                            , Measure = c("M003026","M003019")     # selection on Measures
                            , Perioden = c("2019KW04", "2020KW01") # selection on Perioden
                            )
#>   |                                                                                                        |                                                                                                |   0%  |                                                                                                        |=                                                                                               |   1%  |                                                                                                        |================================================================================================| 100%
cbs4_add_label_columns(obs)
```

<div class="kable-table">

|  Id | Measure | MeasureLabel                 | ValueAttribute | Value | Perioden | PeriodenLabel    |
| --: | :------ | :--------------------------- | :------------- | ----: | :------- | :--------------- |
| 740 | M003026 | Theoretisch beschikbare uren | None           |   530 | 2019KW04 | 2019 4e kwartaal |
| 744 | M003019 | Productieve uren             | None           |   370 | 2019KW04 | 2019 4e kwartaal |
| 750 | M003026 | Theoretisch beschikbare uren | None           |   520 | 2020KW01 | 2020 1e kwartaal |
| 754 | M003019 | Productieve uren             | None           |   405 | 2020KW01 | 2020 1e kwartaal |

</div>

  - To filter for values in a column that have a substring e.g. “JJ” you
    can use `<column_name> = contains(<substring>)` to `cbs4_get_data`
    e.g.  `Perioden = contains("JJ")`

<!-- end list -->

``` r
data <- cbs4_get_data("60006"
                     , Measure = c("M003026","M003019")     # selection on Measures
                     , Perioden = contains("2019") # retrieve all periods with 2019
                     )
#>   |                                                                                                        |                                                                                                |   0%  |                                                                                                        |=                                                                                               |   1%  |                                                                                                        |================================================================================================| 100%
data
```

<div class="kable-table">

| Perioden | Productieve uren | Theoretisch beschikbare uren |
| :------- | ---------------: | ---------------------------: |
| 2019JJ00 |             1475 |                         2090 |
| 2019KW01 |              375 |                          510 |
| 2019KW02 |              415 |                          520 |
| 2019KW03 |              320 |                          530 |
| 2019KW04 |              370 |                          530 |

</div>

  - To combine values and substring use the “|” operator: `Periods =
    contains("2019") | "2020KW01"`

<!-- end list -->

``` r
data <- cbs4_get_data("60006"
                     , Measure = c("M003026","M003019")         # selection on Measures
                     , Perioden = contains("2019") | "2020KW01" # retrieve all periods with 2019
                     )
#>   |                                                                                                        |                                                                                                |   0%  |                                                                                                        |==                                                                                              |   2%  |                                                                                                        |================================================================================================| 100%
data
```

<div class="kable-table">

| Perioden | Productieve uren | Theoretisch beschikbare uren |
| :------- | ---------------: | ---------------------------: |
| 2019JJ00 |             1475 |                         2090 |
| 2019KW01 |              375 |                          510 |
| 2019KW02 |              415 |                          520 |
| 2019KW03 |              320 |                          530 |
| 2019KW04 |              370 |                          530 |
| 2020KW01 |              405 |                          520 |

</div>

## Download data

Data and metadata of a table can also be downloaded explicitly by using
`cbs4_download`. This can be an option if you don’t want to load the
data into memory (which both `cbs4_get_data` and `cbs4_get_observations`
do), but only store it on disk.

``` r
cbs4_download("60006", download_dir = "./60006") # will download data and metadata in csv format.
```

## Other catalogs

CBS / Statistics Netherlands also offers collections of datasets that
are not part of the main collections: so-called catalogs. These can be
retrieved with `cbs4_get_catalogs()`.

``` r
catalogs <- cbs4_get_catalogs() 
catalogs[,1:2]
```

<div class="kable-table">

| Identifier | Title                 |
| :--------- | :-------------------- |
| CBS        | CBS databank StatLine |
| CBS-asd    | CBS aanvullend        |

</div>

Another options is to set the `catalog` argument in `cbs4_get_datasets`
to `NULL`

``` r
ds <- cbs4_get_datasets()
nrow(ds)
#> [1] 53

ds_all <- cbs4_get_datasets(catalog = NULL)
nrow(ds_all)
#> [1] 56

ds_asd <- cbs4_get_datasets(catalog = "CBS-asd")
nrow(ds_asd)
#> [1] 3
```
