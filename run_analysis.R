setwd("D:/data science/program/getting and cleaning data/ass1/getdata%2Fprojectfiles%2FUCI HAR Dataset (1)")
base_folder <- file.path("./data" , "UCI HAR Dataset")

ActivityTest  <- read.table(file.path(base_folder, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain <- read.table(file.path(base_folder, "train", "Y_train.txt"),header = FALSE)
SubjectTrain <- read.table(file.path(base_folder, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(base_folder, "test" , "subject_test.txt"),header = FALSE)
FeaturesTest  <- read.table(file.path(base_folder, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(base_folder, "train", "X_train.txt"),header = FALSE)

#Merges the training and the test sets to create one  data set.
#--------------------------
#Concatenate the  data tables by rows
Subject <- rbind(SubjectTrain, SubjectTest)
Activity<- rbind(ActivityTrain, ActivityTest)
Features<- rbind(FeaturesTrain, FeaturesTest)

#set names to variables
names(Subject)<-c("subject")
names(Activity)<- c("activity")
FeaturesNames <- read.table(file.path(base_folder, "features.txt"),head=FALSE)
names(Features)<- FeaturesNames$V2

#Merge columns to get the  data frame for all 
temp <- cbind(Subject, Activity)
Data <- cbind(Features, temp)

#----------------------------------

#Extracts only the measurements on the mean and standard deviation for each measurement
#----------------------------------
#Subset Name of Features by measurements on the mean and standard deviation
Filtered_FeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]

#Subset the data frame by seleted names of Features
FeaturesNames<-c(as.character(Filtered_FeaturesNames), "subject", "activity" )
Data<-subset(Data,select=FeaturesNames)

#Uses descriptive activity names to name the activities in the data set

#Read descriptive activity names from "activity_labels.txt"
activityLabels <- read.table(file.path(base_folder, "activity_labels.txt"),header = FALSE)

#Encode activity names from 1 to 6 with labels mentioned in the activity_labels.txt file
Data$activity<-factor(Data$activity,levels=c(1,2,3,4,5,6),labels=activityLabels$V2)

#-------------------------------------------------------------
#Appropriately labels the data set with descriptive variable names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
#------------------------------------------------------------------

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)


