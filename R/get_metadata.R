#' Retrieve the metadata of a publication
#'
#' Retrieve the metadata of a publication
#' @export
#' @param id Identifier of publication or data retrieved with \code{\link{ccb_get_data}}
#' @param catalog Catalog, @seealso \code{\link{ccb_get_catalogs}}
#' @param ... not used
#' @param verbose Should the function report on retrieving the data
ccb_get_metadata <- function(id, catalog = "CBS", ..., verbose = FALSE){
  meta <- attr(id, "meta")
  if (!is.null(meta)){
    return(meta)
  }

  path <- file.path(BASEURL, catalog, id)

  # caching
  path_cache <- file.path(tempdir(), paste0(catalog, "_", id, ".rds"))

  if (file.exists(path_cache)){
    if (verbose) {
      message("Reading metadata from cache: ", path_cache)
    }
    return(readRDS(path_cache))
  }

  meta <- get_value(path, verbose = verbose)

  codes <- grep("Codes$|Groups$", meta$name)
  name <- c("Dimensions", meta$name[codes])

  m <-
    lapply(name, function(n){
      get_value(file.path(path, n), verbose = verbose)
    })
  names(m) <- name

  m$Properties <- get_value( file.path(path, "Properties")
                           , singleton = TRUE
                           , verbose = verbose
                           )

  # saving for future cache
  if (verbose){
    message("Saving metadata in '", path_cache, "'")
  }

  saveRDS(m, path_cache)
  m
}

# m <- ccb_get_metadata("900001NED", "CBS-Maatwerk", verbose=TRUE)
#m <- ccb_get_metadata("84120NED", verbose=T)
