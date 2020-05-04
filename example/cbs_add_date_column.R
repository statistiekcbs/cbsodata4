if (interactive()){
  # works on observations...
  obs <- cbs4_get_observations( id        = "80784ned"    # table id
                              , Perioden  = "2019JJ00" # Year 2019
                              , Geslacht  = "1100"       # code for total gender
                              , RegioS    = "NL01"       # code for region NL
                              , Measure  = "M003371_2"
                              )

  # add a Periods_Date column
  obs_d <- cbs4_add_date_column(obs)
  obs_d

  # add a Periods_numeric column
  obs_d <- cbs4_add_date_column(obs, date_type = "numeric")
  obs_d

  # works on data
  d <- cbs4_get_data( id        = "80784ned"    # table id
                    , Perioden  = "2019JJ00"   # Year 2019
                    , Geslacht  = "1100"       # code for total gender
                    , RegioS    = "NL01"       # code for region NL
                    , Measure  = "M003371_2"
                    )
  cbs4_add_date_column(d)
}
