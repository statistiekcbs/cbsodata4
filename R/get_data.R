#' Get data from the content cijfer bank
#'
#' Get data from the content cijfer bank
#' @param id Identifier of the Opendata table. Can be retrieve with ccb_get_datasets
#' @param catalog Catalog in which the dataset is to be found
#' @param ... passed through to ccb_download_data
#' @param download_dir directory in which the data and metadata is downloaded. By default this is
#' temporary directory, but can be set manually
#' @param verbose should
#' @param sep separator to be used to download the data.
#' @param includeId `logical`, should the Id column be downloaded?
#' @export
#' @rdname ccb_get_data
ccb_get_data <- function( id
                        , catalog = "CBS"
                        , ...
                        , download_dir = file.path(tempdir(), id)
                        , verbose = FALSE
                        , sep = ","
                        , includeId = TRUE
                        ){
  meta <- ccb_download_data(id, download_dir = download_dir, verbose = verbose, sep = sep)
  data <- read.table(file.path(download_dir, "Observations.csv"), header = TRUE, sep = sep)
  attr(data, "meta") <- meta
  data
}

#' @export
#' @rdname ccb_get_data
ccb_get_observations <- ccb_get_data


#d <- ccb_get_data("84120NED")
