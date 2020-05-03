#' Get observations from cbs odata
#'
#' Get data from the content cijfer bank
#' @param id Identifier of the Opendata table. Can be retrieved with [cbs4_get_datasets()]
#' @param catalog Catalog in which the dataset is to be found
#' @param ... passed through to cbs4_download_data
#' @param download_dir directory in which the data and metadata is downloaded. By default this is
#' temporary directory, but can be set manually
#' @param verbose if `TRUE` prints the steps taken to retrieve the data.
#' @param show_progress if `TRUE` shows progress of data donwload, can't be used together
#' with verbose.
#' @param sep separator to be used to download the data.
#' @param includeId `logical`, should the Id column be downloaded?
#' @param as.data.table `logical`, should the result be of type data.table?
#' @export
cbs4_get_observations <- function( id
                         , ...
                         , catalog = "CBS"
                         , download_dir = file.path(tempdir(), id)
                         , verbose = FALSE
                         , show_progress = interactive()
                         , sep = ","
                         , includeId = TRUE
                         , as.data.table = FALSE
                         ){

  toc <- cbs4_get_datasets()
  if (!(id %in% toc$Identifier)){
    stop("Table '", id, "' can not be found in catalog '", catalog ,"'.", call. = FALSE)
  }

  meta <- cbs4_download_data( id
                            , catalog = catalog
                            , ...
                            , download_dir = download_dir
                            , verbose = verbose
                            , show_progress = show_progress
                            , sep = sep
                            )

  obs <- data.table::fread( file.path(download_dir, "Observations.csv")
                           , header = TRUE
                           , sep = sep
                           , data.table = as.data.table
                           )

  attr(obs, "meta") <- meta
  class(obs) <- c("cbs4_observations", class(obs))
  obs
}

#' Get data from CBS
#'
#' Get data from CBS
#' @export
#' @importFrom stats setNames
#' @inheritParams cbs4_get_observations
cbs4_get_data <- function( id
                         , catalog = "CBS"
                         , ...
                         , download_dir = file.path(tempdir(), id)
                         , verbose = FALSE
                         , sep = ","
                         , as.data.table = FALSE
                         ){

  obs <- cbs4_get_observations(id = id
                              , catalog = catalog
                              , ...
                              , download_dir = download_dir
                              , verbose = verbose
                              , sep = sep
                              , as.data.table = TRUE # we use data.table to pivot
                              )
  m <- attr(obs, "meta")
  lhs <- paste(m$Dimensions$Identifier, collapse = " + ")
  f <- stats::as.formula(paste(lhs, "~ Measure"))
  if (verbose){
    message("casting observations as data with: ", format(f))
  }
  d <- data.table::dcast(obs, f, value.var = "Value")

  labels <- c( setNames(m$MeasureCodes$Title, m$MeasureCodes$Identifier)
             , setNames(m$Dimensions$Title, m$Dimensions$Identifier)
             )

  # set labels for nice labeling in View of RStudio
  for (n in names(labels)){
    attr(d[[n]], "label") <- unname(labels[n])
  }

  if (!isTRUE(as.data.table)){
    d <- as.data.frame(d)
  }

  structure( d
           , meta = m
           , class = c("cbs4_data", class(d))
           )

}

