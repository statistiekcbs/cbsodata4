#' Download the data file
#'
#' Download the data file
#' @param id Identifier of publication
#' @param download_dir directory where files are to be stored
#' @param catalog Catalog to download from
#' @param sep seperator to be used in writing the data
#' @param ... not used
#' @param verbose Should messages be printed...
#' @export
ccb_download_data <- function( id
                             , download_dir = id
                             , catalog = "CBS"
                             , ...
                             , sep = ","
                             , verbose = TRUE
                             ){
  dir.create(download_dir, recursive = TRUE, showWarnings = FALSE)

  meta <- ccb_get_metadata(id, catalog = catalog, verbose = verbose)
  for (n in names(meta)){
    path_n <- file.path(download_dir, paste0(n, ".csv"))
    write.table(meta[[n]], path_n, sep = sep, na = "", row.names = FALSE, ...)
  }

  path <- file.path(BASEURL, catalog, id, "Observations")
  path_obs <- file.path(download_dir, "Observations.csv")

  download_value( path
                , output_file = path_obs
                , verbose = verbose
                , sep = sep
                , ...
                )

  if (verbose){
    message("The data is in '", download_dir, "'")
  }
  invisible(meta)
}

# id <- "84120NED"
# m <- ccb_download_data("84120NED", verbose = T)
# ccb_download_data("83765NED", verbose = T)
# ccb_download_data("81575NED", verbose = T)
