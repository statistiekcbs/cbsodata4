#' Get available datasets
#'
#' Get the available datasets from open data portal statline.
#'
#' Setting the catalog to `NULL` will return all
#' @note the datasets are downloaded only once per R session and cached. Subsequent calls to
#' `cbs4_get_datasets` will use the results of the first call.
#' @param catalog only show the datasets from that catalog. If `NULL`
#' all datasets of all catalogs will be returned.
#' @param base_url base url of the CBS OData 4 API
#' @param verbose Should the url request be printed?
#' @family datasets
#' @export
cbs4_get_datasets <- function( catalog = "CBS", base_url = BASEURL4
                             , verbose = getOption("cbsodata4.verbose", FALSE)
                             ){
  path_cache <- file.path(tempdir(), "datasets.rds")

  if (file.exists(path_cache)){
    ds <- readRDS(path_cache)
  } else {
    ds <- get_value( file.path(base_url, "Datasets")
                   , verbose = verbose
                   )

    saveRDS(ds, path_cache)
  }

  if (!is.null(catalog)){
    ds <- ds[ds$Catalog %in% catalog,]
  }

  ds
}

#' cbs4_get_toc is an alias for cbs4_get_datasets.
#' @export
#' @rdname cbs4_get_datasets
cbs4_get_toc <- cbs4_get_datasets
