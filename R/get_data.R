#' Get data from the content cijfer bank
#'
#' Get data from the content cijfer bank
#' @export
ccb_get_data <- function( id
                        , catalog = "CBS"
                        , ...
                        , download_dir = file.path(tempdir(), id)
                        , verbose = FALSE
                        , sep = ","
                        ){
  meta <- ccb_download_data(id, download_dir = download_dir, verbose = verbose, sep = sep)
  data <- read.table(file.path(download_dir, "Observations.csv"), header = TRUE, sep = sep)
  attr(data, "meta") <- meta
  data
}

#' @export
ccb_get_observations <- ccb_get_data


#d <- ccb_get_data("84120NED")
