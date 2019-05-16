#' Add labels to codes
#'
#' Add labels to codes
#' @export
#' @param data downloaded with \code{\link{ccb_get_data}}
#' @param ... not used
ccb_add_labels <- function(data, ...){
  meta <- attr(data, "meta")
  # stopifnot(!is.null(meta), "Missing metadata")
  dim_cols <- c("Measure", meta$Dimensions$Identifier)
  dim_codes <- paste0(dim_cols, "Codes")
  label_cols <- paste0(dim_cols, "Label")
  for (i in seq_along(dim_cols)){
    codes <- data[[dim_cols[i]]]
    meta_dim <- meta[[dim_codes[i]]]
    idx <- match(codes, meta_dim$Identifier)
    data[[label_cols[i]]] <- meta_dim$Title[idx]
  }
  # TODO reorder the label columns to be just after the codes
  data
}


# d <-
#   ccb_get_data("84120NED") %>%
#   ccb_add_labels() %>%
#   glimpse()


# View(meta$MeasureCodes)
