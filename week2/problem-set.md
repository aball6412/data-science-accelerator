## Section 4.4

### 1. Why does this code not work?

```r
my_variable <- 10
my_varıable
#> Error in eval(expr, envir, enclos): object 'my_varıable' not found
```

### Answer:
This code does not work because "my_variable" is spelled wrong on the second line. Fix the spelling mistake and that will fix the issue. 

=======================================================================================================

### 2. Tweak each of the following R commands so that they run correctly:
```r
library(tidyverse)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

fliter(mpg, cyl = 8)
filter(diamond, carat > 3)
```

### Answer:
A couple of things need to be changed in order to get this code to work. 
1. Must run `install.packages("tidyverse")` to install the tidyverse package before any of this code will work.
2. `fliter(mpg, cyl = 8)` has `filter` misspelled and needs two `==` signs to make it work.
3. `filter(diamond, carat > 3)` is referencing  a `diamond` data frame when it SHOULD be `diamonds`(plural)

=======================================================================================================

### 3. Press Alt + Shift + K. What happens? How can you get to the same place using the menus?
Pressing Alt + Shift + K causes the keyboard shortcut list to pop-up. To get this same list to pop-up from the menu, simply go to tools > Keyboard Shortcuts Help. 

=======================================================================================================

## Section 5.2.4

### 1. Find all flights that:
* First import packages and declare flights variable:
```r
library(nycflights13)
library(tidyverse)
flights <- nycflights13::flights
```

1. Had an arrival delay of two or more hours
```r
delayed_arrival <- filter(flights, arr_delay > 120)
```

2. Flew to Houston (IAH or HOU)
```r
flew_to_houston <- filter(flights, dest == "IAH" | dest == "HOU")
```

3. Were operated by United, American, or Delta
```r
operated_by <- filter(flights, carrier == "DL" | carrier == "UA" | carrier == "AA")
```

4. Departed in summer (July, August, and September)
```r
departure_month <- filter(flights, month == 7 | month == 8 | month == 9)
```

5. Arrived more than two hours late, but didn’t leave late
```r
dep_on_time_arr_late <- filter(flights, dep_delay <= 0 & arr_delay > 120)
```

6. Were delayed by at least an hour, but made up over 30 minutes in flight
```r
made_up_time <- filter(flights, dep_delay >= 60, (arr_delay < dep_delay & (dep_delay - arr_delay) > 30))
```

7. Departed between midnight and 6am (inclusive)
```r
bet_midnight_and_6 <- filter(flights, dep_time >= 0 & dep_time <= 600)
```

=======================================================================================================

### 2. Another useful dplyr filtering helper is between(). What does it do? Can you use it to simplify the code needed to answer the previous challenges?

### Answer:
The `between()` function provides a shorthand for stating that a particular variable is in the middle of two values. For example, the `filter(flights, dep_time >= 0 & dep_time <= 600)` code block above could be simplified to `filter(flights, between(dep_time, 0, 600))`

=======================================================================================================

### 3. How many flights have a missing dep_time? What other variables are missing? What might these rows represent?

### Answer:
There are 8,255 observations that have a missing `dep_time`. Additionally, `dep_delay`, `arr_time`, and `arr_delay` values are also missing. These observations probably represent flights that were canceled.

=======================================================================================================

### 4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? Can you figure out the general rule? (NA * 0 is a tricky counterexample!)

### Answer:
`NA ^ 0` is not missing because anything to the 0 power evaluates to 1 so no matter what NA is in this situation the result will be 1. `NA | TRUE` is not missing because that logic will ALWAYS at _least_ evaluate to `TRUE` due to the OR part of the statement. `FALSE & NA` is not missing because no matter what NA is the result of this expression will either be `TRUE` or `FALSE`. The general rule is if a statement can be evaluated _regardless_ of what the NA value is then the result will NOT be NA even if an NA value is present. Otherwise, it will most likely be evaluated to NA.

=======================================================================================================

## Section 5.3.1

### 1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).

### Answer: 
```r
missing_values_first <- arrange(flights, desc(is.na(dep_time)))
```

=======================================================================================================

### 2. Sort flights to find the most delayed flights. Find the flights that left earliest.

### Answer:
Most delayed flights:
```r
most_delayed <- arrange(flights, desc(dep_delay))
```
Flights that left earliest:
```r
earliest_departures <- arrange(flights, dep_delay)
```

=======================================================================================================

### 3. Sort flights to find the fastest flights.

### Answer:
```r
fastest_flights <- arrange(flights, air_time)
```

=======================================================================================================

### 4. Which flights travelled the longest? Which travelled the shortest?

### Answer:
__Longest (distance):__ Flights from JFK to HNL (NYC to Hawaii)
```r
longest_flights <- arrange(flights, desc(distance))
```
__Shortest (distance):__ Flights from EWR to PHL (Newark to Philadelphia)
```r
shortest_flights <- arrange(flights, distance)
```

=======================================================================================================

## Section 5.4.1

### 2. What happens if you include the name of a variable multiple times in a select() call?

### Answer: 
R will disregard any additional times that the variable is included.
Example:
`select(flights, dep_time, arr_time)` and `select(flights, dep_time, arr_time, dep_time)` yield the exact same results.

### 3. What does the one_of() function do? Why might it be helpful in conjunction with this vector?
```r
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
```

### Answer:
The `one_of()` function selects all variables that are present in a particular character vector. So for example running the following code block will create a data frame that only has the columns defined in the vars vector.
```r
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
selected_columns <- select(flights, one_of(vars))
```

### 4. Does the result of running the following code surprise you? How do the select helpers deal with case by default? How can you change that default?
```r
select(flights, contains("TIME"))
```

### Answer:
No the result is not surprising. By default, select helpers are NOT case sensitive. If a user wants to perform a case sensitive match then they need to set the parameter `ignore.case` to `TRUE` when calling the function.