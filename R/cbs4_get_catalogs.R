#' Retrieve all (alternative) catalogs of Statistics Netherlands
#'
#' Retrieve catalogs of Statistics Netherlands. Beside the main "CBS" catalog
#' other catalogs contain extra datasets that are not part of the main production
#' of SN.
#' @export
#' @param base_url possible other url that implements same interface
#' @param verbose if `TRUE` the communication to the server is shown.
#' @family datasets
cbs4_get_catalogs <- function( base_url = getOption("cbsodata4.base_url", BASEURL4)
                             , verbose = getOption("cbsodata4.verbose", FALSE)
                             ){
  get_value( file.path(base_url, "Catalogs")
           , verbose = verbose
           )
}
