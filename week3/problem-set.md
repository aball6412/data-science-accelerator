# Section 5.5.2

### 1. Currently `dep_time` and `sched_dep_time` are convenient to look at, but hard to compute with because they’re not really continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.

### Answer:
```r
dep_time_edits <- mutate(flights, dep_time = (floor(dep_time / 100) * 60) + (dep_time %% 100), sched_dep_time = (floor(sched_dep_time / 100) * 60) + (sched_dep_time %% 100))
```

-----------------------------------------------------------------------------------------------------

### 2. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?

### Answer:
You would expect to see the two values perfectly match up, but they don't. Instead, the derived air_time is different than the air_time values given to us straight away. You also see that some values are extremely negative (when a flight leaves before midnight and arrives after midnight). In order to fix this issue, for the flights affected we would need to add "minutes until midnight" with our minutes since midnight calculation.

-----------------------------------------------------------------------------------------------------

### 3. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?

### Answer:
You would expect `sched_dep_time + dep_delay` to equal `dep_time`.

-----------------------------------------------------------------------------------------------------

### 4. Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().

### Answer:
```r
flights <- mutate(flights, min_rank = min_rank(desc(dep_delay)))
most_delayed <- head(flights[order(-flights$dep_delay),], 10)
```

-----------------------------------------------------------------------------------------------------

### 5. What does `1:3 + 1:10` return? Why?

### Answer:
`1:3 + 1:10` returns the following warning message:
```r
Warning message:
In 1:3 + 1:10 :
  longer object length is not a multiple of shorter object length
```
This is because the two vectors are not the same length and type and hence R is not able to properly add them together.

-----------------------------------------------------------------------------------------------------

# Section 5.6.7

### Setup variables:
```r
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
```

-----------------------------------------------------------------------------------------------------

### 2. Come up with another approach that will give you the same output as `not_cancelled %>% count(dest)` and `not_cancelled %>% count(tailnum, wt = distance)` (without using `count()`).

### Answer:
```r
not_cancelled %>% 
  group_by(dest) %>%
  summarise(n = n())

not_cancelled %>% 
  group_by(tailnum) %>%
  summarise(n = sum(distance))
```

-----------------------------------------------------------------------------------------------------

### 3. Our definition of cancelled flights -- `is.na(dep_delay) | is.na(arr_delay)` -- is slightly suboptimal. Why? Which is the most important column?

### Answer:
It is slightly suboptimal because we dont _really_ care if there isn't a value for `dep_delay` or `arr_delay`, what we really should focus on is if `dep_time` and `arr_time` is na. Those would be more reliable indicators than `dep_delay` and `arr_delay`.

-----------------------------------------------------------------------------------------------------

### 4. Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of cancelled flights related to the average delay?

### Answer:
We can see a summary of the relevant data with the following code:
```r
daily <- group_by(flights, year, month, day)
cancelled_per_day <- summarise(daily, total_flights = n(), cancelled = sum(is.na(dep_delay)), proportion = round((cancelled/total_flights), digits = 2), delay_std = sd(dep_delay, na.rm=TRUE), avg_delay = mean(dep_delay, na.rm=TRUE))  
```
After analyzing the summary table above, we can conclude that as the standard deviation of `dep_delay` increases the number of cancelled flights also increases. So cancelled flights and average departure delay are positively correlated.

-----------------------------------------------------------------------------------------------------

### 5. Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about `flights %>% group_by(carrier, dest) %>% summarise(n())`)

### Answer:
We can see that the carrier with the highest average delays is Frontier Airlines(F9):
```r
worst_carriers <- flights %>%
  group_by(carrier) %>%
  summarise(avg_delay = mean(dep_delay, na.rm=T))
worst_carriers[order(-worst_carriers$avg_delay),]
```
Yes, we can adjust for bad airports by looking at average delay per airport for each carrier with the following code:
```r
per_airport <- flights %>%
  group_by(carrier, dest) %>%
  summarise(avg_delay = mean(dep_delay, na.rm = T))

worst_carriers_adj <- summarise(per_airport, avg_delay = mean(avg_delay, na.rm = T))
worst_carriers_adj[order(-worst_carriers$avg_delay),]
```
As we can see, Frontier Airlines(F9) still has the highest delay per airport and is hence still the worst airline in terms of delays.

-----------------------------------------------------------------------------------------------------

### 6. What does the sort argument to `count()` do. When might you use it?

### Answer:
The sort argument for `count()` will order the results from highest to lowest values. You might use this when you want to summarize the total items for a particular observation and then sort those observations in sequential order (lowest to highest or vice versa).

