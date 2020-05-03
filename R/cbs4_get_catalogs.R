#' Retrieve catalogs from ccb
#'
#' Retrieve catalogs from ccb
#' @export
#' @param base_url Default
#' @param verbose if `TRUE` the communication to the server is shown.
#' @family datasets
cbs4_get_catalogs <- function(base_url = BASEURL4
                             , verbose = getOption("cbsodataR.verbose", FALSE)){
  get_value( file.path(base_url, "Catalogs")
           , verbose = verbose
           )
}
