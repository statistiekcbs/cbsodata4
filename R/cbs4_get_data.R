#' Get data from CBS
#'
#' Get data from CBS
#' @example ./example/query.R
#' @export
#' @importFrom stats setNames
#' @inheritParams cbs4_get_observations
#' @param name_measure_columns `logical` if `TRUE` the `Title` of the measure will be set as name column.
cbs4_get_data <- function( id
                         , catalog = "CBS"
                         , ...
                         , name_measure_columns = TRUE
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

  # there might be a selection in the measures, so filter on that
  labels <- labels[labels %in% names(d)]

  # set labels for nice labeling in View of RStudio
  for (n in names(labels)){
    attr(d[[n]], "label") <- unname(labels[n])
  }

  if (isTRUE(name_measure_columns)){
    idx <- match(names(d), m$MeasureCodes$Identifier, nomatch = 0)
    names(d)[idx > 0] <- m$MeasureCodes$Title[idx]
  }

  if (!isTRUE(as.data.table)){
    d <- as.data.frame(d)
  }

  structure( d
           , meta = m
           , class = c("cbs4_data", class(d))
           )

}

