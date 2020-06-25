#' Download observations and metadata
#'
#' Download observations and metadata to a directory. This function is the working
#' horse for [cbs4_get_data()] and [cbs4_get_observations()] and has many of the same
#' options. This function is useful if you do not want to load an entire dataset
#' into memory, but just download the data and metadata in csv format.
#'
#' @param id Identifier of publication
#' @param download_dir directory where files are to be stored
#' @param ... optional selection statement to retrieve a subset of the data.
#' @param query optional odata4 query in odata syntax (overwrites any specification in `...`)
#' @param catalog Catalog to download from
#' @param sep seperator to be used in writing the data
#' @param show_progress `logical` if `TRUE` downloading shows a progress bar. Cannot be used
#' together with `verbose=TRUE`
#' @param verbose Should messages be printed...
#' @param base_url Possible other website which implements same protocol.
#' @return metadata of table ([invisible()]).
#' @export
#' @family data-download
cbs4_download <- function( id
                         , download_dir = id
                         , ...
                         , query = NULL
                         , catalog = "CBS"
                         , show_progress = interactive() && !verbose
                         , sep = ","
                         , verbose = getOption("cbsodata4.verbose", FALSE)
                         , base_url = getOption("cbsodata4.base_url", BASEURL4)
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
      path_n <- file.path(download_dir, paste0(n, ".json"))
      jsonlite::write_json(m, path_n, pretty = TRUE, auto_unbox = TRUE)
    }
  }

  path <- file.path(base_url, catalog, id, "Observations")
  if (is.null(query)) {
    path <- paste0(path, get_query(..., .meta = meta))
  } else {
    qry <- get_query(..., .meta = meta)
    if (nchar(qry)){
      warning("query argument is used, so ignoring '", qry,"'.")
    }
    path <- paste0(path, '?', query)
  }
  path <- utils::URLencode(path
  )

  path_obs <- file.path(download_dir, "Observations.csv")

  # empty function
  progress_cb <- invisible

  if (show_progress){
    pb_max <- meta$Properties$ObservationCount # this can be done more accurately...

    # we create a pb, that is used in progress_cb.
    pb <- utils::txtProgressBar(0, max = pb_max, style=3)

    progress_cb <- function(res){
      value <- utils::getTxtProgressBar(pb)
      utils::setTxtProgressBar(pb, value + NROW(res))
    }
  }

  download_value( path
                , output_file     = path_obs
                , empty_selection = get_empty_data.frame(meta)
                , verbose         = verbose
                , sep             = sep
                , progress_cb     = progress_cb
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

# usefull for empty selections
get_empty_data.frame <- function(meta){
  d <-
    data.frame( Id = integer()
              , Measure = character()
              , ValueAttribute = character()
              , Value = numeric()
              )
  d[meta$Dimensions$Identifier] <- list(character())
  d
}

# id <- "84120NED"
# m <- cbs4_download("84120NED", verbose = T)
# m <- cbs4_download("84120NED",
#   query="$skip=5&$top=20&$select=Measure,Value,Perioden,BelastingenEnWettelijkePremies",
#   verbose = T)
# cbs4_download("83765NED", verbose = T)
# cbs4_download("81575NED", verbose = T)
