Getting and Cleaning Data Project
=========================================

Introduction
------------
This repository contains the code for the course project "Getting and Cleaning data", part of the Data Science specialization from Coursera.

Analysis Script
--------------
The R script called run_analysis.R performs the required job.
   o Reads train and test data sets and merges them
   o Extracts only the measurements on the mean and standard deviation for the measured variables.
   o Appropriately labels the data set with descriptive activity names.
   o Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
   o Writes the tidy data set to a file tidydata.txt."
 
 
Raw data set
--------------

The features (561 of them) are unlabeled and can be found in the x_test.txt. 
The activity labels are in the y_test.txt file.
The test subjects are in the subject_test.txt file.

The same holds for the training set.


Script Workflow 
-----------------
Using the script:
source ("./run_analysis.R"")

The script first downloads the compressed data file and extracts the relevant
files in a working directory. The data files for the test and training sets are
then merged together.  

Labels are added to the merged data to make it more descriptive. From the merged
data, a subset of the data is selected with measurement columns cotaining
only information on mean and standard deviations.

Lastly, the script creates a tidy data set containing the means of all the columns per test subject and per activity.

This tidy dataset is written to a tab-delimited file called tidydata.txt, which can also be found in this repository.

About the Code Book
-------------------
The CodeBook.md file provides information about the raw data, variables and the transformations performed and the resulting data and variables.

