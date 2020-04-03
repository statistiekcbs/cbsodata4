#' Get the available datasets
#'
#' Get the available datasets from open data portal
#' @param base_url base url of the CBS OData 4 API
#' @param verbose Should the url request be printed?
#' @export
cbs4_get_datasets <- function(..., base_url = BASEURL, verbose = FALSE){
  get_value( file.path(base_url, "Datasets")
           , verbose = verbose
           )
}
