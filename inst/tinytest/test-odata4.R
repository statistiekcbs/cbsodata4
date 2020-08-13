if (!at_home()){
  exit_file("No live testing urls")
}

# filter on Perioden (see meta$PeriodenCodes)
d <- cbs4_get_data("84287NED"
              , Perioden = "2019MM12" # december 2019
)
expect_equal(nrow(d), 4)

# filter on multiple Perioden (see meta$PeriodenCodes)
d <- cbs4_get_data("84287NED"
              , Perioden = c("2019MM12", "2020MM01") # december 2019, january 2020
)
expect_equal(nrow(d), 8)


# to filter on a dimension just add the filter to the query

# filter on Perioden (see meta$PeriodenCodes)
d <- cbs4_get_data("84287NED"
              , Perioden = "2019MM12" # december 2019
              , BedrijfstakkenBranchesSBI2008 = "T001081"
)
expect_equal(nrow(d), 1)

# filter on Perioden with contains
d <- cbs4_get_data("84287NED"
              , Perioden = contains("2019")
              , BedrijfstakkenBranchesSBI2008 = "T001081"
)
expect_equal(nrow(d), 12)

# filter on Perioden with multiple contains
d <- cbs4_get_data("84287NED"
              , Perioden = contains(c("2019MM1", "2018"))
              , BedrijfstakkenBranchesSBI2008 = "T001081"
)
expect_equal(nrow(d), 15)

# filter on Perioden with contains or = "2019MM12
d <- cbs4_get_data("84287NED"
             , Perioden = contains("2018") | "2019MM12"
             , BedrijfstakkenBranchesSBI2008 = "T001081"
)
expect_equal(nrow(d), 13)

# This all works on observations too
obs <- cbs4_get_observations( id        = "80784ned"    # table id
                       , Perioden  = "2019JJ00"    # Year 2019
                       , Geslacht  = "1100"        # code for total gender
                       , RegioS    = contains("PV")
                       , Measure   = "D003371_2"
)
expect_equal(nrow(obs), 12)

# test if units are added
obs_unit <- cbs4_add_unit_column(obs)
expect_true("Unit" %in% names(obs_unit))

d <- cbs4_get_data("84287NED", query = "$filter=Perioden eq '2019MM12'")
expect_equal(nrow(d), 4)
d_d <- cbs4_add_date_column(d)
expect_true("Perioden_Date" %in% names(d_d))
expect_true("Perioden_freq" %in% names(d_d))
expect_true(all(d_d$Perioden_Date == "2019-12-01"))
expect_equal(class(d_d$Perioden_Date), "Date")

d_l <- cbs4_add_label_columns(d)
expect_true("PeriodenLabel" %in% names(d_l))

expect_warning({
  d <- cbs4_get_data("84287NED"
                , Perioden = "2018MM12"
                , query = "$filter=Perioden eq '2019MM12'"
                )
})
expect_true(all(d$Perioden == "2019MM12"))


### verbose selection

expect_message({
  d <- cbs4_get_data( "84287NED"
                    , verbose = TRUE
                    )
})

### empty selection

expect_warning({
  d <- cbs4_get_observations( "84287NED"
                              , Perioden = "rubbish"
  )
})

expect_equal(nrow(d), 0)

expect_warning({
  d <- cbs4_get_data( "84287NED"
                              , Perioden = "rubbish"
  )
})

expect_equal(nrow(d), 0)

expect_warning({
  d <- cbs4_get_observations( "84287NED"
                            , Perioden = contains("rubbish")
                            )
}, "contains: 'rubbish' does not match any keys")

expect_equal(nrow(d), 0)

### bigger selection (two retrievals)

obs <- cbs4_get_observations( id = "80784ned")    # table id
expect_true(nrow(obs) > 1e5)


### metadata

meta <- cbs4_get_metadata("80784ned")
print(meta)

### catalogs

catlog <- cbs4_get_catalogs()
expect_true(nrow(catlog) > 1)

### datasets

# test that tables from all catalogs
ds_cbs <- cbs4_get_datasets()
ds_all <- cbs4_get_datasets(catalog = NULL)

expect_true(nrow(ds_all) > nrow(ds_cbs))
