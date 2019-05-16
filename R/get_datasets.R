#' Get the available datasets
#'
#' Get the available datasets from ccb
#' @param base_url base url of the CCB API
#' @param verbose Should the url request be printed?
#' @export
ccb_get_datasets <- function(base_url = BASEURL, verbose = FALSE){
  get_value( file.path(base_url, "Datasets")
           , verbose = verbose
           )
}
