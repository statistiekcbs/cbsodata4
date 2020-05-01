#' Add unit column to data
#'
#' Add labels to codes
#' @importFrom utils head tail
#' @export
#' @param data downloaded with [cbs4_get_observations()]
#' @param ... not used
cbs4_add_unit <- function(data, ...){
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
#   cbs4_add_unit() %>%
#   glimpse()


# View(meta$MeasureCodes)
