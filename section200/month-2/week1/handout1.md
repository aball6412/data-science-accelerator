# Handout 1

The following should be completed after reading Chapter 1 (Introduction) of Applied Predictive Modeling.

### (1) What are some prediction tasks of interest to Red Ventures?
1. Predicting an optimal bid for google adwords
2. Predicting whether a certain visitor will convert on a particular offer or not.
3. Determining the offer that particular customer is the most likely to convert on.
4. Determine what content is most relevant for a visitor to a site.

### (2) Can you think of an RV prediction tasks where interpretability should take precedence over prediction accuracy?
1. Determining what content is most relevant for a visitor to a site is an example of this because we don't only need to show the most relevant content, but also, know __why__ that content is relevant to the user. Knowing the why would enable us to create more content like it in the future.

### (3) Can you think of any heuristics for deciding when one might favor interpretability over prediction accuracy or vice versa?
When being able to interpret a particular result would then allow us to take furher MANUAL action (example create more similar articles, or give detailed analysis to prospective vendors to convince them to join our platform) then interpretability should be valued over prediction accuracy. However, if simply making the prediction accurately is the extent of our goals then we should value accuracy over interpretability.

### (4) The authors give four common reasons why models fail - stating that the most important reason (in their opinion) is ”over-fitting.” Do some research to come up with your own definition of over-fitting and some ways you might diagnose and overcome this problem.
Overfitting is where the model "memorizes" the training dataset, and does not provide a good prediction for the test dataset. One would know that over-fitting is a problem if the model performs very differently on the training vs. test data. Example, it might perform very well on the training data, but when making predictions off of the test data it does not perform nearly as well.