\dontrun{
cbs_get_data( id      = "7196ENG"      # table id
            , Periods = "2000MM03"     # March 2000
            , CPI     = "000000"       # Category code for total
            )

# useful substrings:
## Periods: "JJ": years, "KW": quarters, "MM", months
## Regions: "NL", "PV": provinces, "GM": municipalities

cbs_get_data( id      = "7196ENG"      # table id
            , Periods = contains("JJ")     # all years
            , CPI     = "000000"       # Category code for total
            )

cbs_get_data( id      = "7196ENG"      # table id
            , Periods = c("2000MM03","2001MM12")     # March 2000 and Dec 2001
            , CPI     = "000000"       # Category code for total
            )

# combine either this
cbs_get_data( id      = "7196ENG"      # table id
            , Periods = contains("JJ") | "2000MM01" # all years and Jan 2001
            , CPI     = "000000"       # Category code for total
            )

# or this: note the "eq" function
cbs_get_data( id      = "7196ENG"      # table id
            , Periods = eq("2000MM01") | contains("JJ") # Jan 2000 and all years
            , CPI     = "000000"       # Category code for total
            )
}

if (interactive()){
  cbs4_get_data( id        = "80784ned"    # table id
               , Perioden  = "2019JJ00"   # Year 2019
               , Geslacht  = "1100"       # code for total gender
               , RegioS    = contains("PV")
               , Measure  = "M003371_2"
               )
}
