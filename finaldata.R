library(dplyr)

activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code","activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names = "code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

X <- rbind(x_train,x_test)
Y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)
merged_data <- cbind(subject,Y,X)

tidyData <- merged_data %>% select(subject, code, contains("mean"), contains("std"))

tidyData$code <- activities[tidyData$code, 2]

names(tidyData)[2] = "activity"
names(tidyData) <- gsub("^t","Time",names(tidyData))
names(tidyData) <- gsub("^f","Frequency",names(tidyData))
names(tidyData) <- gsub("Acc","Accelerometer",names(tidyData))
names(tidyData) <- gsub("Gyro", "Gyroscope",names(tidyData))
names(tidyData) <- gsub("Mag","Magnitude",names(tidyData))
names(tidyData) <- gsub("BodyBody","Body",names(tidyData))
names(tidyData) <- gsub("tBody","TimeBody",names(tidyData))


finalData <- tidyData %>%
        group_by(subject, activity) %>%
        summarise_all(list(mean))

write.table(finalData, "finaldata.txt", row.name=FALSE)
