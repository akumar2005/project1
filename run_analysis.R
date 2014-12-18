# run_analysis.R
# course project : Getting and Cleaning Data

# Step 1: Get the data
# Download the data compressed in a zip file
# from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# Get the relevant files into a folder named "project" in your working directory

if(!file.exists("./project")){dir.create("./project")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./project/AnalysisData.zip",method="curl")
unzip(zipfile="./project/AnalysisData.zip",exdir="./project")
filesArea <- file.path("./project" , "UCI HAR Dataset")
#files<-list.files(filesArea, recursive=TRUE)
#files


# Step 2: Read the data files to be used for the analysis

#Subject Files
subTrain <- read.table(file.path(filesArea, "train", "subject_train.txt"),header = FALSE)
subTest  <- read.table(file.path(filesArea, "test" , "subject_test.txt"),header = FALSE)

#Activity files
yTrain <- read.table(file.path(filesArea, "train", "Y_train.txt"),header = FALSE)
yTest  <- read.table(file.path(filesArea, "test" , "Y_test.txt" ),header = FALSE)
xTrain <- read.table(file.path(filesArea, "train", "X_train.txt"),header = FALSE)
xTest  <- read.table(file.path(filesArea, "test" , "X_test.txt" ),header = FALSE)

#Features 
features <- read.table(file.path(filesArea, "features.txt"),head=FALSE)

#activity labels
activities <- read.table(file.path(filesArea, "activity_labels.txt"),head=FALSE)


# Step 3: Merge the Test and Train data files to create one data set
#merge the data tables by rows
xComb <- rbind(xTrain, xTest)
yComb <- rbind(yTrain, yTest)
subComb <- rbind(subTrain, subTest)

#Name the measurement columns
names(subComb)<-c("subject")
names(yComb)<-c("activity")
names(xComb)<-features$V2

#Merge the columns to get the data frame of full data set
MergedData <- cbind(subComb, yComb, xComb)


#Step 4: Create a new data frame with measurement columns cotaining
# only information on mean and standard deviations for each measurement

#Get only the data on mean and std.dev.
Means <- grep("mean()", colnames(MergedData))
SDs <- grep("std()", colnames(MergedData))
NewCols <- c(Means, SDs)
NewCols <- sort(NewCols) 
subsetData <- MergedData[, c(1,2,NewCols)]
#get rid of the meanFreq columns
subsetData <- subsetData[, !grepl("Freq", colnames(subsetData))]

# Use descriptive activity names to name the activities in the dataset

subsetData$activity[subsetData$activity==1] = "WALKING"
subsetData$activity[subsetData$activity==2] = "WALKING_UPSTAIRS"
subsetData$activity[subsetData$activity==3] = "WALKING_DOWNSTAIRS"
subsetData$activity[subsetData$activity==4] = "SITTING"
subsetData$activity[subsetData$activity==5] = "STANDING"
subsetData$activity[subsetData$activity==6] = "LAYING"

#Appropriately label the data set with descriptive variable names
names(subsetData)<-gsub("^t", "time", names(subsetData))
names(subsetData)<-gsub("^f", "frequency", names(subsetData))
names(subsetData)<-gsub("Acc", "Accelerometer", names(subsetData))
names(subsetData)<-gsub("Gyro", "Gyroscope", names(subsetData))
names(subsetData)<-gsub("Mag", "Magnitude", names(subsetData))
names(subsetData)<-gsub("BodyBody", "Body", names(subsetData))


#Step 6: create a second tidy independent data set
# find the mean for each combination of subject and activity.

library(plyr);
tidyData <- aggregate(subsetData[, 3:ncol(subsetData)],
                       by=list(subject = subsetData$subject,
                               activity = subsetData$activity), mean)
tidyData<-tidyData[order(tidyData$subject,tidyData$activity),]
write.table(tidyData, file = "./project/tidydata.txt", row.name=FALSE)
