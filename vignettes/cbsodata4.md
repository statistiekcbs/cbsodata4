
[Statistics Netherlands (CBS)](https://www.cbs.nl) is the office that
produces all official statistics of the Netherlands.

For long CBS has put its data on the web in its online database
[StatLine](https://opendata.cbs.nl/statline#/CBS/en/). Since 2014 this
data base has an open data web API based on the OData protocol. The
[cbsodataR](https://CRAN.R-project.org/package=cbsodataR) package allows
for retrieving data right into R using this API.

A new version of the web api has been developed which is based on the
OData4 protocol. This OData4 API contains major changes in how the
metadata and data is transported, hence this package `cbsodata4`. Since
the old web api will be phased out in due time, `cbsodata4` is the
successor of `cbsodataR`.

This document describes how to use `cbsodata4` to download data (and
meta data) from Statistics Netherlands. It offers very similar functions
as `cbsodataR`, so should be familiar to users of `cbsodataR`, but there
are differences so carefully check your code.

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

| Identifier | Title                                                                   | Modified   |
|:-----------|:------------------------------------------------------------------------|:-----------|
| 00371edu   | Basiseducatie; deelnemers naar leeftijd, 1993-2006                      | 2013-06-05 |
| 00372      | Aardgasbalans; aanbod en verbruik                                       | 2022-03-31 |
| 00377      | Elektriciteitsbalans; aanbod en verbruik 1919-2018                      | 2019-08-13 |
| 03742      | Immi- en emigratie; leeftijd (31 dec.), burgerlijke staat, geboorteland | 2021-07-14 |
| 03747      | Overledenen; geslacht, leeftijd, burgerlijke staat, regio               | 2021-09-06 |
| 03753      | Onderwijsinstellingen; grootte, soort, levensbeschouwelijke grondslag   | 2021-06-30 |

Using `cbs4_search` a list of tables can be found that contain desired
search terms, e.g. “Diesel”:

``` r
datasets <- cbs4_search("Diesel")
head(datasets[,c("Identifier", "Title", "rel")])
```

|      | Identifier | Title                                                                     |      rel |
|:-----|:-----------|:--------------------------------------------------------------------------|---------:|
| 1549 | 84991NED   | Pompprijzen motorbrandstoffen; brandstofsoort, per kwartaal               | 21.11548 |
| 312  | 80416ned   | Pompprijzen motorbrandstoffen; brandstofsoort, per dag                    | 13.86831 |
| 1374 | 84596NED   | Aardoliegrondstoffen- en aardolieproductenbalans; aanbod en verbruik      | 13.52961 |
| 457  | 81567NED   | Pompprijzen motorbrandstoffen; locatie tankstation, brandstofsoort        | 13.31090 |
| 867  | 83406NED   | Motorbrandstoffen; afzet in petajoule, gewicht en volume, 1946-april 2021 | 13.22246 |
| 156  | 71107ned   | Verkeersprestaties personenauto’s; eigendom, brandstof, gewicht, leeftijd | 12.49478 |

Using an “Identifier” from `cbs4_get_datasets` information on the table
can be retrieved with `cbs4_get_metadata`

``` r
meta_petrol <- cbs4_get_metadata("80416ned")
meta_petrol
#> cbs odatav4: '80416ned':
#> "Pompprijzen motorbrandstoffen; brandstofsoort, per dag"
#> dimensions: Perioden
#> For more info use 'str(x)' or 'names(x)' to find out its properties.
```

The meta object contains all metadata properties of cbsodata in the form
of `data.frame`s. Each `data.frame` describes properties of the CBS
table: “Dimensions”, “MeasureCodes” and one ore more “\<Dimension>Codes”
describing the meta data of the borders of a SN table.

``` r
names(meta_petrol)
#> [1] "Dimensions"     "MeasureCodes"   "PeriodenGroups" "PeriodenCodes" 
#> [5] "Properties"
meta_petrol$MeasureCodes[, 1:3]
```

| Identifier | Index | Title          |
|:-----------|------:|:---------------|
| A047220    |     1 | Benzine Euro95 |
| A047219    |     2 | Diesel         |
| A047221    |     3 | Lpg            |

``` r
meta_petrol$Dimensions
```

| @odata.type                   | Identifier | Title    | Description | MapYear | ReleasePolicy | Kind          | ContainsGroups | ContainsCodes |
|:------------------------------|:-----------|:---------|:------------|:--------|:--------------|:--------------|:---------------|:--------------|
| #Cbs.Ccb.Models.TimeDimension | Perioden   | Perioden |             | NA      | FALSE         | TimeDimension | TRUE           | TRUE          |

``` r
# just 1 dimension with the following categories:
head(meta_petrol$PeriodenCodes)
```

| Identifier | Index | Title                    | Description | DimensionGroupId | Status |
|:-----------|------:|:-------------------------|:------------|:-----------------|:-------|
| 20060101   |     1 | 2006 zondag 1 januari    |             | 0                | NA     |
| 20060102   |     2 | 2006 maandag 2 januari   |             | 0                | NA     |
| 20060103   |     3 | 2006 dinsdag 3 januari   |             | 0                | NA     |
| 20060104   |     4 | 2006 woensdag 4 januari  |             | 0                | NA     |
| 20060105   |     5 | 2006 donderdag 5 januari |             | 0                | NA     |
| 20060106   |     6 | 2006 vrijdag 6 januari   |             | 0                | NA     |

## Data retrieval

With `cbs4_get_observations` and `cbs4_get_data` data can be retrieved.
By default this will be downloaded in a temporary directory, but this
can be set explicitly with the argument `download_dir`.

`cbs4_get_observations` is the format in which the data is downloaded
from Statistic Netherlands (CBS). It is in so-called long format. It
contains one `Measure` column, describing the topics/variable, one
`Value` column describing the statistical value, one or more Dimension
columns and some extra columns with value specific metadata.

``` r
obs <- cbs4_get_observations("80416ned")
head(obs)
```

|  Id | Measure | ValueAttribute | Value | Perioden |
|----:|:--------|:---------------|------:|---------:|
|   0 | A047220 | None           | 1.325 | 20060101 |
|   1 | A047219 | None           | 1.003 | 20060101 |
|   2 | A047221 | None           | 0.543 | 20060101 |
|   3 | A047220 | None           | 1.328 | 20060102 |
|   4 | A047219 | None           | 1.007 | 20060102 |
|   5 | A047221 | None           | 0.542 | 20060102 |

`cbs4_get_data` returns the data in so-called wide format in which each
`Measure` has its own column. For many uses this is a more natural
format. It is a pivoted version of `cbs4_get_observations()`.

``` r
# same data, but pivoted
data <- cbs4_get_data("80416ned", name_measure_columns = FALSE)
head(data, 2)
```

| Perioden | A047219 | A047220 | A047221 |
|---------:|--------:|--------:|--------:|
| 20060101 |   1.003 |   1.325 |   0.543 |
| 20060102 |   1.007 |   1.328 |   0.542 |

By default the names of the columns are more readable with
`cbs4_get_data`

``` r
# same data, but pivoted
data <- cbs4_get_data("80416ned")
head(data, 2)
```

| Perioden | Diesel | Benzine Euro95 |   Lpg |
|---------:|-------:|---------------:|------:|
| 20060101 |  1.003 |          1.325 | 0.543 |
| 20060102 |  1.007 |          1.328 | 0.542 |

### Adding category label columns

The Dimension and Measure columns use codes/keys/identifiers to describe
categories. These can be found in the metadata, but can also be
automatically added using `cbs4_add_label_columns`.

``` r
obs <- cbs4_get_observations("80416ned")
obs <- cbs4_add_label_columns(obs)
head(obs)
```

|  Id | Measure | MeasureLabel   | ValueAttribute | Value | Perioden | PeriodenLabel          |
|----:|:--------|:---------------|:---------------|------:|---------:|:-----------------------|
|   0 | A047220 | Benzine Euro95 | None           | 1.325 | 20060101 | 2006 zondag 1 januari  |
|   1 | A047219 | Diesel         | None           | 1.003 | 20060101 | 2006 zondag 1 januari  |
|   2 | A047221 | Lpg            | None           | 0.543 | 20060101 | 2006 zondag 1 januari  |
|   3 | A047220 | Benzine Euro95 | None           | 1.328 | 20060102 | 2006 maandag 2 januari |
|   4 | A047219 | Diesel         | None           | 1.007 | 20060102 | 2006 maandag 2 januari |
|   5 | A047221 | Lpg            | None           | 0.542 | 20060102 | 2006 maandag 2 januari |

or

``` r
data <- cbs4_get_data("80416ned")
data <- cbs4_add_label_columns(data)
head(data, 2)
```

| Perioden | PeriodenLabel          | Diesel | Benzine Euro95 |   Lpg |
|---------:|:-----------------------|-------:|---------------:|------:|
| 20060101 | 2006 zondag 1 januari  |  1.003 |          1.325 | 0.543 |
| 20060102 | 2006 maandag 2 januari |  1.007 |          1.328 | 0.542 |

### Adding Date column

The period/time columns of Statistics Netherlands (CBS) contain coded
time periods: e.g. 2018JJ00 (i.e. 2018), 2018KW03 (i.e. 2018 Q3),
2016MM04 (i.e. 2016 April). With `cbs4_add_date_column` the time periods
will be converted and added to the data:

``` r
obs <- cbs4_get_observations("80416ned")
obs <- cbs4_add_date_column(obs)
head(obs)
```

|  Id | Measure | ValueAttribute | Value | Perioden | Perioden_Date | Perioden_freq |
|----:|:--------|:---------------|------:|---------:|:--------------|:--------------|
|   0 | A047220 | None           | 1.325 | 20060101 | 2006-01-01    | D             |
|   1 | A047219 | None           | 1.003 | 20060101 | 2006-01-01    | D             |
|   2 | A047221 | None           | 0.543 | 20060101 | 2006-01-01    | D             |
|   3 | A047220 | None           | 1.328 | 20060102 | 2006-01-02    | D             |
|   4 | A047219 | None           | 1.007 | 20060102 | 2006-01-02    | D             |
|   5 | A047221 | None           | 0.542 | 20060102 | 2006-01-02    | D             |

``` r
data <- cbs4_get_data("80416ned")
data <- cbs4_add_date_column(data)
head(data)
```

| Perioden | Perioden_Date | Perioden_freq | Diesel | Benzine Euro95 |   Lpg |
|---------:|:--------------|:--------------|-------:|---------------:|------:|
| 20060101 | 2006-01-01    | D             |  1.003 |          1.325 | 0.543 |
| 20060102 | 2006-01-02    | D             |  1.007 |          1.328 | 0.542 |
| 20060103 | 2006-01-03    | D             |  1.007 |          1.332 | 0.540 |
| 20060104 | 2006-01-04    | D             |  1.020 |          1.348 | 0.550 |
| 20060105 | 2006-01-05    | D             |  1.021 |          1.347 | 0.550 |
| 20060106 | 2006-01-06    | D             |  1.023 |          1.353 | 0.549 |

### Adding a Unit column

Each `Measure` has a measure unit, which can be added to observations
with `cbs4_add_unit_column()`

``` r
obs <- cbs4_get_observations("80416ned")
obs <- cbs4_add_unit_column(obs)
head(obs)
```

|  Id | Measure | ValueAttribute | Value | Unit       |
|----:|:--------|:---------------|------:|:-----------|
|   0 | A047220 | None           | 1.325 | euro/liter |
|   1 | A047219 | None           | 1.003 | euro/liter |
|   2 | A047221 | None           | 0.543 | euro/liter |
|   3 | A047220 | None           | 1.328 | euro/liter |
|   4 | A047219 | None           | 1.007 | euro/liter |
|   5 | A047221 | None           | 0.542 | euro/liter |

## Filter data before download

It is possible to restrict the download using filter statements. This
may shorten the download time considerably.

### Filter

Filter statements for the columns can be used to restrict the download.
Note the following:

-   To filter you will need to use the values found in the `Identifier`
    column in the `cbs4_get_metadata` objects. e.g. for year 2020, the
    code is “2020JJ00”.

``` r
meta <- cbs4_get_metadata("60006")
tail(meta$PeriodenCodes)
```

|     | Identifier | Index | Title            | Description        | DimensionGroupId | Status     |
|:----|:-----------|------:|:-----------------|:-------------------|:-----------------|:-----------|
| 155 | 2020JJ00   |   155 | 2020             |                    | 1                | Definitief |
| 156 | 2021KW01   |   156 | 2021 1e kwartaal | Voorlopige cijfers | 0                | Voorlopig  |
| 157 | 2021KW02   |   157 | 2021 2e kwartaal | Voorlopige cijfers | 0                | Voorlopig  |
| 158 | 2021KW03   |   158 | 2021 3e kwartaal | Voorlopige cijfers | 0                | Voorlopig  |
| 159 | 2021KW04   |   159 | 2021 4e kwartaal | Voorlopige cijfers | 0                | Voorlopig  |
| 160 | 2021JJ00   |   160 | 2021             | Voorlopige cijfers | 1                | Voorlopig  |

``` r
meta$MeasureCodes[,c("Identifier","Title")]
```

| Identifier | Title                        |
|:-----------|:-----------------------------|
| M003026    | Theoretisch beschikbare uren |
| M002994_2  | Totaal niet-productieve uren |
| M003031    | Vorst- en neerslagverlet     |
| M003013    | Overig                       |
| M003019    | Productieve uren             |

-   To filter for values in a column add `<column_name> = values` to
    `cbs4_get_observations` (or `cbs4_get_data`)
    e.g. `Perioden = c("2019KW04", "2020KW01")`

``` r
obs <- cbs4_get_observations("60006"
                            , Measure = c("M003026","M003019")     # selection on Measures
                            , Perioden = c("2019KW04", "2020KW01") # selection on Perioden
                            )
cbs4_add_label_columns(obs)
```

|  Id | Measure | MeasureLabel                 | ValueAttribute | Value | Perioden | PeriodenLabel    |
|----:|:--------|:-----------------------------|:---------------|------:|:---------|:-----------------|
| 740 | M003026 | Theoretisch beschikbare uren | None           |   530 | 2019KW04 | 2019 4e kwartaal |
| 744 | M003019 | Productieve uren             | None           |   370 | 2019KW04 | 2019 4e kwartaal |
| 750 | M003026 | Theoretisch beschikbare uren | None           |   520 | 2020KW01 | 2020 1e kwartaal |
| 754 | M003019 | Productieve uren             | None           |   400 | 2020KW01 | 2020 1e kwartaal |

-   To filter for values in a column that have a substring e.g. “JJ” you
    can use `<column_name> = contains(<substring>)` to `cbs4_get_data`
    e.g.  `Perioden = contains("JJ")`

``` r
data <- cbs4_get_data("60006"
                     , Measure = c("M003026","M003019")     # selection on Measures
                     , Perioden = contains("2019") # retrieve all periods with 2019
                     )
data
```

| Perioden | Productieve uren | Theoretisch beschikbare uren |
|:---------|-----------------:|-----------------------------:|
| 2019JJ00 |             1475 |                         2090 |
| 2019KW01 |              375 |                          510 |
| 2019KW02 |              415 |                          520 |
| 2019KW03 |              320 |                          530 |
| 2019KW04 |              370 |                          530 |

-   To combine values and substring use the “\|” operator:
    `Periods = contains("2019") | "2020KW01"`

``` r
data <- cbs4_get_data("60006"
                     , Measure = c("M003026","M003019")         # selection on Measures
                     , Perioden = contains("2019") | "2020KW01" # retrieve all periods with 2019
                     )
data
```

| Perioden | Productieve uren | Theoretisch beschikbare uren |
|:---------|-----------------:|-----------------------------:|
| 2019JJ00 |             1475 |                         2090 |
| 2019KW01 |              375 |                          510 |
| 2019KW02 |              415 |                          520 |
| 2019KW03 |              320 |                          530 |
| 2019KW04 |              370 |                          530 |
| 2020KW01 |              400 |                          520 |

### query with odata v4 syntax

For the adventurous, it is possible to specify a [odata v4
query](https://www.odata.org/documentation/) themselves.

``` r
  # supply your own odata 4 query
  cbs4_get_data("84287NED", query = "$filter=Perioden eq '2019MM12'")
```

| BedrijfstakkenBranchesSBI2008 | Perioden | Vacature-indicator |
|:------------------------------|:---------|-------------------:|
| 300007                        | 2019MM12 |               0.23 |
| 307500                        | 2019MM12 |               0.07 |
| 350000                        | 2019MM12 |               0.15 |
| T001081                       | 2019MM12 |               0.21 |

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

| Identifier | Index |
|:-----------|------:|
| CBS        |     1 |
| CBS-asd    |     2 |

Another options is to set the `catalog` argument in `cbs4_get_datasets`
to `NULL`

``` r
ds <- cbs4_get_datasets()
nrow(ds)
#> [1] 1620

ds_all <- cbs4_get_datasets(catalog = NULL)
nrow(ds_all)
#> [1] 1623

ds_asd <- cbs4_get_datasets(catalog = "CBS-asd")
nrow(ds_asd)
#> [1] 3
```
