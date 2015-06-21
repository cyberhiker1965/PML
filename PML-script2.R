library(AppliedPredictiveModeling)
library(caret)

# First download the training / testing datasets if they have 
# not already been downloaded

setwd("C:/Users/david/datasciencecoursera/Practical Machine Learning/Week2/Project")
testFile <- "pml-testing.csv"
testURL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"


if(!file.exists(testFile)) {
  download.file(testURL, destfile=testFile)
}


# read in the file - several values are standardized to NA

testData <- read.csv(testFile, na.strings = c("#DIV/0!","","NA"))


# remove constant columns not needed for training
testData <- subset(testData, 
                       select = -c(X,user_name,raw_timestamp_part_1, 
                                   raw_timestamp_part_2, cvtd_timestamp, new_window,num_window) )

# Remove the same NA containing columns as was done with 
# the training dataset
testData <- testData[, !names(testData) %in% NAcolsToDrop]

testPC2 <- predict(modelFit,newdata=testData)

answers <- as.character(testPC2)

pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

pml_write_files(answers)
