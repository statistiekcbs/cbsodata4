#' Retrieve catalogs from ccb
#'
#' Retrieve catalogs from ccb
#' @export
#' @param base_url Default
#' @param verbose if \code{TRUE} the communication to the server is shown.
cbs4_get_catalogs <- function(base_url = BASEURL, verbose = FALSE){
  get_value( file.path(base_url, "Catalogs")
           , verbose = verbose
           )
}


#' @export
#' @rdname cbs4_get_catalogs
cbs4_get_toc <- cbs4_get_catalogs
