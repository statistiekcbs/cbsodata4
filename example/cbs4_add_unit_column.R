if (interactive()){
  # works only on observations
  obs <- cbs4_get_observations("84287NED", Perioden="2019MM12")
  obs # without Unit column

  obs_unit <- cbs4_add_unit_column(obs)
  obs_unit # with unit column
}
