# uses experimental search engine

SEARCHURL <- "https://cerberus.cbs.nl/api/search?query=%s&spelling_correction=true&language=%s&sort_by=relevance&highlight=false"

#' Search table with search term
#'
#' Search a opendata table using free text search.
#' @export
#' @param query `character` with the text to searched for
#' @param language `character` language of the catalog, currently only Dutch
#' @inheritParams cbs4_get_datasets
#' @return `data.frame` same format as [cbs4_get_datasets()] plus extra `$rel` column
#' with the search score.
#' @example ./example/cbs4_search.R
#' @note The search engine currently searches in the odata3 data collection, but
#' uses the Identifiers to find tables in the odata4 data collection.
cbs4_search <- function( query
                       , catalog="CBS"
                       , language="nl-nl"
                       , convert_dates = TRUE
                       , verbose = getOption("cbsodata4.verbose", FALSE)
                       , base_url = getOption("cbsodata4.base_url", BASEURL4)
                       ){
  path <- sprintf(SEARCHURL, utils::URLencode(query), language)

  res <- get_value(path, singleton = TRUE, verbose = verbose)

  res_tables <- res$results[res$results$document_type =="table", c("unique_id", "rel", "url")]

  ds <- cbs4_get_datasets(catalog=catalog, verbose = verbose, convert_dates = convert_dates)

  m <- match(res_tables$unique_id, ds$Identifier, nomatch = 0)
  res_ds <- ds[m, ]
  res_ds <- cbind(res_ds, res_tables[m > 0, c("rel", "url")])
  res_ds
}
