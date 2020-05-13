get_filter <- cbsodata4:::get_filter

#  it("parses a value",{
x <- get_filter(RegioS = "NL01")
expect_equal(x, "RegioS eq 'NL01'")

#  it("parses values",{
x <- get_filter(RegioS = c("NL01  ", "GM0003"))
expect_equal(x, "RegioS eq 'NL01  ' or RegioS eq 'GM0003'")

#  it parses has_substring
x <- get_filter(Perioden = contains("KW"))
expect_equal(x, "contains(Perioden,'KW')")

#  it parses has_substring with multiple substrings
x <- get_filter(Perioden = contains(c("KW", "JJ")))
expect_equal(x, "contains(Perioden,'KW') or contains(Perioden,'JJ')")

#  it parses has_substring and eq
x <- get_filter(Perioden = contains("KW") | "2019JJ00")
expect_equal(x, "contains(Perioden,'KW') or Perioden eq '2019JJ00'")

#  it parses multiple columns
x <- get_filter(Perioden = contains("KW"), RegioS = c("NL01", "GM0003"))
expect_equal(x, "(contains(Perioden,'KW')) and (RegioS eq 'NL01' or RegioS eq 'GM0003')")
