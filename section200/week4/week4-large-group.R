# Week 4 Big group
library(tidyverse)
library(lubridate)
frontierData <- read_csv("data/frontierNovData.csv")
searchEngInd <- read_csv("data/searchEngineData.csv")

# 1
frontierData %>%
  select(SearchEngine, CallTs) %>%
  mutate(month = month(CallTs)) %>%
  filter(is.na(SearchEngine), month == 11)
# Answer: 22,855 searches

#2. 
total_searches <- frontierData %>% summarize(total = n())

searchEngRV <- frontierData %>%
  select(SearchEngine) %>%
  group_by(SearchEngine) %>%
  summarize(total = n(), percentage = n() / total_searches$total) %>%
  print
# Answer: MSN at 4.43 percent

#3. 
 searchEngInd %>%
   arrange(desc(`Market Share Perc. (Nov 2018)`))
# Answer Bing at 2.37 percent
 

 
 
 
 
 
