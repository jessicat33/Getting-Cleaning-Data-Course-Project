##Get data

if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/Datasets.zip")
unzip(zipfile = "./data/Datasets.zip", exdir = "./data")
refpath <- file.path("./data", "UCI HAR Dataset")
files <- list.files(path_rf, recursive = TRUE)

##Read data

TestActivity <- read.table(file.path(refpath, "test", "Y_test.txt"), header = FALSE)
TrainActivity <- read.table(file.path(refpath, "train", "Y_train.txt"), header = FALSE)

TestSubject <- read.table(file.path(refpath, "test", "subject_test.txt"), header = FALSE)
TrainSubject <- read.table(file.path(refpath, "train", "subject_train.txt"), header = FALSE)

TestFeatures  <- read.table(file.path(refpath, "test" , "X_test.txt" ), header = FALSE)
TrainFeatures <- read.table(file.path(refpath, "train", "X_train.txt"), header = FALSE)

##Step 1 - Merge training and test data

SubjectData <- rbind(TrainSubject, TestSubject)
ActivityData <- rbind(TrainActivity, TestActivity)
FeaturesData <- rbind(TrainFeatures, TestFeatures)

names(SubjectData) <- c("subject")
names(ActivityData) <- c("activity")
FeaturesNames <- read.table(file.path(refpath, "features.txt"), head = FALSE)
names(FeaturesData) <- FeaturesNames$V2

CombinedData <- cbind(SubjectData, ActivityData)
Data <- cbind(FeaturesData, CombinedData)


##Step 2 - Extract mean and standard deviation

subFeaturesNames <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
selectNames <- c(as.character(subFeaturesNames), "subject", "activity")
Data <- subset(Data, select = selectNames)


##Step 3 - Add descriptive activity names

activityNames <- read.table(file.path(refpath, "activity_labels.txt"), header = FALSE)
activityNames <- as.character(activityNames[,2])
Data$activity <- activityNames[Data$activity]


##Step 4 - Label data variables

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))


##Step 5 - Create new, independent, tidy data set with averages

library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)










