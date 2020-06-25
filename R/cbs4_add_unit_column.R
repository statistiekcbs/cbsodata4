#' Add unit column to observations
#'
#' Add a unit column  the unit of each measure.
#'
#' [cbs4_add_unit_column()] retrieves the `Unit`s for each Measure from
#' `MeasureCodes` in the metadata ([cbs4_get_metadata()]) and adds this to the
#' observations data set.
#' @return original observations [data.frame()] with extra `Unit` column.
#' @importFrom utils head tail
#' @export
#' @example  ./example/cbs4_add_unit_column.R
#' @param data downloaded with [cbs4_get_observations()]
#' @param ... not used
#' @family add metadata columns
#' @seealso [cbs4_get_metadata()]
cbs4_add_unit_column <- function(data, ...){

  if (!inherits(data, "cbs4_observations")){
    stop("cbs4_add_unit_column only works on data retrieved with cbs4_get_observations.", call. = FALSE)
  }

  meta <- attr(data, "meta")
  nms <- names(data)
  measure_codes <- meta$MeasureCodes
  measure_codes$Unit <- factor(measure_codes$Unit)
  idx <- match(data$Measure, measure_codes$Identifier)
  data$Unit <- droplevels(measure_codes$Unit[idx])
  i <- which(nms == "Value")
  nms <- c(head(nms, i), "Unit", tail(nms, -(i+1)))
  data[,nms]
}


# d <-
#   cbs4_get_data("84120NED") %>%
#   cbs4_add_unit_column() %>%
#   glimpse()


# View(meta$MeasureCodes)
