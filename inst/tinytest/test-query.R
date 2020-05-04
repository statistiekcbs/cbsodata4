
#  it parses a value
x <- eq("NL01", "RegioS")
expect_equal(as.character(x), "RegioS eq 'NL01'")

#  it parses values
x <- eq(c("NL01", "GM0003"), "RegioS")
expect_equal(as.character(x), "RegioS eq 'NL01' or RegioS eq 'GM0003'")

#  it parses has_substring
x <- contains("KW", "Perioden")
expect_equal(as.character(x), "contains(Perioden,'KW')")

#  it parses two has_substring", {
x <- contains(c("KW", "JJ"), "Perioden")
expect_equal(as.character(x), "contains(Perioden,'KW') or contains(Perioden,'JJ')")

#  it parses eq | has_substring
x <- eq("2019JJ00", "Perioden") | contains("KW", "Perioden")
expect_equal(as.character(x), "Perioden eq '2019JJ00' or contains(Perioden,'KW')")
