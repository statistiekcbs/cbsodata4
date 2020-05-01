#' @importFrom utils read.table write.table
get_value <- function(path, singleton = FALSE, verbose=TRUE){
  if (verbose){
    message("Retrieving ", path)
  }
  res <- jsonlite::read_json(path, simplifyVector = TRUE)

  if (singleton){
    res
  } else {
    res$value
  }
}

download_value <- function( path, output_file, sep = ","
                          , progress_cb = invisible
                          , verbose = TRUE
                          ){
  if (verbose){
    message("Retrieving ", path)
  }

  progress_cb(NULL)

  res <- jsonlite::read_json(path, simplifyVector = TRUE)
  data.table::fwrite( res$value, output_file
                    , row.names = FALSE
                    , na = ""
                    , quote = FALSE
                    , sep = sep
                    )

  progress_cb(res$value)

  path <- res[["@odata.nextLink"]]
  while(!is.null(path)){
    if (verbose){
      message("Retrieving ", path)
    }
    res <- jsonlite::read_json(path, simplifyVector = TRUE)
    data.table::fwrite( res$value
               , output_file
               , row.names = FALSE
               , na        = ""
               , quote     = FALSE
               , sep       = sep
               , col.names = FALSE
               , append    = TRUE
               )
    progress_cb(res$value)
    path <- res[["@odata.nextLink"]]
  }
}
