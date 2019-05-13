#' Get the available datasets
#'
#' Get the available datasets from ccb
#' @param base_url base url of the CCB API
ccb_get_datasets <- function(base_url = BASEURL){
  get_value(file.path(base_url, "Datasets"))
}
