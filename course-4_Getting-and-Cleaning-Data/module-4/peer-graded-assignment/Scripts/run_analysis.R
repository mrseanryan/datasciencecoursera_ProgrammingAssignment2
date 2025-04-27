source("Scripts/utils.download.R")
source("Scripts/utils.print.R")
source("Scripts/utils.tryCatch.R")

print_section("Getting and Cleaning Data - Wearable Computing")

is_debug <- FALSE

data_file <- "UCI_HAR_Dataset.zip"
data_dir <- "temp"
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
path_to_zip_file <- download_if_missing(data_dir, data_file, data_url)

path_to_unzipped <- paste(data_dir, "UCI_HAR_Dataset", sep = "/")
if (!dir.exists(path_to_unzipped)) {
  unzip(path_to_zip_file, exdir = path_to_unzipped)
}

print(list.files(path = path_to_unzipped))

path_to_data_dir <- paste(path_to_unzipped, "UCI HAR Dataset", sep = "/")

get_merged_data <- function() {
  print("Read in the features (column names)")
  path_to_test <- paste(path_to_data_dir, "test", sep = "/")
  path_to_train <- paste(path_to_data_dir, "train", sep = "/")

  path_to_features <- paste(path_to_data_dir, "features.txt", sep = "/")

  colnames_data <- read.table(path_to_features, stringsAsFactors = FALSE)
  colnames <- colnames_data$V2

  print("Read in the test data (apply column names)")
  path_to_test_data <- paste(path_to_test, "X_test.txt", sep = "/")
  # Since data is space-separated and wide, read it as whitespace-delimited
  test_data <- read.table(path_to_test_data)
  colnames(test_data) <- colnames

  print("Read in the test labels (apply column names)")
  path_to_test_labels <- paste(path_to_test, "y_test.txt", sep = "/")
  test_labels = read.table(path_to_test_labels, header = FALSE, col.names = 'Y')
  # Add the labels as a new column
  test_data['Y'] = test_labels['Y']
  if (is_debug) str_big(test_data)

  print("Read in the training data (apply column names)")
  path_to_train_data <- paste(path_to_train, "X_train.txt", sep = "/")
  # Since data is space-separated and wide, read it as whitespace-delimited
  train_data <- read.table(path_to_train_data)
  colnames(train_data) <- colnames

  print("Read in the test labels (apply column names)")
  path_to_train_labels <- paste(path_to_train, "y_train.txt", sep = "/")
  train_labels = read.table(path_to_train_labels, header = FALSE, col.names = 'Y')
  # Add the labels as a new column
  train_data['Y'] = train_labels['Y']
  if (is_debug) str_big(train_data)

  print_section("Merge Test and Train data")
  # install_if_missing("dplyr")
  # library(dplyr)
  # merged_data = merge(test_data, train_data, by.x="solution_id", by.y="id", all=TRUE)  # all is like a left join (makes NAs for missing values)
  merged_data <- rbind(test_data, train_data)

  return(merged_data)
}

load_or_get_merged_data <- function() {
    # optimization for repeated runs - reload the data from a previous run
    path_to_merged_dir <- paste(path_to_data_dir, "merged")
    path_to_merged_data <- paste(path_to_merged_dir, "merged-data.rds", sep = "/")

    if (file.exists(path_to_merged_data)) {
        print("Reading previously merged data")
        return(readRDS(path_to_merged_data))
    }

    my_data <- get_merged_data()
    print("Saving merged data, for future runs")

    if (!dir.exists(path_to_merged_dir)) {
        dir.create(path_to_merged_dir)
    }
    saveRDS(my_data, path_to_merged_data)
    return(my_data)
}

print_section("1. Merges the training and the test sets to create one data set.")
print_section("Read Test and Train data")
merged_data <- load_or_get_merged_data()
if (is_debug) str_big(merged_data)
short_summary(merged_data)

print_section("2. Extracts only the measurements on the mean and standard deviation for each measurement.")
install_if_missing("dplyr")
suppressMessages(library(dplyr))
selected_columns_data <- merged_data %>%
  select(Y, contains("std"), contains("mean"))
if (is_debug) str_big(selected_columns_data)
short_summary(selected_columns_data)

print_section("3. Uses descriptive activity names to name the activities in the data set.")

print_section("4. Appropriately labels the data set with descriptive variable names.")

print_section("5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.")
