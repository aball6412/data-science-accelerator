library(AppliedPredictiveModeling)
library(e1071)
library(caret)
library(corrplot)
library(dplyr)
data(segmentationOriginal)

# PREPROCESSING
segData <- subset(segmentationOriginal, Case == "Train")
cellID <- segData$Cell
class <- segData$Class
case <- segData$Case
segData <- segData[, -(1:3)]
statusColNum <- grep("Status", names(segData))
segData <- segData[, -statusColNum]

# TRANSFORMATIONS
skewness(segData$AngleCh1)
skewValues <- apply(segData, 2, skewness)
Ch1AreaTrans <- BoxCoxTrans(segData$AreaCh1)

# The original data
head(segData$AreaCh1)
# After transformation
predict(Ch1AreaTrans, head(segData$AreaCh1))

pcaObject <- prcomp(segData, center = TRUE, scale. = TRUE)
# Calculate the cumulative percentage of variance which each component > # accounts for.
percentVariance <- pcaObject$sd^2/sum(pcaObject$sd^2)*100
percentVariance[1:3]

head(pcaObject$x[, 1:5])
head(pcaObject$rotation[, 1:3])

trans <- preProcess(segData, method = c("BoxCox", "center", "scale", "pca"))
print(trans)
# Apply the transformations:
transformed <- predict(trans, segData)
# These values are different than the previous PCA components since > # they were transformed prior to PCA
head(transformed[, 1:5])

# FILTERING
nearZeroVar(segData)
correlations <- cor(segData)
dim(correlations)
correlations[1:4, 1:4]

corrplot(correlations, order = "hclust")
highCorr <- findCorrelation(correlations, cutoff = .75)
length(highCorr)
head(highCorr)
filteredSegData <- segData[, -highCorr]

# CREATING DUMMY VARIABLES
data(cars)
type <- c("convertible", "coupe", "hatchback", "sedan", "wagon")
cars$Type <- factor(apply(cars[, 14:18], 1, function(x) type[which(x == 1)]))
carSubset <- cars[sample(1:nrow(cars), 20), c(1, 2, 19)]
head(carSubset)
levels(carSubset$Type)
simpleMod <- dummyVars(~Mileage + Type, data = carSubset, levelsOnly = TRUE)
print(simpleMod)
predict(simpleMod, head(carSubset))

withInteraction <- dummyVars(~Mileage + Type + Mileage:Type, data = carSubset, levelsOnly = TRUE)
withInteraction
predict(withInteraction, head(carSubset))




