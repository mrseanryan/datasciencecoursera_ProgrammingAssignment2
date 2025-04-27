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

  print("Read in the test subject ids (apply column names)")
  path_to_test_subjects <- paste(path_to_test, "subject_test.txt", sep = "/")
  test_subjects = read.table(path_to_test_subjects, header = FALSE, col.names = 'Subject')
  # Add the labels as a new column
  test_data['Subject'] = test_subjects['Subject']
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

  print("Read in the train subject ids (apply column names)")
  path_to_train_subjects <- paste(path_to_train, "subject_train.txt", sep = "/")
  train_subjects = read.table(path_to_train_subjects, header = FALSE, col.names = 'Subject')
  # Add the labels as a new column
  train_data['Subject'] = train_subjects['Subject']
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

clean_column_names <- function(new_names) {
  # Replace the first column "" with "Record"
  # new_names[1] <- "Record"

  # De-abbreviate t
  new_names <- sub("^t", "TimeDomainSignal_", new_names)
  new_names <- gsub("angle_t", "angle_TimeDomainSignal_", new_names)

  # De-abbreviate f
  new_names <- sub("^f", "FastFourierTransform_", new_names)

  # De-abbreviate Acc
  new_names <- gsub("Acc", "Acceleration", new_names)

  # De-abbreviate Mag
  new_names <- gsub("Mag", "Magnitude", new_names)

  # De-abbreviate std
  new_names <- gsub("std", "StandardDeviation", new_names)

  # Tidy 'gravity'
  new_names <- gsub("gravity", "Gravity", new_names)

  # 8. Replace (,) with underscores _
  new_names <- gsub("[(),]", "_", new_names)

  # De-abbreviate X/Y/Z
  # - avoid touching the "Y" column itself (second column)
  new_names[-2] <- gsub("-X", "_XAxis", new_names[-2])
  new_names[-2] <- gsub("-Y", "_YAxis", new_names[-2])
  new_names[-2] <- gsub("-Z", "_ZAxis", new_names[-2])

  new_names[-2] <- gsub("_X$", "_XAxis", new_names[-2])
  new_names[-2] <- gsub("_Y$", "_YAxis", new_names[-2])
  new_names[-2] <- gsub("_Z$", "_ZAxis", new_names[-2])

  new_names[-2] <- gsub("_X_", "_XAxis_", new_names[-2])
  new_names[-2] <- gsub("_Y_", "_YAxis_", new_names[-2])
  new_names[-2] <- gsub("_Z_", "_ZAxis_", new_names[-2])

  new_names[-2] <- gsub("angle_tBody", "angle_TimeDomainSignal_Body", new_names[-2])

  # Tidy duplication in names
  new_names <- gsub("-mean", "_mean", new_names)
  new_names <- gsub("BodyBody", "Body", new_names)

  # Tidy underscores
  new_names <- gsub("_+$", "", new_names)
  new_names <- gsub("__+", "_", new_names)
  return(new_names)
}

add_record_column <- function(df) {
  df$Record <- seq(1, nrow(df))
  return(df)
}

sort_columns <- function(df) {
  first_columns <- c("Record", "Subject", "ActivityLabel")

  # Sort the remaining columns alphabetically
  remaining_columns <- setdiff(colnames(df), first_columns)

  remaining_columns_sorted <- sort(remaining_columns)

  new_column_order <- c(first_columns, remaining_columns_sorted)

  # Set the dataframe columns
  df <- df[, new_column_order]
  return(df)
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
  select(Y, contains("std"), contains("mean"), contains("Subject"))
if (is_debug) str_big(selected_columns_data)
short_summary(selected_columns_data)

print_section("3. Uses descriptive activity names to name the activities in the data set.")
print("Read in the activity labels")
path_to_activity_labels <- paste(path_to_data_dir, "activity_labels.txt", sep = "/")
activity_labels = read.table(path_to_activity_labels, header = FALSE, col.names = c('id', 'ActivityLabel'))
selected_columns_data <- selected_columns_data %>%
  mutate(ActivityLabel = activity_labels$ActivityLabel[match(Y, activity_labels$id)])
if (is_debug) str_big(selected_columns_data)

print_section("4. Appropriately labels the data set with descriptive variable names.")
selected_columns_data <- selected_columns_data %>% select(-Y) # drop Y
colnames(selected_columns_data) <- clean_column_names(colnames(selected_columns_data))
selected_columns_data <- add_record_column(selected_columns_data)
selected_columns_data <- sort_columns(selected_columns_data)
path_to_output_dir <- "Data"
path_to_merged_with_std_mean <- paste(path_to_output_dir, "merged_standard-deviation_and_mean.txt", sep = "/")
print(paste("Processed Data (OUTPUT): Saving the merged data ->", path_to_merged_with_std_mean))
write.table(selected_columns_data, path_to_merged_with_std_mean, row.names = FALSE)

print_section("5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.")
print("Filter to mean columns + ActivityLabel, Subject")
selected_columns_data_means <- selected_columns_data %>%
  select(contains("mean"), "ActivityLabel", "Subject")

# print(colnames(selected_columns_data_means))
selected_columns_data_means_grouped <- selected_columns_data_means %>%
  group_by(Subject, ActivityLabel) %>%
  summarise(
    across(
      .cols = where(is.numeric), # Only average numeric columns
      .fns = mean,
      .names = "mean_{.col}"
    ),
    .groups = "drop"
  )
selected_columns_data_means_grouped <- add_record_column(selected_columns_data_means_grouped)
selected_columns_data_means_grouped <- sort_columns(selected_columns_data_means_grouped)

path_to_selected_columns_data_means <- paste(path_to_output_dir, "merged_means-by-activity-and-subject.txt", sep = "/")
print(paste("Processed Data (OUTPUT): Saving the means data, grouped by Activity and Subject ->", path_to_selected_columns_data_means))
write.table(selected_columns_data_means_grouped, path_to_selected_columns_data_means, row.names = FALSE)

print_section("Done - Processed Data")
print(list.files(path_to_output_dir, full.names = TRUE))
