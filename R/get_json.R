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

get_values <- function(path, output = tempfile(), progress_bar = interactive(), verbose = TRUE){
  if (verbose){
    message("Retrieving ", path)
  }
  res <- jsonlite::read_json(path, simplifyVector = TRUE)
  of <- file(output, "wt")
  write.csv(res$value, of, row.names = FALSE)
}
