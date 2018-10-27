# Section 5.5.2

### 1. Currently `dep_time` and `sched_dep_time` are convenient to look at, but hard to compute with because they’re not really continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.

### Answer:
```r
dep_time_edits <- mutate(flights, dep_time = (floor(dep_time / 100) * 60) + (dep_time %% 100), sched_dep_time = (floor(sched_dep_time / 100) * 60) + (sched_dep_time %% 100))
```

-----------------------------------------------------------------------------------------------------

### 2. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?

### Answer:
<!-- You would expect to see the two values perfectly match up, but they don't. Instead, the derived air_time is different than the air_time values given to us straight away.  -->

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