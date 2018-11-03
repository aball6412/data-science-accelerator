# Section 20.3.5

### 1. Describe the difference between `is.finite(x)` and `!is.infinite(x)`

### Answer:
`is.finite(x)` will return `TRUE` if x is a finite number. `!is.infinite(x)` will return `TRUE` if x is NOT an infinte number (meaning, that x is finite). As written, both of these functions will return the same results for x. The main difference is that one function is checking for finite numbers and the other is checking for infinite numbers.

-----------------------------------------------------------------------------------------------------

### 2. Read the source code for `dplyr::near()` (Hint: to see the source code, drop the `()`). How does it work?

### Answer:
It essentially has a tolerance and if the absolute value of the two numbers being compared is within that tolerance band then it returns `TRUE`. Otherwise, it'll return `FALSE`.

-----------------------------------------------------------------------------------------------------

### 3. A logical vector can take 3 possible values. How many possible values can an integer vector take? How many possible values can a double take? Use google to do some research.

### Answer:
Integers can take 2 types of values, integers (whole numbers) and `NA`. A double can take double values (decimals), `NA`, `NaN`, `Inf`, and `-Inf`. So, if we are talking about how many types of values each vector type can take then integer vectors can have 2 types and double vectors can have 5 types. If we are talking about different values (ex: 1 vs 2 vs 3 vs 4, etc) then both integer and double vectors can have an infinite number of potential values (not taking into account limited memory space in computers).

-----------------------------------------------------------------------------------------------------

### 4. Brainstorm at least four functions that allow you to convert a double to an integer. How do they differ? Be precise.

### Answer:
Four functions that can convert a double to an integer include any rounding function like `round()`, `ceiling()`, `floor()`, and `truc()`. 
1. `round()` rounds to the specified number of decimal places. So this doesn't HAVE to return an integer, but if rounding to 0 decimal places then it will return an integer.
2. `ceiling()` rounds up to the nearest integer.
3. `floor()` rounds down to the nearest integer.
4. `trunc()` takes anything after the decimal and cuts it off, leaving just the base number. Ex: `trunc(9.9999999)` returns 9.

-----------------------------------------------------------------------------------------------------

### 5. What functions from the readr package allow you to turn a string into logical, integer, and double vector?

### Answer:
`parse_logical()`, `parse_integer()`, `parse_double()`.

-----------------------------------------------------------------------------------------------------

# Section 20.4.6

### 1. What does `mean(is.na(x))` tell you about a vector `x`? What about `sum(!is.finite(x))`?

### Answer:
It tells you what proportion of vector `x` is `NA` values. The second part tells you the number of items in vector x that are not finite numbers.

-----------------------------------------------------------------------------------------------------

### 2. Carefully read the documentation of `is.vector()`. What does it actually test for? Why does `is.atomic()` not agree with the definition of atomic vectors above?

### Answer:
`is.vector()` actually tests that the vector is a vector and that it doesn't have ANY attributes other than name. `is.atomic()` does not agree with the definition of atomic vectors above because it will return `TRUE` if a `NULL` value is passed in, which isn't an atomic vector type mentioned above.

-----------------------------------------------------------------------------------------------------

### 3. Compare and contrast `setNames()` with `purrr::set_names()`.

### Answer:
They are very similar functions. `setNames()` comes in base R and `purrr::set_names()` comes in the purrr package. `purrr::set_names()` also has more strict argument checking.

-----------------------------------------------------------------------------------------------------

