#' Get observations from a table.
#'
#' Get observations from table `id`. Observations are data of a CBS opendata table in so-called long
#' format. There is one `Measure` column denoting the different variables/topics, and there is a column
#' for each of the dimensions, which can be queried using [cbs4_get_metadata()]. Furtheremore it
#' contains one `Value` columns contains the data. [cbs4_get_data()] offers an alternative in which
#' each variable/topic/Measure has its own column.
#'
#' @example ./example/query.R
#' @param id Identifier of the Opendata table. Can be retrieved with [cbs4_get_datasets()]
#' @param catalog Catalog in which the dataset is to be found.
#' @param ... optional selections on data, passed through to cbs4_download. See examples
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

  toc <- cbs4_get_datasets(catalog = catalog)
  if (!(id %in% toc$Identifier)){
    stop("Table '", id, "' can not be found in catalog '", catalog ,"'.", call. = FALSE)
  }

  meta <- cbs4_download( id
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
