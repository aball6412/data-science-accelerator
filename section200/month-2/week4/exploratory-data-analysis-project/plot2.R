library(dplyr)
library(ggplot2)
classification_codes <- readRDS('data/Source_Classification_Code.rds')
emissions_data <- readRDS('data/summarySCC_PM25.rds')

baltimore_emissions_summary <- emissions_data %>%
  filter(fips == '24510') %>%
  group_by(year) %>%
  summarize(total_emissions = sum(Emissions))
plot(
  baltimore_emissions_summary$year, 
  baltimore_emissions_summary$total_emissions, 
  pch=16, ylab = 'Total Emissions in tons', 
  xlab = 'Year',
  main = 'Total Emissions in Baltimore City, MD'
)
lines(baltimore_emissions_summary$year, baltimore_emissions_summary$total_emissions)
dev.copy(png, file = 'plot2.png')
dev.off()