### 4. Create functions that take a vector as input and returns:
1. The last value. Should you use [ or [[?
2. The elements at even numbered positions.
3. Every element except the last value.
4. Only even numbers (and no missing values).

### Answer:
```r
last_item <- function(vector) {
  vector[length(vector)]
}
even_numbered_pos <- function(vector) {
  vector[c(FALSE, TRUE)]
}
all_but_last <- function(vector) {
  vector[-length(vector)]
}
even_numbered <- function(vector) {
  no_na <- vector[!is.na(vector)]
  no_na[no_na %% 2 == 0]
}
```

-----------------------------------------------------------------------------------------------------

### 5. Why is `x[-which(x > 0)]` not the same as `x[x <= 0]`?

### Answer:
Because `x[-which(x > 0)]` is looking for values that are __not__ greater than 0. `x[x <= 0]` is looking for values are __are__ less than 0.

-----------------------------------------------------------------------------------------------------

### 6. What happens when you subset with a positive integer that’s bigger than the length of the vector? What happens when you subset with a name that doesn’t exist?

### Answer:
If you subset with a positive integer that's bigger than the length of the vector then it'll just return the entire vector (unchanged). If you subset with a name that doesn't exist then it'll return `NA`.

-----------------------------------------------------------------------------------------------------

# Section 20.5.4

### 1. Draw the following lists as nested sets:
1. `list(a, b, list(c, d), list(e, f))`
2. `list(list(list(list(list(list(a))))))`

### Answer:
1. This has one outer box and inside of it is stacked 4 other boxes. The first two boxes are stand alone (a, b). The next two are divided into two sections each (c,d) and (e, f), respectively.
2. This is composed of 6 boxes, each box is within it's parent box. There are not boxes stacked on top of each other.

-----------------------------------------------------------------------------------------------------

### 2. What happens if you subset a tibble as if you’re subsetting a list? What are the key differences between a list and a tibble?

### Answer:
You can access tibble data in the same way that you do list. The main differences between a list and a tibble are that tibbles have more restrictions (ex: all elements must be of equal length, all elements must be vectors, you can't use the same name for two different variables)

-----------------------------------------------------------------------------------------------------

# Section 21.2.1

### 1. Write for loops to:
1. Compute the mean of every column in mtcars.
```r
output <- vector("double", ncol(mtcars))
for (i in seq_along(mtcars)) {
  output[[i]] <- mean(mtcars[[i]])
}
```
2. Determine the type of each column in `nycflights13::flights`.
```r
columns <- colnames(flights)
output <- vector("character", ncol(flights))
for (i in 1:length(columns)) {
  output[i] = columns[i]
}
```
3. Compute the number of unique values in each column of `iris`.
```r
output <- vector("numeric", ncol(iris))
for (i in seq_along(iris)) {
  column <- iris[i]
  unique_list <- unique(column)
  output[[i]] <- nrow(unique_list)
}
```
4. Generate 10 random normals for each of mew = -10, 0, 10, and 100.
```r
distribution_vector <- c(-10, 0, 10,100)
for (i in seq_along(distribution_vector)) {
  mean_val <- distribution_vector[i]
  print(rnorm(10, mean_val))
}
```

-----------------------------------------------------------------------------------------------------

### 2. Eliminate the for loop in each of the following examples by taking advantage of an existing function that works with vectors:
```r
out <- ""
for (x in letters) {
  out <- stringr::str_c(out, x)
}

x <- sample(100)
sd <- 0
for (i in seq_along(x)) {
  sd <- sd + (x[i] - mean(x)) ^ 2
}
sd <- sqrt(sd / (length(x) - 1))

x <- runif(100)
out <- vector("numeric", length(x))
out[1] <- x[1]
for (i in 2:length(x)) {
  out[i] <- out[i - 1] + x[i]
}
```

### Answer:
```r
paste(letters, collapse = '')

sd(sample(100))

cumsum(runif(100))
```

-----------------------------------------------------------------------------------------------------

### 3. Combine your function writing and for loop skills:
### Answer:
1. Write a for loop that `prints()` the lyrics to the children’s song “Alice the camel”.
```r
alice_camel_sentences <- function(number) {
  if(number == 0) {
    number <- "no"
  } else {
    number_conversion <- list("one", "two", "three", "four", "five")
    number <- number_conversion[[number]]
  }
  for(i in 1:3) {
    sentence <- paste("Alice the camel has", number, "humps.")
    print(sentence)
  }
}

for(i in 5:0) {
  alice_camel_sentences(i)
  
  if(i > 0) {
    print("So go, Alice, go.")
    print("")
  } else {
    print("Now Alice is a horse.")
  }
}
```

2. Convert the nursery rhyme “ten in the bed” to a function. Generalise it to any number of people in any sleeping structure.
```r
print_verse <- function(number) {
  line_one <- paste("There were", number, "in a bed")
  line_two <- "And the little one said"
  line_three <- "Roll over, roll over"
  line_four <- "So they all rolled over"
  line_five <- "And one fell out"
  print(line_one)
  if(number > 1) {
    print(line_two)
    print(line_three)
    print(line_four)
    print(line_five)
  } else {
    print("And the little one said")
    print("Good night!")
  }
}

ten_in_the_bed <- function(total) {
  for(i in total:1) {
    print_verse(i)
    print("")
  }
}
```

3. Convert the song “99 bottles of beer on the wall” to a function. Generalise to any number of any vessel containing any liquid on any surface.
```r
print_verse <- function(starting_number, number, vessel, liquid, place) {
  if(number > 0) {
    first_line <- paste(number, vessel, "of", liquid, "on the", place, number, vessel, "of", liquid)
    second_line <- paste("Take one down and pass it around,", (number - 1), vessel, "of", liquid, "on the", place)
  } else {
    first_line <- paste("No more", vessel, "of", liquid, "on the", place, number, "more", vessel, "of", liquid)
    second_line <- paste("Go to the store and buy some more,", starting_number, vessel, "of", liquid, "on the", place)
  }
  print(first_line)
  print(second_line)
}

ninety_bottles_of_beer <- function(number) {
  for(i in number:0) {
    print_verse(number, i, "bottles", "beer", "wall")
    print("")
  }
}
```

-----------------------------------------------------------------------------------------------------

### 4. It’s common to see for loops that don’t preallocate the output and instead increase the length of a vector at each step:
```r
output <- vector("integer", 0)
for (i in seq_along(x)) {
  output <- c(output, lengths(x[[i]]))
}
output
```
### How does this affect performance? Design and execute an experiment.

### Answer:
Structuring the loop in this way causes a significant decrease in performance. Meaning, that it takes a lot longer to process/build the new vector. To prove this point I ran the following two pieces of code 3 times each:

```r
x <- c(1:1000)
start_time <- Sys.time()
for (i in seq_along(x)) {
  output <- c(output, lengths(x[[i]]))
}
end_time <- Sys.time()
end_time - start_time
```

```r
x <- c(1:1000)
output <- vector("integer", ncol(x))
start_time <- Sys.time()
for (i in seq_along(x)) {
  output[[i]] <- x[[i]]
}
end_time <- Sys.time()
end_time - start_time
```

Running the first block of un-optimized code resulted in run times of 0.1832931, 0.1306579, and 0.1808679 secs, respectively. Running the optimized code resulted in times of 0.014184, 0.008065939, and 0.008728027 secs, respectively. So, as we can see, the un-optimized code had an average run time of 0.1650 seconds and the optimized code had an average run time of 0.0103 seconds. This shows that the optimized code is about 16 times faster than the un-optimized code.

-----------------------------------------------------------------------------------------------------

# Section 21.3.5

### 1. Imagine you have a directory full of CSV files that you want to read in. You have their paths in a vector, `files <- dir("data/", pattern = "\\.csv$", full.names = TRUE)`, and now want to read each one with `read_csv()`. Write the for loop that will load them into a single data frame.

### Answer:
```r
df <- data.frame(Author=character(), Title=character(), Number.of.pages=numeric()) 
files <- dir("data/", pattern = "\\.csv$", full.names = TRUE)
for (i in files) {
  new_df <- read_csv(i)
  df <- rbind(df, new_df)
}
```

-----------------------------------------------------------------------------------------------------

### 2. What happens if you use `for (nm in names(x))` and `x` has no names? What if only some of the elements are named? What if the names are not unique?

### Answer:
1. If `x` has no names then the loop won't execute and the program will continue on with commands that follow the loop.

2. If only some elements are names then `nm` will result in an empty string for the elements that are not named.

3. If the names are not unique then then `nm` will show the non-unique names more than once during the loop."

-----------------------------------------------------------------------------------------------------

### 3. Write a function that prints the mean of each numeric column in a data frame, along with its name. For example, `show_mean(iris)` would print: (Extra challenge: what function did I use to make sure that the numbers lined up nicely, even though the variable names had different lengths?)
```r
show_mean(iris)
#> Sepal.Length: 5.84
#> Sepal.Width:  3.06
#> Petal.Length: 3.76
#> Petal.Width:  1.20
```

### Answer:
```r
for(nm in names(dplyr::select_if(iris, is.numeric))) {
  column <- iris[nm]
  mean <- colMeans(column, na.rm=T)
  print(mean, digits=3, justify="right")
}
```

-----------------------------------------------------------------------------------------------------