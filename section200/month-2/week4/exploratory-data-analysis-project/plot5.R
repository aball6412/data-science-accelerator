library(dplyr)
library(ggplot2)
classification_codes <- readRDS('data/Source_Classification_Code.rds')
emissions_data <- readRDS('data/summarySCC_PM25.rds')

motor_vehicle_emissions <- emissions_data %>%
  filter(fips == '24510' & type == 'ON-ROAD') %>%
  group_by(year) %>%
  summarize(total_emissions = sum(Emissions))

ggplot(motor_vehicle_emissions, aes(x = year, y = total_emissions)) +
  geom_point() +
  geom_line() +
  labs(title = 'Total Motor Vehicle Emissions in Baltimore City, MD', x = 'Year', y = 'Total Emissions (tons)') +
  theme(plot.title = element_text(hjust = 0.5))

ggsave('plot5.png')