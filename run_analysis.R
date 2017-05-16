library(reshape2)

#Merges the training and the test sets to create one data set.

setwd("~/R Projects/tidyCourseProject/UCI HAR Dataset/train")

# Load train datasets
trainX <- read.table("X_train.txt")
trainY <- read.table("y_train.txt")
trainSubject <- read.table("subject_train.txt")
trainer <- cbind(trainSubject, trainY, trainX)

setwd("~/R Projects/tidyCourseProject/UCI HAR Dataset/test")

# Load test datasets
testX <- read.table("X_test.txt")
testY <- read.table("y_test.txt")
testSubject <- read.table("subject_test.txt")
tester <- cbind(testSubject, testY, testX)

# merge datasets
mergeData <- rbind(trainer, tester)

setwd("~/R Projects/tidyCourseProject/UCI HAR Dataset/")

#Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

measurements <- grep(".*mean.*|.*std.*", features[,2])
measurements.names <- features[measurements,2]
measurements.names = gsub('-mean', 'Mean', measurements.names)
measurements.names = gsub('-std', 'Std', measurements.names)
measurements.names <- gsub('[-()]', '', measurements.names)

#Uses descriptive activity names to name the activities in the data set
colnames(mergeData) <- c("subject", "activity", measurements.names)

#Appropriately labels the data set with descriptive variable names.
activityLabels <- read.table("activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])

mergeData$activity <- factor(mergeData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
mergeData$subject <- as.factor(mergeData$subject)

#creates a second, independent tidy data set with the average of each variable for each activity and each subject.
mergeData.melted <- melt(mergeData, id = c("subject", "activity"))
mergeData.mean <- dcast(mergeData.melted, subject + activity ~ variable, mean)

write.table(mergeData.mean, "~/R Projects/tidyCourseProject/tidy.txt", row.names = FALSE, quote = FALSE)