-----------------------------------------------------------------------------------------------------

# Section 5.7.1

### 1. Refer back to the lists of useful mutate and filtering functions. Describe how each operation changes when you combine it with grouping.

### Answer:
They work in the same way except you don't have to explicitly pass in a data frame object if you're using piping.

-----------------------------------------------------------------------------------------------------

### 2. Which plane (`tailnum`) has the worst on-time record?

### Answer:
N844MH is the tailnum with the worst on-time record.
```r
latest_planes <- flights %>%
  group_by(tailnum) %>%
  summarise(late = mean(arr_delay, na.rm=T))
latest_planes[order(-latest_planes$late),]
```

-----------------------------------------------------------------------------------------------------

### 3. What time of day should you fly if you want to avoid delays as much as possible?

### Answer:
You should fly on flights scheduled for 7am.
```r
best_time_of_day <- flights %>%
  group_by(hour) %>%
  filter(!is.na(arr_delay)) %>%
  summarise(total = n(), late = mean(arr_delay, na.rm=T))
best_time_of_day[order(best_time_of_day$late),]
```

-----------------------------------------------------------------------------------------------------

### 4. For each destination, compute the total minutes of delay. For each flight, compute the proportion of the total delay for its destination.

### Answer:
```r
delay_by_dest <- flights %>%
  group_by(dest) %>%
  summarise(total_delay = sum(arr_delay, na.rm=T))

delay_by_tailnum_dest <- flights %>%
  group_by(tailnum, dest) %>%
  summarise(total_delay = sum(arr_delay, na.rm=T))
```

-----------------------------------------------------------------------------------------------------

### 5. Delays are typically temporally correlated: even once the problem that caused the initial delay has been resolved, later flights are delayed to allow earlier flights to leave. Using `lag()`, explore how the delay of a flight is related to the delay of the immediately preceding flight.

### Answer:
```r
lag_test <- flights %>%
  group_by(year, month, day, origin, sched_dep_time) %>%
  filter(!is.na(dep_delay)) %>%
  transmute(total = n(), arr_delay, prev_delay = lag(arr_delay)) %>%
  filter(!is.na(prev_delay))
```
-----------------------------------------------------------------------------------------------------

### 6. Look at each destination. Can you find flights that are suspiciously fast? (i.e. flights that represent a potential data entry error). Compute the air time a flight relative to the shortest flight to that destination. Which flights were most delayed in the air?

### Answer:
To get the fastest flight time by destination run the following code:
```r
outliar_flights <- flights %>%
  group_by(dest) %>%
  filter(!is.na(dep_time)) %>%
  summarise(total = n(), min_time = min(air_time, na.rm=T))
```
I'm not sure why this would have any meaningful representation of data entry error since we aren't adjusting to _where_ the flight is coming from. Grouping only by destination doesn't seem to make sense in this case.
```r
outliar_flights <- flights %>%
  group_by(dest) %>%
  filter(!is.na(dep_time)) %>%
  transmute(flight, total = n(), min_air_time = min(air_time, na.rm=T), rel_air_time = (air_time - min_air_time)) %>%
  arrange(desc(rel_air_time))
```
Flight numbers 841, 426, 575, 745, and 17 were the most delayed flights in the air relative to the shortest flight to that destination. Again, this does NOT take into account the flight origin so I don't really think these numbers are very meaningful.

-----------------------------------------------------------------------------------------------------

### 7. Find all destinations that are flown by at least two carriers. Use that information to rank the carriers.

### Answer:
```r
best_carriers <- flights %>%
  group_by(dest) %>%
  summarise(total.flights = n(), unique = n_distinct(carrier)) %>%
  filter(unique >= 2)
```
The EV, 9E, and UA fly to the most unique destinations. So if we want to rank airlines based on that criteria then they would top the list. Here is the code to produce the result:
```r
most_destinations <- flights %>%
  group_by(carrier) %>%
  summarise(total.flights = n(), unique = n_distinct(dest)) %>%
  filter(unique >= 2) %>%
  arrange(desc(unique))
```

-----------------------------------------------------------------------------------------------------

### 8. For each plane, count the number of flights before the first delay of greater than 1 hour.

### Answer:
```r
before_delays <- flights %>%
  group_by(tailnum) %>%
  arrange(tailnum, year, month, day, dep_time) %>%
  transmute(arr_delay, before.long.delay = cumsum(arr_delay < 60)) %>%
  filter(!is.na(before.long.delay)) %>%
  summarise(before.long.delay = max(before.long.delay, na.rm=T))
```