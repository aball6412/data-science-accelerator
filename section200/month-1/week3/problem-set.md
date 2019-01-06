# Section 12.2.1

### 2. Compute the rate for table2, and table4a + table4b. You will need to perform four operations:
table2:
```r
cases_per_year <- table2 %>%
  filter(type == 'cases') %>%
  rename(cases = count) %>%
  group_by(country, year)

population_per_year <- table2 %>%
  filter(type == 'population') %>%
  rename(population = count) %>%
  group_by(country, year)

cases_per_year$population = population_per_year$population
cases_per_year %>%
  mutate(rate = (cases / population) * 10000) %>%
  select(country, year, cases, population, rate)
```
table4a + table4b:
```r
cases_year_one <- table4a %>%
  mutate(cases = `1999`, year = '1999') %>%
  select(country, cases, year)

cases_year_two <- table4a %>%
  mutate(cases = `2000`, year = '2000') %>%
  select(country, cases, year)

combined_cases <- bind_rows(cases_year_one, cases_year_two)
combined_cases <- combined_cases %>%
  arrange(country,year) %>%
  select(country, year, cases)

population_year_one <- table4b %>%
  mutate(population = `1999`, year = '1999') %>%
  select(country, population, year)

population_year_two <- table4b %>%
  mutate(population = `2000`, year = '2000') %>%
  select(country, population, year)

combined_population <- bind_rows(population_year_one, population_year_two)
combined_population <- combined_population %>%
  arrange(country, year) %>%
  select(country, year, population)

combined_cases$population = combined_population$population
combined_cases %>%
  mutate(rate = (cases / population) * 10000)
```

-----------------------------------------------------------------------------------------------------


### 3. Recreate the plot showing change in cases over time using table2 instead of table1. What do you need to do first?

### Answer: First you need to tidy the data so that cases is in it's own column with the correct values as follows:
```r
new_table <- table2 %>%
  filter(type == 'cases') %>%
  mutate(cases = count) %>%
  select(country, year, cases)

ggplot(new_table, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))
```

-----------------------------------------------------------------------------------------------------

# Section 12.3.3

### 1. Why are `gather()` and `spread()` not perfectly symmetrical? Both `spread()` and `gather()` have a convert argument. What does it do?

### Answer: They are not perfectly symetrical because gather needs to specify more information for the function to do it's job properly. Spread can get away with providing less parameters. The convert arguement will try to coerce the column type to be uniform. Otherwise, it will return the column type as is.

-----------------------------------------------------------------------------------------------------

### 2. Why does this code fail?
```r
table4a %>% 
  gather(1999, 2000, key = "year", value = "cases")
#> Error in inds_combine(.vars, ind_list): Position must be between 0 and n
```

### Answer: This code fails because 1999 and 2000 do not have back-ticks around them. When referencing column names, you need back-ticks if the column name has spaces or starts with a number/special character.

-----------------------------------------------------------------------------------------------------

### 3. Why does spreading this tibble fail? How could you add a new column to fix the problem?
```r
people <- tribble(
  ~name,             ~key,    ~value,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)
```
### Answer: Spreading this fails because there are multiple "identical" observations for Phillip Woods. If the spread worked we would have multiple instances of Phillip Woods with different ages. If we added an id column then that would solve our issue.

-----------------------------------------------------------------------------------------------------

### 4. Tidy the simple tibble below. Do you need to spread or gather it? What are the variables?
```r
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)
```
### Answer: You need to gather the data. The variables are sex, pregnant, and count. 

-----------------------------------------------------------------------------------------------------

# Section 12.5.1

### 1. Compare and contrast the `fill` arguments to `spread()` and `complete()`.

### Answer: The fill function accepts a column of data and will fill in an NA values (in either direction) based on the most recently filled values. This deals more with explicitly NA values. `Complete()` will take in two columns and find all of the combinations of the columns and ensure that any implicitly missing data is filled in with explicit NAs. The `spread()` function, however, deals with fundamentally restructuring how the table is set up and not so much with filling in missing values.

-----------------------------------------------------------------------------------------------------

### 2. What does the direction argument to fill() do?

### Answer: The direction argument for fill determines whether or not NA values will be replaced by the most recent observation (in that column) above or below the NA value in question.

