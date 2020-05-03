
add_date <- function(d){
  p <- data.table(id = m$PeriodenCodes$Identifier)

  TYPE <- c( "JJ" = "Y"
           , "KW" = "Q"
           , "MM" = "M"
           )

  # CRAN checks...
  freq <- NULL
  id <- NULL
  year <- NULL
  . <- NULL
  number <- NULL

  #

  p$freq <- factor( substring(p$id, 5, 6)
                  , levels = names(TYPE)
                  , labels = TYPE
                  )
  p[, number := as.integer(substring(id, 7,8))]
  p[, year := as.integer(substring(id, 1,4))]

  p[freq == "Y", date:= ISOdate(year, 1, 1)]
  p[freq == "M", date:= ISOdate(year, number, 1)]
  p[freq == "Q", date:= ISOdate(year, 1 + 3*(number-1), 1)]
  data.table::setkey(p, id)

  p2 <- p[.(d[["Perioden"]]), .(date, freq)]
  names(p2) <- paste("Perioden", names(p2), sep="_")
  d2 <- cbind(d, p2)

  i <- match("Perioden", names(d2))
  N <- ncol(d2)
  idx <- c(1:i, N-1, N, i + seq_len(N-2-i))
  d3 <- d2[, idx, with=FALSE]
  d3

}
