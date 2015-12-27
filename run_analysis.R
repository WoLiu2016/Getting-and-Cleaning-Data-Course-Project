##download the data for the project and unzip it.
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("dataset.zip")) {
        download.file(url, destfile = "dataset.zip")
}
if (!file.exists("UCI HAR Dataset")) {
        unzip("dataset.zip")
}

##create "test" dataset
library(data.table)

features <- read.table("./UCI HAR Dataset/features.txt")

if (!file.exists("test")) {
        X_test<-read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$V2)
        y_test<- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activity")
        subject_test<- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "id")
        test<- cbind(subject_test,y_test,X_test)
}

##Create "train" dataset
if (!file.exists("train")){
        X_train<-read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$V2)
        y_train<- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activity")
        subject_train<- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "id")
        train<- cbind(subject_train,y_train,X_train)
}

##1. Merges the training and the test sets to create one data set.
library(plyr)
data<- rbind(test, train)

##2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_and_std <- data[,c(1,2,grep("std", colnames(data)), grep("mean", colnames(data)))]
write.csv(mean_and_std, "./mean_and_std.csv")

##3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

##4. Appropriately labels the data set with descriptive variable names. 
mean_and_std$activity <- factor(mean_and_std$activity, levels=activity_labels$V1, labels=activity_labels$V2)

##5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_dataset <- ddply(mean_and_std, .(id, activity), .fun=function(x){ colMeans(x[,-c(1:2)]) })
colnames(tidy_dataset)[-c(1:2)] <- paste(colnames(tidy_dataset)[-c(1:2)], "_mean", sep="")
write.csv(tidy_dataset, "./tidy_dataset.csv")


