if (interactive()){
  # retrieve the main datasets (catalog = "CBS")
  ds <- cbs4_get_datasets()
  print(nrow(ds))

  # see cbs4_get_catalogs() to retrieve all catalogs
  ds_asd <- cbs4_get_datasets(catalog = "CBS-asd")
  print(nrow(ds_asd))

  ds_all <- cbs4_get_datasets(catalog = NULL)
  print(nrow(ds_all))
}
