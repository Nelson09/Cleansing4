# This R package is written for Getting and Cleaning Data Course Project
# In order to run this package the necessary path  should be modified in this script.

fpath <- "C:\\NelsonRepo\\Technical\\DataScience\\cleaningdata_week4\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset"
setwd(fpath)

###Load required packages
library(dplyr)
library(data.table)
library(tidyr)


# All the necessary files has be downloaded in the local machine

# reading subject train and test files

subject_train <- tbl_df(read.table(file.path(fpath, "train", "subject_train.txt")))
subject_test  <- tbl_df(read.table(file.path(fpath, "test" , "subject_test.txt" )))


# Reading activity files

ActivityTrain_Y <- tbl_df(read.table(file.path(fpath, "train", "Y_train.txt")))
ActivityTest_Y  <- tbl_df(read.table(file.path(fpath, "test" , "Y_test.txt" )))

#Reading data files.

Train_X <- tbl_df(read.table(file.path(fpath, "train", "X_train.txt" )))
Test_X  <- tbl_df(read.table(file.path(fpath, "test" , "X_test.txt" )))

# Merge activity and Subject files and rename variables "subject" and "activityNum"
allsubject <- rbind(subject_train, subject_test)
setnames(allsubject, "V1", "subject")
allactivity<- rbind(ActivityTrain_Y, ActivityTest_Y)
setnames(allactivity, "V1", "activityNum")


#combine training and test files
datatable <- rbind(Train_X, Test_X)

# name variables according to feature 
datafeatures <- tbl_df(read.table(file.path(fpath, "features.txt")))
setnames(datafeatures, names(datafeatures), c("featureNum", "featureName"))
colnames(datatable) <- datafeatures$featureName


#column names for activity labels
activitylabels<- tbl_df(read.table(file.path(fpath, "activity_labels.txt")))
setnames(activitylabels, names(activitylabels), c("activityNum","activityName"))

# Merge columns
allSubjAct<- cbind(allsubject, allactivity)
datatable <- cbind(allSubjAct, datatable)

# Reading "features.txt" and extracting  mean and standard deviation
featuresMeanStd <- grep("mean\\(\\)|std\\(\\)",datafeatures$featureName,value=TRUE) 
featuresMeanStd <- union(c("subject","activityNum"), featuresMeanStd)
datatable<- subset(datatable,select=featuresMeanStd) 

##enter name of activity into dataTable
datatable <- merge(activitylabels, datatable , by="activityNum", all.x=TRUE)
datatable$activityName <- as.character(datatable$activityName)


## sort by subject and Activity
datatable$activityName <- as.character(datatable$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = datatable, mean) 
datatable<- tbl_df(arrange(dataAggr,subject,activityName))


names(datatable)<-gsub("std()", "SD", names(datatable))
names(datatable)<-gsub("mean()", "MEAN", names(datatable))
names(datatable)<-gsub("^t", "time", names(datatable))
names(datatable)<-gsub("^f", "frequency", names(datatable))
names(datatable)<-gsub("Acc", "Accelerometer", names(datatable))
names(datatable)<-gsub("Gyro", "Gyroscope", names(datatable))
names(datatable)<-gsub("Mag", "Magnitude", names(datatable))
names(datatable)<-gsub("BodyBody", "Body", names(datatable))

##write to text file on disk
write.table(datatable, "OutputData.txt", row.name=FALSE)