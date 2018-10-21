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