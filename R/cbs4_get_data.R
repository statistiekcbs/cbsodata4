#' Get data from CBS
#'
#' Get data from table `id`. The data of a CBS opendata table is in so-called wide
#' format. Each `Measure` has its own column.
#'
#' The returned [data.frame()] has the following columns:
#'
#' - For each dimension a separate column with category identifiers. Category
#' labels can be added with [cbs4_add_label_columns()] or found in [cbs4_get_metadata()].
#' Date columns can be added with [cbs4_add_date_column()].
#'
#' - For each Measure / Topic a separate column with values. Units can be found in
#' [cbs4_get_metadata()] (`MeasureCodes`).
#'
#'
#' For a long format instead of wide format see [cbs4_get_observations()]
#' which has one `Measure` column and a `Value` column.
#'
#' @example ./example/query.R
#' @export
#' @importFrom stats setNames
#' @inheritParams cbs4_get_observations
#' @param name_measure_columns `logical` if `TRUE` the `Title` of the measure will be set as
#' name column.
#' @return a [data.frame()] or [data.table()] object. See details.
#' @family data-download
#' @seealso [cbs4_get_metadata()]
cbs4_get_data <- function( id
                         , catalog = "CBS"
                         , ...
                         , query = NULL
                         , name_measure_columns = TRUE
                         , show_progress = interactive() && !verbose
                         , download_dir = file.path(tempdir(), id)
                         , verbose = getOption("cbsodata4.verbose", FALSE)
                         , sep = ","
                         , as.data.table = FALSE
                         , base_url = getOption("cbsodata4.base_url", BASEURL4)
                         ){

  obs <- cbs4_get_observations(id = id
                              , catalog = catalog
                              , ...
                              , query = query
                              , download_dir = download_dir
                              , verbose = verbose
                              , sep = sep
                              , as.data.table = TRUE # we use data.table to pivot
                              , includeId = FALSE # not used...
                              , base_url = base_url
                              )
  is_empty <- nrow(obs) == 0

  m <- attr(obs, "meta")
  lhs <- paste(m$Dimensions$Identifier, collapse = " + ")
  f <- stats::as.formula(paste(lhs, "~ Measure"))

  if (verbose){
    message("casting observations as data with: ", format(f))
  }

  # otherwise casting won't work.
  if (is_empty){
    obs[1,] <- NA
  }

  d <- data.table::dcast(obs, f, value.var = "Value")

  if (is_empty){
    d <- d[0,]
  }

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

