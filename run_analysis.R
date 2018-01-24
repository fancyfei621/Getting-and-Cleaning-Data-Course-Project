library(dplyr)

# Download the file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip the file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Reading files
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
features <- read.table('./data/UCI HAR Dataset/features.txt',as.is = TRUE)
activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Merges the training and the test sets to create one data set.
x_merge <- rbind(x_test,x_train)
y_merge <- rbind(y_test,y_train)
subject_merge <- rbind(subject_test,subject_train)
Merge <- cbind(subject_merge,y_merge,x_merge)

#Appropriately labels the data set with descriptive variable names.
colnames(Merge) <- c("subject","activity",features[,2])

#Extracts only the measurements on the mean and standard deviation for each measurement.
Extract <- Merge[,grepl("mean\\(\\)|std\\(\\)|activity|subject",colnames(Merge))]

#Uses descriptive activity names to name the activities in the data set
Extract$activity <- factor(Extract$activity,levels = activity_labels[, 1], labels = activity_labels[, 2])

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Means <- Extract %>% 
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

# output to file "tidy_data.txt"
write.table(Means, "tidy_data.txt", row.names = FALSE, quote = FALSE)








