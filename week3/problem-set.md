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

-----------------------------------------------------------------------------------------------------

# Section 19.3.1

### 1. Read the source code for each of the following three functions, puzzle out what they do, and then brainstorm better names.
```r
f1 <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}
f2 <- function(x) {
  if (length(x) <= 1) return(NULL)
  x[-length(x)]
}
f3 <- function(x, y) {
  rep(y, length.out = length(x))
}
```
### Answer:
The `F1` functionchecks to see if the prefix provided is part of the string provided. It returns a boolean. A better name for this function would be `has_prefix()`.
The `F2` function removes the last item in a vector (if the vector length is greater than 1). A better name for this function would be `remove_last_item()`.
The `F3` function takes in an `x` and `y` value and replicates the `y` value `length of x` times into it's own vector. A better name for this function would be `vector_replication_fill()`

-----------------------------------------------------------------------------------------------------

### 2. Take a function that you’ve written recently and spend 5 minutes brainstorming a better name for it and its arguments.

### Answer:
I wrote a function called `switchTabs()` that took in two arguements `tabs` and `contentId`. A better name for that function in this case would have been `switchPanel()` since the function was really switching both the highlighted tab (think tabs at the top of the chrome browser) and the content that was associated with it. I also changed the arguement `tab` to `activeTab` since this argument represented what the new active tab was going to be.

-----------------------------------------------------------------------------------------------------

### 3. Compare and contrast `rnorm()` and `MASS::mvrnorm()`. How could you make them more consistent?

### Answer:
You could create a variable name called `mvrnorm` and assign `MASS::mvrnorm()` to it so that the naming is more consistent across your codebase.

### 4. Make a case for why `norm_r()`, `norm_d()` etc would be better than `rnorm()`, `dnorm()`. Make a case for the opposite.

### Answer:
`norm_r` and `norm_d` could be better names because the autocomplete in RStudio would show you all available function names when you start typing `norm`. Hence, if you forget the exact name you'll be more easily to find it just by typing the first few letters.
The opposite case could be made, however, if you already have a pattern that utilizes an `rnorm`, `dnorm` type of naming convention for distribution functions (or if this is a common convention). In that case it would be better to stick with the conventions that are already in existance.

-----------------------------------------------------------------------------------------------------

# Section 19.4.4

### 1. What’s the difference between `if` and `ifelse()`? Carefully read the help and construct three examples that illustrate the key differences.

### Answer:
`ifelse()` is like a shorthand version of the typical `if` / `else` statements for use on vectors. It'll go through a vector and perform a comparision on each item of the vector based on the statement that you put in the parentheses of the `ifelse()`. Your statement will contain both the if and the else part. `if` on the other hand focuses just on the affirmative part of the statement. There doesn't need to be an `else` part if you don't need it and it can also work on non-vector datatypes and values.

-----------------------------------------------------------------------------------------------------

### 2. Write a greeting function that says “good morning”, “good afternoon”, or “good evening”, depending on the time of day. (Hint: use a time argument that defaults to `lubridate::now()`. That will make it easier to test your function.)

### Answer:
```r
time_of_day <- function() {
  current_time <- lubridate::now()
  current_hour <- lubridate::hour(current_time)
  if(current_hour >= 0 && current_hour < 12) {
    print("Good morning")
  } else if(current_hour >= 12 && current_hour < 5) {
    print("Good afternoon")
  } else if(current_hour >= 5 && current_hour < 24) {
    print("Good evening")
  }
}
```

-----------------------------------------------------------------------------------------------------

### 3. Implement a `fizzbuzz` function. It takes a single number as input. If the number is divisible by three, it returns “fizz”. If it’s divisible by five it returns “buzz”. If it’s divisible by three and five, it returns “fizzbuzz”. Otherwise, it returns the number. Make sure you first write working code before you create the function.

### Answer:
```r
fizzbuzz <- function(number) {
  output <- ''
  is_divisible_3 <- FALSE
  is_divisible_5 <- FALSE
  if(number %% 3 == 0 && number != 0) {
    is_divisible_3 <- TRUE
  }
  if(number %% 5 == 0 && number != 0) {
    is_divisible_5 <- TRUE
  }
  if(is_divisible_3) {
    output <- paste(output, 'fizz', sep='')
  } 
  if(is_divisible_5) {
    output <- paste(output, 'buzz', sep='')
  }
  if(!is_divisible_3 && !is_divisible_5) {
    output <- toString(number)
  }
  print(output)
}
```

-----------------------------------------------------------------------------------------------------

### 4. How could you use cut() to simplify this set of nested if-else statements?
```r
if (temp <= 0) {
  "freezing"
} else if (temp <= 10) {
  "cold"
} else if (temp <= 20) {
  "cool"
} else if (temp <= 30) {
  "warm"
} else {
  "hot"
}
```
### How would you change the call to `cut()` if I’d used `<` instead of `<=`? What is the other chief advantage of `cut()` for this problem? (Hint: what happens if you have many values in `temp`?)

### Answer:
```r
cut(c(number), c(-Inf, 0, 10, 20, 30, Inf), labels=c('freezing', 'cold', 'cool', 'warm', 'hot'))
```
If we used `<` instead of `<=` then we would add the parameter `right=FALSE` so that the last item in the range is NOT included.
```r
cut(c(number), c(-Inf, 0, 10, 20, 30, Inf), labels=c('freezing', 'cold', 'cool', 'warm', 'hot'), right=F)
```

-----------------------------------------------------------------------------------------------------

### 5. What happens if you use switch() with numeric values?

### Answer:
R will throw the following error `Error: unexpected '=' in "switch(...)`.

-----------------------------------------------------------------------------------------------------

### 6. What does this `switch()` call do? What happens if `x` is “e”?
```r
switch(x, 
  a = ,
  b = "ab",
  c = ,
  d = "cd"
)
```

### Answer:
This switch statement is saying that if `x` is either "a" or "b" then return "ab". If `x` is either "cd" or "d" then return "cd". Otherwise, return nothing. Nothing is returned if `x` is "e".

-----------------------------------------------------------------------------------------------------