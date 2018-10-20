data("mtcars")
myName <- "Aaron Thompkins"
mtcarsColumns <- names(mtcars)
mtcarsSummary <- head(mtcars)
dratValue <- 3.08
topQsec <- head(mtcars[order(-mtcars$qsec),])