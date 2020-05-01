#' Get data from the content cijfer bank
#'
#' Get data from the content cijfer bank
#' @param id Identifier of the Opendata table. Can be retrieved with cbs4_get_datasets
#' @param catalog Catalog in which the dataset is to be found
#' @param ... passed through to cbs4_download_data
#' @param download_dir directory in which the data and metadata is downloaded. By default this is
#' temporary directory, but can be set manually
#' @param verbose should
#' @param sep separator to be used to download the data.
#' @param includeId `logical`, should the Id column be downloaded?
#' @export
cbs4_get_observations <- function( id
                         , catalog = "CBS"
                         , ...
                         , download_dir = file.path(tempdir(), id)
                         , verbose = FALSE
                         , sep = ","
                         , includeId = TRUE
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
                            , sep = sep
                            )

  #data <- read.table(file.path(download_dir, "Observations.csv"), header = TRUE, sep = sep)
  data <- data.table::fread( file.path(download_dir, "Observations.csv")
                           , header = TRUE
                           , sep = sep
                           , data.table = TRUE
                           )

  attr(data, "meta") <- meta
  class(data) <- c("cbs4_observations", class(data))
  data
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
                         ){
  obs <- cbs4_get_observations(id = id
                              , catalog = catalog
                              , ...
                              , download_dir = download_dir
                              , verbose = verbose
                              , sep = sep
                              )
  m <- attr(obs, "meta")
  d <- data.table::as.data.table(obs)

  lhs <- paste(m$Dimensions$Identifier, collapse = " + ")
  f <- stats::as.formula(paste(lhs, "~ Measure"))
  d <- data.table::dcast(d, f, value.var = "Value")

  labels <- c( setNames(m$MeasureCodes$Title, m$MeasureCodes$Identifier)
             , setNames(m$Dimensions$Title, m$Dimensions$Identifier)
             )

  # set labels for nice labeling in View of RStudio
  for (n in names(labels)){
    attr(d[[n]], "label") <- unname(labels[n])
  }

  structure( as.data.frame(d)
           , meta = m
           )

}
