library(XBRL)
library(dplyr)

xd <- xbrlDoAll("klx-20170131.xml", cache.dir = "./rss", delete.cached.inst = FALSE)

variablesEndOfYear <- c(
  'us-gaap_AssetsCurrent',
  'us-gaap_StockholdersEquity',
  'us-gaap_PartnersCapital',
  'us-gaap_CommonStockholdersEquity',
  'us-gaap_Liabilities',
  'us-gaap_LiabilitiesAndStockholdersEquity',
  'us-gaap_LiabilitiesAndPartnersCapital')

variablesPeriod <- c(
  'dei_EntityFilerCategory',
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
  
# Get report date and extract the FY contextId
# This is valid for period related facts such as "income"
periodFY <- (xd$fact %>% filter(elementId == 'dei_DocumentPeriodEndDate'))$contextId 

endDateFY <- (xd$fact %>% filter(elementId == 'dei_DocumentPeriodEndDate') %>% 
                         left_join(xd$context, by = 'contextId') %>% 
                         select(endDate))[[1]] 

## Currencies ...
## Throw away anything not in USD ....


# Extract period "flows"
xd$fact %>% filter(elementId %in% variablesPeriod) %>% 
  left_join(xd$context, by = "contextId") %>%
  left_join(xd$unit, by = "unitId") %>% 
  filter(contextId == periodFY) %>%
  select(elementId, fact)
  #  select(contextId, startDate, endDate, fact, elementId)

## Extract end-of-period "stocks"
xd$fact %>% filter(elementId %in% variablesEndOfYear) %>% 
  left_join(xd$context, by = "contextId") %>%
  left_join(xd$unit, by = "unitId") %>% 
  filter(endDate == endDateFY) %>%
  filter(is.na(dimension1)) %>%
  select(elementId, fact)
#  select(contextId, startDate, endDate, fact, elementId, unit)







#xd$fact %>% filter(elementId == 'dei_DocumentFiscalYearFocus')
#xd$fact %>% filter(elementId == 'dei_DocumentType')
