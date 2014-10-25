library(data.table)
library(dplyr)
getwd()
##download the data and unzip the data
File<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(File, destfile="Dataset.zip")
unzip("Dataset.zip")
list.files("./")
TestData<-read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
TestDataAct<-read.table("./UCI HAR Dataset/test/y_test.txt",header = FALSE)
TestDataSub<-read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
TrainData<-read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
TrainDataAct<-read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
TrainDataSub<-read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)

## 3 Rename the activities of each data with the activity labels
names<-read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, colClasses="character")
head(TestDataAct,5)
head(TestDataSub,5)
names
TestDataAct$V1<-factor(TestDataAct$V1, levels=names$V1, labels=names$V2)
TrainDataAct$V1<-factor(TrainDataAct$V1, levels=names$V1, labels=names$V2)

## 4 Rename the columns from the Test Data and Train Data with the features
feature<-read.table("./UCI HAR Dataset/features.txt", header=FALSE, colClasses="character")
head(feature,5)
colnames(TestData)<-feature$V2
colnames(TrainData)<-feature$V2

## Change the column names for each file with Activiy and Subject
colnames(TestDataAct)<-c("Activity")
head(TestDataAct,5)
colnames(TestDataSub)<-c("Subject")
head(TestDataSub,5)
colnames(TrainDataAct)<-c("Activity")
head(TrainDataAct,5)
colnames(TrainDataSub)<-c("Subject")
head(TrainDataSub,5)
tail(TrainDataSub,5)

## 1.  Merges the training and the test sets to create one data set.
## Merge the datas of Test first then Train and finally both
MergeDataTest<-cbind(TestData, TestDataAct)
MergeDataTest<-cbind(MergeDataTest,TestDataSub)
head(MergeDataTest,2)
MergeDataTrain<-cbind(TrainData,TrainDataAct)
MergeDataTrain<-cbind(MergeDataTrain, TrainDataSub)
head(MergeDataTrain,2)
MergeAll<-rbind(MergeDataTest,MergeDataTrain)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
MergeAll_mean<-sapply(MergeAll, mean, na.rm=TRUE)
MergeAll_Sd<-sapply(MergeAll, sd, na.rm=TRUE)
head(MergeAll_Sd,3)

## 5.  From the data set in step 4, creates a second, independent tidy data set with the 
## average of each variable for each activity and each subject.

TidyData<-data.table(MergeAll)
Tidy<-TidyData[,lapply(.SD,mean),by="Activity,Subject"]
head(Tidy,6)
write.table(Tidy,file="Tidy.csv",sep=",",row.names = FALSE)
write.table(Tidy,file="Tidy.txt",sep="  ", row.names=FALSE)
