% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cbs4_search.R
\name{cbs4_search}
\alias{cbs4_search}
\title{Search table with search term}
\usage{
cbs4_search(
  query,
  catalog = "CBS",
  language = "nl-nl",
  convert_dates = TRUE,
  verbose = getOption("cbsodata4.verbose", FALSE),
  base_url = getOption("cbsodata4.base_url", BASEURL4)
)
}
\arguments{
\item{query}{\code{character} with the text to searched for}

\item{catalog}{only show the datasets from that catalog. If \code{NULL}
all datasets of all catalogs will be returned.}

\item{language}{\code{character} language of the catalog, currently only Dutch}

\item{convert_dates}{Converts date columns in Date-Time type (in stead of \code{character})}

\item{verbose}{Should the url request be printed?}

\item{base_url}{base url of the CBS OData 4 API}
}
\value{
\code{data.frame} same format as \code{\link[=cbs4_get_datasets]{cbs4_get_datasets()}} plus extra \verb{$rel} column
with the search score.
}
\description{
Search a opendata table using free text search.
}
\note{
The search engine currently searches in the odata3 data collection, but
uses the Identifiers to find tables in the odata4 data collection.
}
\examples{
if (interactive()){

  ds_nl <- cbs4_search("geboorte", language="nl-nl")
  ds_nl[1:3, c("Identifier", "Title", "rel")]

  bike_tables <- cbs4_search("fiets")
  bike_tables[1:10, c("Identifier", "Title", "rel")]
}
}
