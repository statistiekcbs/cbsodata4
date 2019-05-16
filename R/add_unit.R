#' Add unit column to data
#'
#' Add labels to codes
#' @importFrom utils head tail
#' @export
#' @param data downloaded with \code{\link{ccb_get_data}}
#' @param ... not used
ccb_add_unit <- function(data, ...){
  meta <- attr(data, "meta")
  nms <- names(data)
  measure_codes <- meta$MeasureCodes
  idx <- match(data$Measure, measure_codes$Identifier)
  data$Unit <- factor(measure_codes$Unit[idx])
  i <- which(nms == "Value")
  nms <- c(head(nms, i), "Unit", tail(nms, -(i+1)))
  data[,nms]
}


# d <-
#   ccb_get_data("84120NED") %>%
#   ccb_add_unit() %>%
#   glimpse()


# View(meta$MeasureCodes)
