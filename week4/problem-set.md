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