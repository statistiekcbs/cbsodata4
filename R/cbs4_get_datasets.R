#' Get the available datasets
#'
#' Get the available datasets from open data portal
#' @param catalog only show the datasets from that catalog.
#' @param base_url base url of the CBS OData 4 API
#' @param verbose Should the url request be printed?
#' @family datasets
#' @export
cbs4_get_datasets <- function( catalog = NULL, base_url = BASEURL4
                             , verbose = getOption("cbsodataR.verbose", FALSE)
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
    ds <- ds[ds$Catalog == catalog,]
  }

  ds
}

#' cbs4_get_toc is an alias for cbs4_get_datasets.
#' @export
#' @rdname cbs4_get_datasets
cbs4_get_toc <- cbs4_get_datasets
