
``` r
library(cbsodata4)
```

# Introduction

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

``` r
datasets <- cbs4_get_datasets()
head(datasets[,c("Identifier", "Title")])
```

<div class="kable-table">

| Identifier | Title                                                                 |
| :--------- | :-------------------------------------------------------------------- |
| 37230ned   | Bevolkingsontwikkeling; regio per maand                               |
| 60006      | Bouwnijverheid; productieve uren in de burgerlijke en utiliteitsbouw  |
| 70072ned   | Regionale kerncijfers Nederland                                       |
| 7100oogs   | Akkerbouwgewassen; productie naar regio                               |
| 7425zuiv   | Melkaanvoer en zuivelproductie door zuivelfabrieken                   |
| 80072ned   | Ziekteverzuimpercentage; bedrijfstakken (SBI 2008) en bedrijfsgrootte |

</div>

``` r
meta <- cbs4_get_metadata("80416ned")
ls.str(meta)
#> Dimensions : 'data.frame':   1 obs. of  6 variables:
#>  $ Identifier   : chr "Perioden"
#>  $ Title        : chr "Perioden"
#>  $ Description  : chr ""
#>  $ Kind         : chr "TimeDimension"
#>  $ MapYear      : logi NA
#>  $ ReleasePolicy: chr "False"
#> MeasureCodes : 'data.frame': 3 obs. of  10 variables:
#>  $ Identifier      : chr  "E006512" "E006528" "E006498"
#>  $ Index           : int  1 2 3
#>  $ Title           : chr  "Benzine Euro95" "Diesel" "LPG"
#>  $ Description     : chr  "Loodvrije motorbenzine met een octaangetal van 95. \r\nPompprijs inclusief accijns en btw." "Brandstof voor dieselmotoren in het wegverkeer, ook wel bekend als autodiesel, autogasolie of autodieselolie (A"| __truncated__ "LPG (Liquefied Petroleum Gas), wordt ook wel autogas genoemd en\r\nbestaat uit propaan en butaan.\r\nPompprijs "| __truncated__
#>  $ MeasureGroupId  : logi  NA NA NA
#>  $ DataType        : chr  "Double" "Double" "Double"
#>  $ Unit            : chr  "euro/liter" "euro/liter" "euro/liter"
#>  $ Format          : logi  NA NA NA
#>  $ Decimals        : int  3 3 3
#>  $ PresentationType: logi  NA NA NA
#> PeriodenCodes : 'data.frame':    5238 obs. of  6 variables:
#>  $ Identifier      : chr  "20060101" "20060102" "20060103" "20060104" ...
#>  $ Index           : int  1 2 3 4 5 6 7 8 9 10 ...
#>  $ Title           : chr  "2006 zondag 1 januari" "2006 maandag 2 januari" "2006 dinsdag 3 januari" "2006 woensdag 4 januari" ...
#>  $ Description     : chr  "" "" "" "" ...
#>  $ DimensionGroupId: chr  "0" "0" "0" "0" ...
#>  $ Status          : logi  NA NA NA NA NA NA ...
#> PeriodenGroups : 'data.frame':   1 obs. of  5 variables:
#>  $ Id         : chr "0"
#>  $ Index      : int 14
#>  $ Title      : chr "Dagen"
#>  $ Description: logi NA
#>  $ ParentId   : logi NA
#> Properties : List of 28
#>  $ @odata.context      : chr "https://beta-odata4.cbs.nl/CBS/80416ned/$metadata#Properties"
#>  $ Identifier          : chr "80416ned"
#>  $ Title               : chr "Pompprijzen motorbrandstoffen; brandstofsoort, per dag"
#>  $ Description         : chr "Deze tabel bevat pompprijzen van motorbrandstoffen. Er worden gewogen gemiddelde dagprijzen gepubliceerd van be"| __truncated__
#>  $ Language            : chr "nl"
#>  $ Authority           : chr "https://standaarden.overheid.nl/owms/terms/Centraal_Bureau_voor_de_Statistiek"
#>  $ Modified            : chr "2020-05-07T00:00:00+02:00"
#>  $ TemporalCoverage    : chr "1 januari 2006 - 4 mei 2020"
#>  $ Catalog             : chr "CBS"
#>  $ Publisher           : chr "https://standaarden.overheid.nl/owms/terms/Centraal_Bureau_voor_de_Statistiek"
#>  $ ContactPoint        : chr "infoservice@cbs.nl"
#>  $ Version             : chr "202005070000"
#>  $ VersionNotes        : chr ""
#>  $ VersionReason       : chr "Actualisering"
#>  $ Frequency           : chr "Per week"
#>  $ Status              : chr "Regulier"
#>  $ ObservationCount    : int 15714
#>  $ ObservationsModified: chr "2020-05-07T00:00:00+02:00"
#>  $ DatasetType         : chr "Numeric"
#>  $ DefaultPresentation : chr "graphtype=Table&r=Perioden&k=Topics"
#>  $ GraphTypes          : chr "Table,Bar,Line"
#>  $ SearchPriority      : chr "3"
#>  $ License             : chr "https://creativecommons.org/licenses/by/4.0/"
#>  $ Source              : chr "Travelcard Nederland BV, CBS"
#>  $ Summary             : chr "Gemiddelde prijzen motorbrandstoffen: Benzine Euro95, Diesel en LPG\nPompprijzen per dag"
#>  $ LongDescription     : chr "INHOUDSOPGAVE\r\n\r\n1. Toelichting\r\n2. Definities en verklaring van symbolen\r\n3. Koppelingen naar relevant"| __truncated__
#>  $ Provenance          :'data.frame':    2 obs. of  2 variables:
#>  $ RelatedSources      :'data.frame':    5 obs. of  2 variables:
```

``` r
obs <- cbs4_get_observations("80416ned")
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

``` r
obs <- cbs4_get_observations("80416ned")
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

``` r
obs <- cbs4_get_observations("80416ned")
obs <- cbs4_add_date_column(obs)
head(obs)
```

<div class="kable-table">

| Id | Measure | ValueAttribute | Value | Perioden | Perioden\_Date | Perioden\_freq |
| -: | :------ | :------------- | ----: | -------: | :------------- | :------------- |
|  0 | E006512 | None           | 1.325 | 20060101 | NA             | NA             |
|  1 | E006528 | None           | 1.003 | 20060101 | NA             | NA             |
|  2 | E006498 | None           | 0.543 | 20060101 | NA             | NA             |
|  3 | E006512 | None           | 1.328 | 20060102 | NA             | NA             |
|  4 | E006528 | None           | 1.007 | 20060102 | NA             | NA             |
|  5 | E006498 | None           | 0.542 | 20060102 | NA             | NA             |

</div>

``` r

data <- cbs4_get_data("80416ned")
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

``` r
meta <- cbs4_get_metadata("80416ned")
obs <- cbs4_get_observations("80416ned")
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

``` r
data <- cbs4_get_data("80416ned")
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
