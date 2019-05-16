#' Retrieve catalogs from ccb
#'
#' Retrieve catalogs from ccb
#' @export
#' @param base_url Default
#' @param verbose if \code{TRUE} the communication to the server is shown.
ccb_get_catalogs <- function(base_url = BASEURL, verbose = FALSE){
  get_value( file.path(base_url, "Catalogs")
           , verbose = verbose
           )
}
