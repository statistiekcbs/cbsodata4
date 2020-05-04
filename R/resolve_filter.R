OR_CLAUSES <- "\\s+or\\s+"
AND_CLAUSES <- "\\s+and\\s+"
BRACKETS <- "^\\s*\\((.*)\\)\\s*$"

resolve_filter <- function(filter, quoted = TRUE){
  if (is.null(filter)){
    return(NULL)
  }
  #browser()
  a <- strsplit(filter, AND_CLAUSES)[[1]]

  # remove matching () at beginning and end
  a <- sub(BRACKETS, "\\1", a)

  a <- strsplit(a, OR_CLAUSES)

  a <- lapply(a, function(x){
    # remove matching () at beginning and end
    sub(BRACKETS, "\\1", x)
  })

  nms <- character(length(a))
  EQ <- "(\\w+) eq '(.*)'"
  CONTAINS <- "contains\\(\\s*(\\w+)\\s*,\\s*'([^)]+)'\\)"
  #SUBSTRINGOF <- "substringof\\('([^)]+)'\\s*,\\s*(\\w+)\\)"

  eq_query <- lapply(a, function(x){grep(EQ, x)})
  contains_query <- lapply(a, function(x){grep(CONTAINS, x)})

  nms <- mapply(function(x, eq, ss){
    if (length(eq)){
      eq <- eq[1]
      sub(EQ, "\\1", x[eq])
    } else if (length(ss)){
      ss <- ss[1]
      sub(CONTAINS, "\\1", x[ss])
    }
  }, a, eq_query, contains_query)

  cats <- mapply(function(x, eqs, column){
    if (length(eqs)){
      eqs <- sub(EQ, "\\2", x[eqs])
      eqs <- substitute(eq(eqs), list(eqs =eqs))
      eqs
    }
  }, a, eq_query, nms)

  substrings <- mapply(function(x, ss, column){
    if (length(ss)){
      ss <- sub(CONTAINS, "\\2", x[ss])
      ss <- substitute(contains(ss), list(ss = ss))
      ss
    }
  }, a, contains_query, nms)

  cats <- mapply(function(eq, ss){
    if (length(eq)){
      if (length(ss)){
        substitute( ss | eq, list(eq=eq[[2]], ss = ss))
      } else {
        # return just the character (more readable)
        eq[[2]]
      }
    } else {
      ss
    }
  }, cats, substrings, SIMPLIFY = FALSE)

  if (!isTRUE(quoted)){
    cats <- lapply(cats, eval)
  }

  names(cats) <- nms
  cats
}
