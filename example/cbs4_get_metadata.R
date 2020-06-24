if (interactive()){
  meta <- cbs4_get_metadata("80416ned")
  print(names(meta))

  # Dimension columns in the dataset
  meta$Dimensions

  # the metadata of the Measures/Topics
  meta$MeasureCodes

  # the metadata of the Perioden Categories
  meta$PeriodenCodes

  # all descriptive and publication meta data on this dataset
  meta$Properties
}
