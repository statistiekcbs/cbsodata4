#' Retrieve the metadata of a publication
#'
#' Retrieve the metadata of a publication
#' @export
#' @param id Identifier of publication
#' @param catalog Catalog, @seealso \code{\link{ccb_get_catalogs}}
#' @param ... not used
ccb_get_metadata <- function(id, catalog = "CBS", ...){
  path <- file.path(BASEURL, catalog, id)
  meta <- get_value(path)

  codes <- grep("Codes$|Groups$", meta$name)
  name <- c("Dimensions", meta$name[codes])
  m <-
    lapply(name, function(n){
      get_value(file.path(path, n))
    })
  m$Properties <- get_value(file.path(path, "Properties"), singleton=TRUE)
  m
}

#ccb_get_metadata("900001NED", "CBS-Maatwerk")
