setwd("~/Desktop/dss")

if (!file.info("UCI HAR Dataset")$isdir) { 
filesrc<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(filesrc, "ucih_dataset.zip",method = "curl")
unzip("./ucih_dataset.zip")
}

## Merge training and tests data to obtain a new dataset

xtrain_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
xtest_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
xtt_data <- rbind(xtrain_data,xtest_data)

ytrain_data <- read.table("./UCI HAR Dataset/train/y_train.txt")
ytest_data <- read.table("./UCI HAR Dataset/test/y_test.txt")
ytt_data <- rbind(ytrain_data,ytest_data)

strain_data <- read.table("./UCI HAR Dataset/train/subject_train.txt")
stest_data <- read.table("./UCI HAR Dataset/test/subject_test.txt")
stt_data <- rbind(strain_data,stest_data)

## Extract data with mean and standard deviation measurements
featureData <- read.table("./UCI HAR Dataset/features.txt")
mean_sd_data <- grep("-mean\\(\\)|-std\\(\\)",featureData[, 2])
x_mean_sd_data <- xtt_data[, mean_sd_data]

## Use description of activity names to name activities in dataset
names(x_mean_sd_data) <- featureData[mean_sd_data, 2]
names(x_mean_sd_data) <- tolower(names(x_mean_sd_data)) 
names(x_mean_sd_data) <- gsub("\\(|\\)", "", names(x_mean_sd_data))

activityData <- read.table("./UCI HAR Dataset/activity_labels.txt")
activityData[, 2] <- tolower(as.character(activityData[, 2]))
activityData[, 2] <- gsub("_", "", activityData[, 2])

ytt_data[, 1] = activityData[ytt_data[, 1], 2]
colnames(ytt_data) <- 'activity'
colnames(stt_data) <- 'subject'

# Appropriately labels the data set with descriptive activity names.
data <- cbind(stt_data, x_mean_sd_data, ytt_data)
str(data)
write.table(data, './merged_data.txt', row.names = F)

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
average_df <- aggregate(x=data, by=list(activities=data$activity, subj=data$subject), FUN=mean)
average_df <- average_df[, !(colnames(average_df) %in% c("subj", "activity"))]
str(average_df)
write.table(average_df, './average_data.txt', row.names = F)

