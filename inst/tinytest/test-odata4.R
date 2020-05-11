if (at_home()){
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
                , Perioden = contains("2020")
                , BedrijfstakkenBranchesSBI2008 = "T001081"
  )
  expect_equal(nrow(d), 3)

  # filter on Perioden with multiple contains
  d <- cbs4_get_data("84287NED"
                , Perioden = contains(c("2019MM1", "2020"))
                , BedrijfstakkenBranchesSBI2008 = "T001081"
  )
  expect_equal(nrow(d), 6)

  # filter on Perioden with contains or = "2019MM12
  d <- cbs4_get_data("84287NED"
               , Perioden = contains("2020") | "2019MM12"
               , BedrijfstakkenBranchesSBI2008 = "T001081"
  )
  expect_equal(nrow(d), 4)

  # This all works on observations too
  d <- cbs4_get_observations( id        = "80784ned"    # table id
                         , Perioden  = "2019JJ00"    # Year 2019
                         , Geslacht  = "1100"        # code for total gender
                         , RegioS    = contains("PV")
                         , Measure   = "M003371_2"
  )
  expect_equal(nrow(d), 12)
}
