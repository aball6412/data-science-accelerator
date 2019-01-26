library(dplyr)
library(ggplot2)
classification_codes <- readRDS('data/Source_Classification_Code.rds')
emissions_data <- readRDS('data/summarySCC_PM25.rds')

emissions_by_type <- emissions_data %>%
  filter(fips == '24510') %>%
  group_by(year, type) %>%
  summarize(total_emissions = sum(Emissions))

ggplot(emissions_by_type, aes(x = year, y =  total_emissions, col = type)) +
  geom_point() +
  geom_line() +
  labs(title = 'Total Emissions by Source (Baltimore City, MD)', x = 'Year', y = 'Total Emissions (tons)') +
  theme(plot.title = element_text(hjust = 0.5))

ggsave('plot3.png')