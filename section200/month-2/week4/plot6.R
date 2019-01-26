library(dplyr)
library(ggplot2)
classification_codes <- readRDS('data/Source_Classification_Code.rds')
emissions_data <- readRDS('data/summarySCC_PM25.rds')

la_baltimore_emissions <- emissions_data %>%
  filter((fips == '24510' | fips == '06037') & type == 'ON-ROAD') %>%
  mutate(city_name = ifelse(fips == '24510', 'Baltimore', 'Los Angeles')) %>%
  group_by(year, city_name) %>%
  summarize(total_emissions = sum(Emissions))

ggplot(la_baltimore_emissions, aes(x = year, y =  total_emissions, col = city_name)) +
  geom_point() +
  geom_line() +
  labs(title = 'Motor Vehicle Emissions in Baltimore City, MD and Los Angeles County, CA', x = 'Year', y = 'Total Emissions (tons)', col = 'City') +
  theme(plot.title = element_text(hjust = 0.5)) +
  guides(fill=guide_legend(title="City"))

ggsave('plot6.png')