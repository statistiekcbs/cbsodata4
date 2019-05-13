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

download_value <- function(path, output_file, sep = ",", verbose = TRUE){
  if (verbose){
    message("Retrieving ", path)
  }

  res <- jsonlite::read_json(path, simplifyVector = TRUE)
  write.table( res$value, output_file
             , row.names = FALSE
             , na = ""
             , quote = FALSE
             , sep = sep
             )

  path <- res[["@odata.nextLink"]]
  while(!is.null(path)){
    if (verbose){
      message("Retrieving ", path)
    }
    res <- jsonlite::read_json(path, simplifyVector = TRUE)
    write.table( res$value
               , output_file
               , row.names = FALSE
               , na        = ""
               , quote     = FALSE
               , sep       = sep
               , col.names = FALSE
               , append    = TRUE
               )
    path <- res[["@odata.nextLink"]]
  }
}
