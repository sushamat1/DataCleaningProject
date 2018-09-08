# Data files to be read
featuresFile <- "./features.txt"
activityLabelsFile <- "./activity_labels.txt"
testSubjectsFile <- "./test/subject_test.txt"
testActivitiesFile <- "./test/y_test.txt"
testDataFile <- "./test/X_test.txt"
trainDataFile <- "./train/X_train.txt"
trainActivitiesFile <- "./train/y_train.txt"
trainSubjectsFile <- "./train/subject_train.txt"
# Read test data and activites and subjects files
columnNames <- read.table(featuresFile, sep = " ")
testData <- read.table(testDataFile, col.names = columnNames[,2])
testActivities <- read.table(testActivitiesFile, col.names = "Activity")
testSubjects <- read.table(testSubjectsFile, col.names = "Subject")
# Combine test data with subjects and activites
testData <- cbind(testActivities, testData)
testData <- cbind(testSubjects, testData)
# Read training data and activites and subjects files
trainData <- read.table(trainDataFile, col.names = columnNames[,2])
trainActivities <- read.table(trainActivitiesFile, col.names = "Activity")
trainSubjects <- read.table(trainSubjectsFile, col.names = "Subject")
# Combine training data with subjects and activites
trainData <- cbind(trainActivities, trainData)
trainData <- cbind(trainSubjects, trainData)
# Merge test and training data sets
data <- rbind(testData, trainData)
# Extract the mean and standard deviation measurements for each measurement.
meanandstdData <- data[grepl("Activity|Subject|mean|std", names(data))]
# Read activity labels and replace activity numbers with activity labels
activityLabels <- read.table(activityLabelsFile, col.names = c("activityNum", "activityName"))
meanandstdData$Activity <- activityLabels$activityName[ match(meanandstdData$Activity, activityLabels$activityNum)]
# Get average of each variable for each activity and each subject
meanAggregateData <- aggregate(meanandstdData[,-which(names(meanandstdData) %in% c("Subject", "Activity"))], 
                           list(Subjet=meanandstdData$Subject, Activity=meanandstdData$Activity), mean)
write.table(meanAggregateData, "meanData.txt", row.names=FALSE)
