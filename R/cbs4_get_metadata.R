#' Retrieve the metadata of a publication
#'
#' Retrieve the metadata of a publication
#' @export
#' @param id Identifier of publication or data retrieved with [cbs4_get_data()]/[cbs4_get_observations()]
#' @param catalog Catalog, from the set of [cbs4_get_catalogs()]
#' @param ... not used
#' @param base_url alternative url that implements same interface as statistics netherlands.
#' @param verbose Should the function report on retrieving the data
cbs4_get_metadata <- function( id
                             , catalog  = "CBS"
                             , ...
                             , base_url = BASEURL4
                             , verbose  = getOption("cbsodata4.verbose", FALSE)
                             ){
  meta <- attr(id, "meta")
  if (!is.null(meta)){
    return(meta)
  }

  path <- file.path(base_url, catalog, id)

  # caching
  path_cache <- file.path(tempdir(), paste0(catalog, "_", id, ".rds"))
  if (file.exists(path_cache)){
    if (verbose) {
      message("Reading metadata from cache: ", path_cache)
    }
    return(readRDS(path_cache))
  }
  #

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
  m <- structure(m, class="cbs4_meta")
  saveRDS(m, path_cache)
  m
}

#' @export
print.cbs4_meta <- function(x, ...){
  e <- deparse(substitute(x))
  with(x$Properties,{
    cat("cbs odata: '", Identifier ,"':\n"
       , '"', Title, '"\n'
       , "dimensions: ", paste0(x$Dimensions$Identifier, collapse = ", "), "\n"
       , "For more info use ", e, "$.\n"
       , sep = ""
       )
  })
}
