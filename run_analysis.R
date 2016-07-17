## Set the folder
print("Set the folder where you want put the data.\n Press enter for default")
temp <- readline()
f <- getwd()
if (!temp==""){  setwd(a)}

## Download zip file and unzip
if(!file.exists("./data")) dir.create("./data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/dataset.zip")
listZip <- unzip("./data/dataset.zip", exdir = "./data")

## Load data into R
x.train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y.train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject.train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x.test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y.test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject.test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

## Merge all the train and test data
x.all <- rbind(x.train,x.test)
y.all <- rbind(y.train,y.test)
subject.all <- rbind(subject.train,subject.test)

## Extracts only the measurements on the mean and standard deviation
data.all <- x.all[grep(("mean\\(\\)|std\\(\\)"), features)]
data.all <- cbind(subject.all,y.all,data.all)

## Labels the data set with descriptive variable names.
onlyfeatures <- features[grep(("mean\\(\\)|std\\(\\)"), features)]
onlyfeatures <- c("subject","activity",onlyfeatures)
onlyfeatures <- gsub("\\()", "", onlyfeatures)
onlyfeatures <- gsub("^t", "Time", onlyfeatures)
onlyfeatures <- gsub("^f", "Frequence", onlyfeatures)
onlyfeatures <- gsub("-mean", "Mean", onlyfeatures)
onlyfeatures <- gsub("-std", "Std", onlyfeatures)
onlyfeatures <- gsub("-", "", onlyfeatures)

## Uses descriptive activity names to name the activities in the data set
names(data.all) <- onlyfeatures
data.all$activity <- factor(data.all$activity, levels = activity[,1], labels = activity[,2])

## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
groupdata <- data.all %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(groupdata, "./data/MeanData.txt", row.names = FALSE)

setwd(f)
