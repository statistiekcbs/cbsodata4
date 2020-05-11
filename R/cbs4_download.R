#' Download observations and metadata
#'
#' Download observations and metadata to a directory. This function is the working
#' horse for [cbs4_get_data()] and [cbs4_get_observations()] and has many of the same
#' options.
#' @param id Identifier of publication
#' @param download_dir directory where files are to be stored
#' @param ... optional selection statement to retrieve a subset of the data.
#' @param catalog Catalog to download from
#' @param sep seperator to be used in writing the data
#' @param show_progress `logical` if `TRUE` downloading shows a progress bar. Cannot be used
#' together with `verbose=TRUE`
#' @param verbose Should messages be printed...
#' @export
#' @family data-download
cbs4_download <- function( id
                              , download_dir = id
                              , ...
                              , catalog = "CBS"
                              , show_progress = interactive() && !verbose
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
      data.table::fwrite(m, path_n, sep = sep, na = "", row.names = FALSE)
    } else if (is.list(m)){
      path_n <- file.path(download_dir, paste0(n, ".yml"))
      yaml::write_yaml(m, path_n)
    }
  }

  path <- file.path(BASEURL4, catalog, id, "Observations")
  path <- paste0(path, get_query(...))
  path <- utils::URLencode(path)

  path_obs <- file.path(download_dir, "Observations.csv")

  # empty function
  progress_cb <- invisible

  if (show_progress){
    pb_max <- meta$Properties$ObservationCount # this can be done more accurately...

    # we create a pb, that is used in progress_cb.
    pb <- utils::txtProgressBar(0, max = pb_max)

    progress_cb <- function(res){
      value <- utils::getTxtProgressBar(pb)
      utils::setTxtProgressBar(pb, value + NROW(res))
    }
  }

  download_value( path
                , output_file = path_obs
                , verbose     = verbose
                , sep         = sep
                , progress_cb = progress_cb
                )

  if (show_progress){
    utils::setTxtProgressBar(pb, pb_max)
    close(pb)
  }

  if (verbose){
    message("The data is in '", download_dir, "'")
  }

  invisible(meta)
}

# id <- "84120NED"
# m <- cbs4_download("84120NED", verbose = T)
# cbs4_download("83765NED", verbose = T)
# cbs4_download("81575NED", verbose = T)
