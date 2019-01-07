# Handout 2

The following should be completed after reading Chapter 2 (A short tour of the predictive modeling process) of Applied Predictive Modeling.

### (1) In the “fuel economy” example, the concept of a linear and non-linear relationship between variables are introduced. Can you think of examples of some linear and non-linear relationships you would expect to see in data at Red Ventures?

1. An example of a linear relationship would be the number of clicks on a product offering and revenue.
2. An example of a non-linear relationship would (potentially) be time spent on site and revenue. The thinking being that the longer someone explored the site they more likely they were to make a purchase up to a certain point. After that point increased time on site probably means that they are undecided and less likely to make a purchase.

### (2) A decision tree model is a simple and popular type of model. In the case of a 1-dimensional feature space, the model has the form (see handout pdf). Would you describe this as a linear or non-linear model?

It does appear that there is a linear relationship since higher values of x would create a linear increase in output.

### (3) We were introduced to the notion of RMSE in this section. Does RMSE make sense for binary classification tasks? (That is, tasks where the label for each data point is 0 or 1) How else might you quantify performance of a classification model?

This wouldn't make sense for a classification problem. You would need to find the error on a different type of function, like a sigmoid.

