#' Get observations from a table.
#'
#' Get observations from table `id`. Observations are data of a CBS opendata table in so-called long
#' format.
#'
#' The returned [data.frame()] has the following columns:
#'
#' - A `Measure` column with identifiers/codes of measures/topics. Detailed information
#' on Measures can be found with in `MeasureCodes` using [cbs4_get_metadata()].
#' Measure labels can be added with  [cbs4_add_label_columns()].
#'
#' - A `Value` column with the (numerical) value, Units can be added
#' with [cbs4_add_unit_column()].
#'
#' - An optional `ValueAttribute` column with data point specific metadata.
#'
#' - For each dimension a separate column with category identifiers. Category
#' labels can be added with [cbs4_add_label_columns()] or found in [cbs4_get_metadata()].
#' Date columns can be added with [cbs4_add_date_column()].
#'
#' [cbs4_get_data()] offers an alternative in which
#' each variable/topic/Measure has its own column.
#'
#' @example ./example/query.R
#' @export
#' @param id Identifier of the Opendata table. Can be retrieved with [cbs4_get_datasets()]
#' @param catalog Catalog in which the dataset is to be found.
#' @param ... optional selections on data, passed through to cbs4_download. See examples
#' @param query optional query in odata4 syntax (overwrites any specification in `...`)
#' @param download_dir directory in which the data and metadata is downloaded. By default this is
#' temporary directory, but can be set manually
#' @param verbose if `TRUE` prints the steps taken to retrieve the data.
#' @param show_progress if `TRUE` shows progress of data download, can't be used together
#' with verbose.
#' @param sep separator to be used to download the data.
#' @param includeId `logical`, should the Id column be downloaded?
#' @param as.data.table `logical`, should the result be of type data.table?
#' @param base_url Possible other url which implements same protocol.
#' @return [data.frame()] or [data.table()] object, see details.
#' @family data-download
#' @seealso [cbs4_get_metadata()]
cbs4_get_observations <- function( id
                                 , ...
                                 , query = NULL
                                 , catalog = "CBS"
                                 , download_dir = file.path(tempdir(), id)
                                 , show_progress = interactive() && !verbose
                                 , verbose = getOption("cbsodata4.verbose", FALSE)                                   , sep = ","
                                 , includeId = TRUE
                                 , as.data.table = FALSE
                                 , base_url = getOption("cbsodata4.base_url", BASEURL4)
){

  toc <- cbs4_get_datasets(catalog = catalog)
  if (!(id %in% toc$Identifier)){
    stop("Table '", id, "' can not be found in catalog '", catalog ,"'.", call. = FALSE)
  }

  meta <- cbs4_download( id
                       , catalog = catalog
                       , ...
                       , query = query
                       , download_dir = download_dir
                       , verbose = verbose
                       , show_progress = show_progress
                       , sep = sep
                       , base_url = base_url
                       )

  obs <- data.table::fread( file.path(download_dir, "Observations.csv")
                            , header = TRUE
                            , sep = sep
                            , data.table = as.data.table
  )

  if (!isTRUE(includeId)){
    obs <- obs[,-1]
  }
  attr(obs, "meta") <- meta
  class(obs) <- c("cbs4_observations", class(obs))
  obs
}
