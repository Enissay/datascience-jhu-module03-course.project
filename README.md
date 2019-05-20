# datascience-jhu-module03-course.project
Getting and Cleaning Data: Final Course Project

## Course Project Requirements

You should create an R script called ```run_analysis.R``` which perfoms the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## How To

1. Download this code in your working directory and run it in RStudio
2. It will automatically download the zip file and unzip it
3. It will export the aggregated results to a new file ```aggregatedData.txt``` in the same working directory

## Dependencies

The code will check and install if needed the necessary dependencies ```data.table``` and ```dplyr```, then it loads them automatically.
