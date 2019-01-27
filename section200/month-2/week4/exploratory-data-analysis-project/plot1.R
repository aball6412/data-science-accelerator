library(dplyr)
library(ggplot2)
classification_codes <- readRDS('data/Source_Classification_Code.rds')
emissions_data <- readRDS('data/summarySCC_PM25.rds')

emission_summary <- emissions_data %>%
  group_by(year) %>%
  summarize(total_emissions = sum(Emissions/ 1000000))
plot(
  emission_summary$year, 
  emission_summary$total_emissions, 
  pch=16, ylab = 'Total Emissions in tons (millions)', 
  xlab = 'Year',
  main = 'Total Emissions by year'
)
lines(emission_summary$year, emission_summary$total_emissions)
dev.copy(png, file = 'plot1.png')
dev.off()