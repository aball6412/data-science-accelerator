library(dplyr)
library(ggplot2)
classification_codes <- readRDS('data/Source_Classification_Code.rds')
emissions_data <- readRDS('data/summarySCC_PM25.rds')

# 1
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

# 2
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

# 3
emissions_by_type <- emissions_data %>%
  filter(fips == '24510') %>%
  group_by(year, type) %>%
  summarize(total_emissions = sum(Emissions))

ggplot(emissions_by_type, aes(x = year, y =  total_emissions, col = type)) +
  geom_point() +
  geom_line() +
  labs(title = 'Total Emissions by Source (Baltimore City, MD)', x = 'Year', y = 'Total Emissions (tons)') +
  theme(plot.title = element_text(hjust = 0.5))

# 4
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

# 5
motor_vehicle_emissions <- emissions_data %>%
  filter(fips == '24510' & type == 'ON-ROAD') %>%
  group_by(year) %>%
  summarize(total_emissions = sum(Emissions))

ggplot(motor_vehicle_emissions, aes(x = year, y = total_emissions)) +
  geom_point() +
  geom_line() +
  labs(title = 'Total Motor Vehicle Emissions in Baltimore City, MD', x = 'Year', y = 'Total Emissions (tons)') +
  theme(plot.title = element_text(hjust = 0.5))

# 6
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

