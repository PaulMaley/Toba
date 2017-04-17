##
## Build a single data file from the downloaded XBRL data
##

library('XBRL')

## Use the code in parse.R
source('parse.R')

## Load the ticker list - creates object tckrs 
load(file='edgarTickersOldSPX')

## Define the file cache location
xbrl.Cache <- "./xbrl.Cache"

## Build a file list
file.list <- dir(xbrl.Cache)

mdf <- data.frame(elementId=as.character(c()), 
                  fact=as.numeric(c()), 
                  sic=as.numeric(c()), 
                  cik=as.numeric(c()),
                  stringsAsFactors = FALSE)

## Test code
for (t in tckrs) {
  print(t)
  
  ## Build search string for top level file
  ## Form is:             <ticker>-<number>.xml
  ## Regular expression:  '[a-z]+-[0-9]+\.xml'
  file.pattern <- paste0(tolower(t$ticker),'-[0-9]+\\.xml')
  
  ## Look for the file
  idx <- grep(file.pattern, file.list)
  if(length(idx) != 1) next
  inst.file <- file.list[idx]
  
  ## Have instance file - parse XBRL
  xd <- xbrlDoAll(paste0(xbrl.Cache, '/', inst.file), 
                  cache.dir = xbrl.Cache, 
                  delete.cached.inst = FALSE)
  
  ## extract required data:
  df <- extract(xd)
  
  ## Add additional data
  df <- mutate(df,sic=c(t$sic), cik=c(t$cik))

  mdf <- rbind(mdf,df, deparse.level = 0)
}

## Save the mdf data.frame to avoid rebuilding it
save(mdf, file = "spx250longData")

## PROBLEM ... It seems there are some multiple occurences of data points (19 out of 2430)
## This stops spread from working .... origin of these numbers needs to be understood
## but for the moment use group_by to get around it.
mdf %>% group_by(elementId, sic, cik) %>% summarise(fact=mean(as.numeric(fact))) -> mdf2

## Spread the data and write to a csv file
library(tidyr)
write.csv(spread(mdf2, elementId, fact), "spx250.csv")

