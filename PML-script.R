# Machine Learning Project

# enable multi-core processing
library(doParallel)
cl <- makeCluster(detectCores())
registerDoParallel(cl)

library(AppliedPredictiveModeling)
library(caret)

# First download the training / testing datasets if they have 
# not already been downloaded

setwd("C:/Users/david/datasciencecoursera/Practical Machine Learning/Week2/Project")
trainingFile <- "pml-training.csv"
trainingURL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
testFile <- "pml-testing.csv"
testURL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"


if(!file.exists(trainingFile)) {
  download.file(trainingURL, destfile=trainingFile)
}

if(!file.exists(testFile)) {
  download.file(testURL, destfile=testFile)
}

# read in the file - several values are standardized to NA

trainingData <- read.csv(trainingFile, na.strings = c("#DIV/0!","","NA"))

# remove constant columns not needed for training
trainingData <- subset(trainingData, 
                       select = -c(X,user_name,raw_timestamp_part_1, 
                       raw_timestamp_part_2, cvtd_timestamp, new_window,num_window) )

# get names of columns with a large number of NAs

NAcolsToDrop <- colnames(trainingData)[colSums(is.na(trainingData)) > nrow(trainingData) * 0.97]

#trainingData <- subset( trainingData,
#                        select = -c(NAcolsToDrop) )

trainingData <- trainingData[, !names(trainingData) %in% NAcolsToDrop]

set.seed(3433)
inTrain = createDataPartition(trainingData$classe, p = 0.25, list=FALSE)
training = trainingData[inTrain,]
testing = trainingData[-inTrain,]

#preProc <- preProcess(training[,1:52], method="pca",thresh=0.8)
#trainPC <- predict(preProc, training[,1:52])
#modelFit2 <- train( training$classe ~ ., data=trainPC,method="rpart")
#testPC <- predict(preProc, testing[,1:52])
#confusionMatrix(testing$classe, predict(modelFit2,testPC))


modelFit <- train( classe ~ ., data=training, method="rf")
testPC1 <- predict(modelFit,newdata=testing)
confusionMatrix(testing$classe, testPC1)



stopCluster(cl)
# The stopCluster is necessary to terminate the extra processes
