library(plyr); library(dplyr); library(tidyr); library(reshape2) 
##read in data for subject IDs and activity labels
features <- read.table("UCI HAR Dataset/features.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subjectTest <- tbl_df(subject_test)
subjectTrain <- tbl_df(subject_train)
activityTest <- tbl_df(Y_test)
activityTrain <- tbl_df(Y_train)

##assemble the index tables
trainIndex <- bind_cols(subjectTrain, activityTrain)
colnames(trainIndex) <- c("subject_ID", "activity")
trainIndex <- mutate(trainIndex, group = "train")
testIndex <- bind_cols(subjectTest, activityTest)
colnames(testIndex) <- c("subject_ID", "activity")
testIndex <- mutate(testIndex, group = "test")

##join the train and test index tables and add observation_IDs
index <- bind_rows(trainIndex, testIndex)
observation_ID <- 1:nrow(index)
index <- cbind(observation_ID, index)

##change activity labels from numbers to descriptions
actLabels <- read.table("UCI HAR Dataset/activity_labels.txt", 
                        col.names = c("activity", "activity_description"))
index2 <- merge(index, actLabels, by = c("activity","activity"), sort = F) %>%
        select(-activity)%>%
        arrange(observation_ID)%>%
        tbl_df%>%
        rename(activity = activity_description)

##merge X_data for train and test
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
dataFeatures <- bind_rows(X_train, X_test)
colnames(dataFeatures) <- features[,2]
dataFeatures <- cbind(observation_ID, dataFeatures)

##Extract only mean and standard deviation measurements
featuressFiltered <- grep("mean|std", features[,2], 
        ignore.case = T, value = T)
dataFeaturesSub <-  dataFeatures[,featuressFiltered]%>%
        select(-contains("angle"))

##Combine the index information and the measurements
combinedData <- cbind(index2, dataFeaturesSub)%>%
        group_by(subject_ID)%>%
        select(-group)
featuresFinalList <- names(combinedData[,4:82])
dataMelt <- melt(combinedData, id.vars = c("observation_ID", "subject_ID", 
        "activity"), measure.vars = featuresFinalList)
dataMeans <- dcast(dataMelt, subject_ID + activity ~ variable, mean)

##Change the names of the variable names
names(dataMeans) <- tolower(names(dataMeans))
names(dataMeans) <- sub("bodyacc", "body acceleration", names(dataMeans))
names(dataMeans) <- sub("gravityacc", "gravity", names(dataMeans))
names(dataMeans) <- sub("bodygyro", "angular velocity", names(dataMeans))
names(dataMeans) <- sub("jerk", ", jerk", names(dataMeans))
names(dataMeans) <- sub("mag", ", 3D magnitude", names(dataMeans))
names(dataMeans) <- sub("tbody", "time domain signal, body", names(dataMeans))
names(dataMeans) <- sub("tgravity", "time domain signal, gravity", names(dataMeans))
names(dataMeans) <- sub("tangular", "time domain signal, angular", names(dataMeans))
names(dataMeans) <- sub("fbody", "Fast Fourier Transform, body", names(dataMeans))
names(dataMeans) <- sub("fangular", "Fast Fourier Transform, angular", names(dataMeans))
names(dataMeans) <- sub("bodybody", "body", names(dataMeans))
names(dataMeans) <- sub("bodyangular", "angular", names(dataMeans))
names(dataMeans) <- sub("std", "std dev", names(dataMeans))
names(dataMeans) <- sub("\\()", "", names(dataMeans))
