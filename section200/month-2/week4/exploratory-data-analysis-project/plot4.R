library(dplyr)
library(ggplot2)
classification_codes <- readRDS('data/Source_Classification_Code.rds')
emissions_data <- readRDS('data/summarySCC_PM25.rds')

emissions_data <- merge(x = emissions_data, y = classification_codes, by = "SCC", all.x = TRUE)
coal_emissions <- emissions_data %>%
  filter(grepl('Coal', EI.Sector))

coal_emission_summary <- coal_emissions %>%
  group_by(year) %>%
  summarize(total_emissions = sum(Emissions))

ggplot(coal_emission_summary, aes(x = year, y =  total_emissions)) +
  geom_point() +
  geom_line() +
  labs(title = 'Total Emissions from Coal Combustion Related Sources', x = 'Year', y = 'Total Emissions (tons)') +
  theme(plot.title = element_text(hjust = 0.5))

ggsave('plot4.png')