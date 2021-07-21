#' Add understandable labels to a table
#'
#' Add columns with labels to the dataset.
#'
#' [cbs4_add_label_columns()] adds for the `Measure` and each `<Dimension>`
#' column an extra column `MeasureLabel` ( `<Dimension>Label`) that contains
#' the `Title` of each code, making the table more digestible. `Title` and
#' other metadata can also be found using [cbs4_get_metadata()].
#'
#' @return original dataset with extra label columns. See details.
#' @example ./example/cbs4_add_label_columns.R
#' @export
#' @param data downloaded with [cbs4_get_data()]
#' @param ... not used
#' @family add metadata columns
#' @seealso [cbs4_get_metadata()]
cbs4_add_label_columns <- function(data, ...){
  if (!(inherits(data, "cbs4_data") || inherits(data, "cbs4_observations"))){
    stop("cbs4_add_label_columns only works on data retrieved with cbs4_get_data or cbs4_get_observations."
        , call. = FALSE
        )
  }

  meta <- attr(data, "meta")
  # stopifnot(!is.null(meta), "Missing metadata")
  nms <- names(data)
  dim_cols <- c("Measure", meta$Dimensions$Identifier)
  dim_cols <- dim_cols[dim_cols %in% nms]
  dim_codes <- paste0(dim_cols, "Codes")

  label_cols <- paste0(dim_cols, "Label")
  for (i in seq_along(dim_cols)){
    codes <- data[[dim_cols[i]]]
    meta_dim <- meta[[dim_codes[i]]]
    idx <- match(codes, meta_dim$Identifier)
    data[[label_cols[i]]] <- meta_dim$Title[idx]
  }

  # reorder the label columns to be just after the code
  i <- c( seq_along(nms)
        , match(dim_cols, nms) + 0.5
        )
  o <- order(i)
  data <- data[, o]
  attr(data, "meta") <- meta
  data
}
