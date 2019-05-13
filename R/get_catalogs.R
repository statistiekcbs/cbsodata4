#' Retrieve catalogs from ccb
#'
#' Retrieve catalogs from ccb
#' Retrieve catalogs from ccb
#' @export
#' @param base_url Default
ccb_get_catalogs <- function(base_url = BASEURL){
  get_value(file.path(base_url, "Catalogs"))
}
