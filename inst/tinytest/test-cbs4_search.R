if (!at_home()){
  exit_file("No live testing urls")
}

# filter on Perioden (see meta$PeriodenCodes)
d <- cbs4_search("fiets")

expect_true(nrow(d) > 0)

ds <- cbs4_get_datasets()
expect_true(all(d$Identifier %in% ds$Identifier))
expect_true(all(names(ds) %in% names(d)))

expect_true(is.numeric(d$rel))
