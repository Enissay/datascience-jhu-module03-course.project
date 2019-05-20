#Set Working Directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))  ## In RStudio ONLY !! Sets the working DIR to the directory of the current .R script


# Load the needed libs
packages <- c("data.table", "dplyr")

# check to see if packages are installed. Install them if they are not, then load them into the R session.
ipak <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg)) 
        install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
}
ipak(packages)


## Data download and unzip 
fileName <- "UCIdata.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

dir <- "UCI HAR Dataset"

# If file does not exist, download to working directory.
if(!file.exists(fileName)){
    download.file(url,fileName, mode = "wb") 
}

# If the directory does not exist, unzip the downloaded file.
if(!file.exists(dir)){
    unzip("UCIdata.zip", files = NULL, exdir=".")
}


### 1. Merges the training and the test sets to create one data set.
# Load data
features        <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
activityLabel   <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)

subjectTrain    <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
xTrain          <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
yTrain          <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)

subjectTest    <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
xTest          <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
yTest          <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)


# Rename Columns
colnames(yTrain) <- "activity"
colnames(subjectTrain) <- "subject"
colnames(xTrain) <- features[,2]                        # Skip column 1 ==> row counter

colnames(yTest) <- "activity"
colnames(subjectTest) <- "subject"
colnames(xTest) <- features[,2]

# Merge data
trainData <- cbind(subjectTrain,yTrain,xTrain)
testData <- cbind(subjectTest,yTest,xTest)

mergedData <- rbind(trainData,testData)


### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Remove duplicate Column Names (needed for the following select statement)
mergedData <- subset(mergedData, select=which(!duplicated(names(mergedData)))) 

finalData <- mergedData  %>%  
                select(subject, activity, contains("mean", ignore.case = T), contains("std", ignore.case = T))


### 3. Uses descriptive activity names to name the activities in the data set (replace activityID with the corresponding activityLabel)
finalData$activity <- activityLabel[finalData$activity, 2]               


### 4. Appropriately labels the data set with descriptive variable names.
names(finalData) <- gsub("Acc", "Accelerometer", names(finalData), ignore.case = TRUE)                  #  will replace Acc showing up anywhere in the string
names(finalData) <- gsub("Gyro", "Gyroscope", names(finalData), ignore.case = TRUE)
names(finalData) <- gsub("Mag", "Magnitude", names(finalData), ignore.case = TRUE)
names(finalData) <- gsub("gravity", "Gravity", names(finalData), ignore.case = TRUE)
names(finalData) <- gsub("BodyBody", "Body", names(finalData), ignore.case = TRUE)

names(finalData) <- gsub("-?mean(?:\\(\\))?", "Mean", names(finalData), ignore.case = TRUE)             #  will replace: -mean, mean(), -mean()
names(finalData) <- gsub("-?freq(?:\\(\\))?", "Frequency", names(finalData), ignore.case = TRUE)
names(finalData) <- gsub("-std\\(\\)", "STD", names(finalData), ignore.case = TRUE)

names(finalData) <- gsub("^t", "time", names(finalData), ignore.case = TRUE)                            #  will replace t showing up at the start of string
names(finalData) <- gsub("^f", "frequency", names(finalData), ignore.case = TRUE)


### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
aggregatedData <- finalData %>%
                    group_by(subject, activity) %>%
                        summarise_all(list(mean))

# Export data to file
write.table(aggregatedData, "aggregatedData.txt", row.name=FALSE)
