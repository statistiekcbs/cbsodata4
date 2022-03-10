if (interactive()){

  ds_nl <- cbs4_search("geboorte", language="nl-nl")
  ds_nl[1:3, c("Identifier", "Title", "rel")]

  bike_tables <- cbs4_search("fiets")
  bike_tables[1:10, c("Identifier", "Title", "rel")]
}
