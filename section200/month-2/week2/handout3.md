# Handout 3

### (1) Given that the coefficient of the isMale is 20 times larger than the coefficient of LDL, which feature would you say is of greater “importance” to the model? What should we do to the features if we would like this comparison to be more meaningful?

Because the coefficient for isMale is 20x higher than the coefficient for LDL, the isMale feature will be considered as "more important" to the model. To fix this issue we must normalize the data (center and scale.) By doing this we center all of the numbers around 0 and confine the values to be within a specific (small) range. This will prevent any one feature from dominating other features simply due to having larger values.

-----------------------------------------------------------------------------------------------------

### (2) Which patient presents a greater risk: a male with a healthy LDL or a female with a high LDL?

For a male with a healthy LDL we get `-9 + 1 * 1 + 0.05 * 99 = -3.05`

For a female with a high LDL we get `-9 + 1 * 0 + 0.05 * 161 = -0.95`

So we see that a male with a healthy LDL is at a higher risk of acute myocardial infarction within the next 5 years.

-----------------------------------------------------------------------------------------------------

### (3) If we wished to more directly measure which feature (being male or having an LDL of 160 or more) presented a greater 5 year MI risk by fitting a logistic regression model on relevant patient outcomes data, how could we do that?

First we would need to make sure that we had a feature that explicitly captured observations where the person had an LDL > 160. We would then train a model and then look at the coefficients of the isMale feature and the LDL > 160 feature. The feature that had the highest coefficient would tell us which variable presented the greater 5 year MI risk.

-----------------------------------------------------------------------------------------------------

### (4) It turns out that being male makes a patient more likely to have a high LDL (we say that isMale is positively correlated with LDL). How might this confuse the way that we can interpret the coefficients?

This could confuse how we interpret the coefficients by causing us to __think__ that one variable is providing some prediction value, when in fact it's just a side effect of another (true) predictor. In this example, one might conclude that simply being male causes one to be at a greater MI risk. However, in reality it's really LDL levels that is causing the greater risk and being a "male" just happens to correlate with higher levels of LDL.

-----------------------------------------------------------------------------------------------------

### (5) As an extreme example imagine that LDL appeared twice in the model (that is, we now have two features with perfect correlation). The model now can be written as:

```
M (isMale, LDL) = f (−9 + 1 · isMale + β1 · LDL1 + β2 · LDL2 )
```

### what could the values of the new coefficients β1 and β2 be?

β1 and β2 could be different values. Of course, this would be a nonsensical result because the same exact feature __should__ have the same exact predictive value (β) within the model. But training this model would allow those values to be different (and they would be.) Therefore, we would get a nonsensical model/result.

-----------------------------------------------------------------------------------------------------

### (6) Another consideration when assessing heart health is the patient’s HDL cholesterol, which evidence suggests has a protective effect on the cardiovascular system (that is, a higher HDL is indicative of better heart health). If we fit a model with HDL cholesterol (as well as the existing isMale and LDL features), what sign would you expect the coefficient of the HDL term to have?

You would expect the coefficient of the HDL term to have a negative sign. This is because theoretically, as HDL increases the likelyhood of 5 year MI risk should decrease (hence the negative coefficient sign would cause the models estimate to be lower than it otherwise would have been)

-----------------------------------------------------------------------------------------------------

### (7) If a new study suggested that HDL cholesterol was more protective for women than men, how might we adjust the model to account for this?

To adjust for this we could either add some additional multiplier to the HDL coefficent that only got applied if the patient was a female, or we could create a brand new feature that was 0 if the patient was male, but was the HDL value if the patient was female. This would have the effect of further lowering the MI risk for females, but not for males.

-----------------------------------------------------------------------------------------------------

### (8) Suppose that we would now like to model the risk of a hospital inpatient having an adverse event during their stay - such an adverse event could have multiple causes, but we’ll define it as an event that results in a transfer to an ICU or in death. The features for this model will be: temperature, systolic BP, respiration rate, and heart rate. Can we model this event in the way described above? How might we rather model this?

Yes we could model this event though these features might be effects of death or going to the ICU rather than good predictors in and of themselves. It would probably serve us better to combine these features with other features in order to create a more predictive model.

-----------------------------------------------------------------------------------------------------

### (9) Respiration rate is often null for for hospital inpatients. Do you think that this information is structurally missing? How should it be imputed?

Yes, this information is structurally missing because this value isn't always measured for hospital inpatients. You can assume that there is some value there granted that the patient is alive. One way that we could impute this value is by creating a KNN model to estimate this value based on the other values that were actually observed.



