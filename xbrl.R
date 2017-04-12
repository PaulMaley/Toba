library('XBRL')
library('finstr') ## needs package DBI, assertthat, tibble

options(stringsAsFactors = FALSE)

## Link to Edgar - Serious downloading problems to understand .....
## ref <- 'https://www.sec.gov/Archives/edgar/data/1318605/000156459017003118/tsla-20161231.xml'
ref <- 'https://www.sec.gov/Archives/edgar/data/320193/000162828016020309/aapl-20160924.xml'
## Get the data
xbrl.vars <- xbrlDoAll(ref, verbose=TRUE, delete.cached.inst = FALSE)
sts <- xbrl_get_statements(xbrl.vars)

## Look inside the XBRL
apple16 <- xbrl_get_statements(xbrl.vars)

