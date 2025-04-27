# Getting and Cleaning Data - module 4 - Peer-Graded Assignment

## Requirements

Required to submit:
1) a tidy data set
2) script for performing the analysis

- see [Scripts/run_analysis.R](./Scripts/run_analysis.R)
- to execute, you can use the `go.sh` bash script
- the script performs ALL steps, including downloading the original raw data

3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md.
4) This README.md, explaining how all of the scripts work and how they are connected.

## Data Provenance

A full description is available at the site where the data was obtained:
- http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
 
The original data for the project:
- https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Tasks Done

- create one R script called run_analysis.R that does the following:
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive variable names. 
  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Processed Data (Output)

- [Data/merged_standard-deviation_and_mean.csv](./Data/merged_standard-deviation_and_mean.csv)
- [Data/merged_means-by-activity-and-subject.txt](./Data/merged_means-by-activity-and-subject.txt)

See the [Code Book](./Data/CodeBook.md).
