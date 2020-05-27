if (interactive()){

  # filter on Perioden (see meta$PeriodenCodes)
  cbs4_get_data("84287NED"
               , Perioden = "2019MM12" # december 2019
               )

  # filter on multiple Perioden (see meta$PeriodenCodes)
  cbs4_get_data("84287NED"
               , Perioden = c("2019MM12", "2020MM01") # december 2019, january 2020
               )

  # to filter on a dimension just add the filter to the query

  # filter on Perioden (see meta$PeriodenCodes)
  cbs4_get_data("84287NED"
               , Perioden = "2019MM12" # december 2019
               , BedrijfstakkenBranchesSBI2008 = "T001081"
               )


  # filter on Perioden with contains
  cbs4_get_data("84287NED"
                , Perioden = contains("2020")
                , BedrijfstakkenBranchesSBI2008 = "T001081"
  )

  # filter on Perioden with multiple contains
  cbs4_get_data("84287NED"
                , Perioden = contains(c("2019MM1", "2020"))
                , BedrijfstakkenBranchesSBI2008 = "T001081"
  )

  # filter on Perioden with contains or = "2019MM12
  cbs4_get_data("84287NED"
                , Perioden = contains("2020") | "2019MM12"
                , BedrijfstakkenBranchesSBI2008 = "T001081"
  )

  # This all works on observations too
  cbs4_get_observations( id        = "80784ned"    # table id
                       , Perioden  = "2019JJ00"    # Year 2019
                       , Geslacht  = "1100"        # code for total gender
                       , RegioS    = contains("PV")
                       , Measure   = "M003371_2"
                       )

  # supply your own odata 4 query
  cbs4_get_data("84287NED", odata4_query = "$filter=Perioden eq '2019MM12'")

  # an odata 4 query will overrule other filter statements
  cbs4_get_data("84287NED"
               , Perioden = "2018MM12"
               , odata4_query = "$filter=Perioden eq '2019MM12'"
               , verbose = TRUE
               )

}
