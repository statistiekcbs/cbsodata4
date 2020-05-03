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
cbs4_download_data <- function( id
                             , download_dir = id
                             , catalog = "CBS"
                             , ...
                             , show_progress = interactive()
                             , sep = ","
                             , verbose = FALSE
                             ){
  if (show_progress && verbose){
    warning("verbose and show_progress can't be used together, show_progess was set to FALSE.", call. = FALSE)
    show_progress <- FALSE
  }
  dir.create(download_dir, recursive = TRUE, showWarnings = FALSE)

  meta <- cbs4_get_metadata(id, catalog = catalog, verbose = verbose)

  for (n in names(meta)){
    m <- meta[[n]]
    if (is.data.frame(m)){
      path_n <- file.path(download_dir, paste0(n, ".csv"))
      data.table::fwrite(m, path_n, sep = sep, na = "", row.names = FALSE, ...)
    } else if (is.list(m)){
      path_n <- file.path(download_dir, paste0(n, ".yml"))
      yaml::write_yaml(m, path_n)
    }
  }

  path <- file.path(BASEURL4, catalog, id, "Observations")
  path_obs <- file.path(download_dir, "Observations.csv")

  # empty function
  progress_cb <- invisible

  if (show_progress){
    # we create a pb, that is used in progress_cb.
    pb <- txtProgressBar(0, max = meta$Properties$ObservationCount)

    progress_cb <- function(res){
      value <- getTxtProgressBar(pb)
      setTxtProgressBar(pb, value + NROW(res))
    }
  }

  download_value( path
                , output_file = path_obs
                , verbose     = verbose
                , sep         = sep
                , progress_cb = progress_cb
                , ...
                )

  if (show_progress){
    close(pb)
  }

  if (verbose){
    message("The data is in '", download_dir, "'")
  }

  invisible(meta)
}

# id <- "84120NED"
# m <- cbs4_download_data("84120NED", verbose = T)
# cbs4_download_data("83765NED", verbose = T)
# cbs4_download_data("81575NED", verbose = T)
