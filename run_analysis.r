#download and unzip data sets 
if(!file.exists("./Coursera")){dir.create("./Coursera")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Coursera/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./Coursera/Dataset.zip",exdir="./Coursera")

# Reading trainings tables:
x_train <- read.table("./Coursera/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./Coursera/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./Coursera/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./Coursera/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./Coursera/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./Coursera/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./Cousera/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./Cousera/UCI HAR Dataset/activity_labels.txt')

#assign column names 
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#merge all data 
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

#read column names 
colNames <- colnames(setAllInOne)
#create vector for defining ID, mean and standard deviation 
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames))
#make a subset 
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
#name all activities with descriptive names 
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)
#make a second tidy data set 
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
#write second data set in txt file 
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
