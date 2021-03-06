library(XBRL)
library(dplyr)

#XBRL()

#xd <- xbrlDoAll("./xbrl.Cache/abt-20161231.xml", cache.dir = "./xbrl.Cache", delete.cached.inst = FALSE)
#xd <- xbrlDoAll("./xbrl.Cache/aapl-20160924.xml", cache.dir = "./xbrl.Cache", delete.cached.inst = FALSE)
#xd <- xbrlDoAll("https://www.sec.gov/Archives/edgar/data/1307969/000168316817000653/none-20161231.xml", cache.dir = "./xbrl.Cache", delete.cached.inst = FALSE)
#xd <- xbrlDoAll('https://www.sec.gov/Archives/edgar/data/66740/000155837017000479/mmm-20161231.xml', cache.dir = "./xbrl.Cache", delete.cached.inst = FALSE)

## Code above for testing downloading .... move elsewhere
## Code below assumes that xd has been successfully "filled"

variablesEndOfYear <- c(
  'us-gaap_AssetsCurrent',
  'us-gaap_StockholdersEquity',
  'us-gaap_PartnersCapital',
  'us-gaap_CommonStockholdersEquity',
  'us-gaap_Liabilities',
  'us-gaap_LiabilitiesAndStockholdersEquity',
  'us-gaap_LiabilitiesAndPartnersCapital')

variablesPeriod <- c(
#  'dei_EntityFilerCategory',     # Wrong variable
  'us-gaap_IncomeTaxExpenseBenefit',
  'us-gaap_IncomeTaxExpenseBenefitContinuingOperations',
  'us-gaap_InterestAndDebtExpense',
  'us-gaap_InterestExpense',
  'us-gaap_InterestIncomeExpenseNet',
  'us-gaap_NetCashProvidedByUsedInContinuingOperations',
  'us-gaap_NetCashProvidedByUsedInContinuingOperations',
  'us-gaap_NetCashProvidedByUsedInInvestingActivities',
  'us-gaap_NetCashProvidedByUsedInInvestingActivitiesContinuingOperations',
  'us-gaap_ProfitLoss',
  'us-gaap_NetIncomeLoss',
  'us-gaap_IncomeLossAttributableToParent',
  'us-gaap_OperatingIncomeLoss',
  'us-gaap_ResearchAndDevelopmentExpense',
  'us-gaap_Revenues',
  'us-gaap_SalesRevenueNet')

#variables <- c('us-gaap_AssetsCurrent', 'us-gaap_NetIncomeLoss')
 
## Wrap these in a function ....
extract <- function(xd) {
  
 
# Get report date and extract the FY contextId
# This is valid for period related facts such as "income"
periodFY <- (xd$fact %>% filter(elementId == 'dei_DocumentPeriodEndDate'))$contextId 

endDateFY <- (xd$fact %>% filter(elementId == 'dei_DocumentPeriodEndDate') %>% 
                         left_join(xd$context, by = 'contextId') %>% 
                         select(endDate))[[1]] 

## Currencies ...
## Throw away anything not in USD ....


# Extract period "flows"
f1 <- xd$fact %>% filter(elementId %in% variablesPeriod) %>% 
  left_join(xd$context, by = "contextId") %>%
  left_join(xd$unit, by = "unitId") %>%                     # Warning ..... joining factors with different levels !!
  filter(contextId == periodFY) %>%
  select(elementId, fact)
  #  select(contextId, startDate, endDate, fact, elementId)

## Extract end-of-period "stocks"
f2 <- xd$fact %>% filter(elementId %in% variablesEndOfYear) %>% 
  left_join(xd$context, by = "contextId") %>%
  left_join(xd$unit, by = "unitId") %>% 
  filter(endDate == endDateFY) %>%
  filter(is.na(dimension1)) %>%
  select(elementId, fact)
#  select(contextId, startDate, endDate, fact, elementId, unit)

## Glue these togther 
df <- rbind(f1,f2)

## And modify the structure ...
df %>% mutate_if(is.factor, as.character) -> df
df

}

## Need to add company name & cik




#xd$fact %>% filter(elementId == 'dei_DocumentFiscalYearFocus')
#xd$fact %>% filter(elementId == 'dei_DocumentType')
