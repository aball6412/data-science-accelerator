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

### 5. What does `1:3 + 1:10` return? Why?

### Answer:
`1:3 + 1:10` returns the following warning message:
```r
Warning message:
In 1:3 + 1:10 :
  longer object length is not a multiple of shorter object length
```
This is because the two vectors are not the same length and type and hence R is not able to properly add them together.