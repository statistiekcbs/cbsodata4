resolve_filter <- cbsodata4:::resolve_filter
get_filter <- cbsodata4:::get_filter

# it parses a simple filter statement
f <- resolve_filter("Periods eq '2001JJ00'")
expect_equal(f, list(Periods = "2001JJ00"))

#  it parses a two values"
f <- resolve_filter("((Periods eq '2001JJ00') or (Periods eq '2002JJ00'))")
expect_equal(f, list(Periods = c("2001JJ00","2002JJ00")))


# it parses a two values and a different column"
f <- resolve_filter("(Periods eq '2001JJ00' or Periods eq '2002JJ00') and (RegioS eq 'GM0003')")
expect_equal(f, list( Periods = c("2001JJ00","2002JJ00")
                    , RegioS = "GM0003"
                    )
             )

#  it parses a substringof
f <- resolve_filter("contains(Periods,'KW')")
expect_equal(f, list(Periods = quote(contains("KW"))))

# it parses a substringof and another thingy"
f <- resolve_filter("(contains(Periods, 'KW')) and RegioS eq 'GM0003'")
expect_equal(f, list(Periods = quote(contains("KW")), RegioS = "GM0003"))

#  it parses a substringof or-ed with a value"
f <- resolve_filter("contains(Periods,'KW') or Periods eq '2011JJ00'")
expect_equal(f, list(Periods = quote(contains("KW") | "2011JJ00")))

# Eat your own dog food
eyodf <- function(l){
  x <- do.call(get_filter, l)
  resolve_filter(x, quoted = FALSE)
}

l <- list(Perioden = "2019JJ00")
f <- eyodf(l)
expect_equal(f, l)

l <- list(Perioden = c("2019JJ00", "2020JJ00"))
f <- eyodf(l)
expect_equal(f, l)

l <- list(Perioden = contains("JJ"))
f <- eyodf(l)
expect_equal(f, l)

l <- list(Perioden = contains(c("JJ", "KW")))
f <- eyodf(l)
expect_equal(f, l)

l <- list(Perioden = contains("JJ") | "2019KW04")
f <- eyodf(l)
expect_equal(f, l)
