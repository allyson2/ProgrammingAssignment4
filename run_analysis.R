################################################################################
# 1. Merging the training and the test sets to create one data set
################################################################################

install.packages('reshape2')
library(reshape2)
library(dplyr)

# Download the files
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
              ,"Dataset.zip")
unzip("Dataset.zip")
file.remove("Dataset.zip")

# Reading text files
files <- dir(path = "UCI HAR Dataset", recursive = T, pattern = ".txt$", full.names = T)
files <- files[c(1,2, 14:16, 26:28)]
file_names <- c('activity_labels'
                ,'features'
                ,'subject_test'
                ,'X_test'
                ,'y_test'
                ,'subject_train'
                ,'X_train'
                ,'y_train')

f <- lapply(files, read.table, header = F)
names(f) <- file_names

X <- rbind(f$X_train, f$X_test)
y <- rbind(f$y_train, f$y_test)
subjects <- rbind(f$subject_train, f$subject_test); names(subjects) <- "subject"

activity_labels <- f$activity_labels; names(activity_labels) <- c("id", "activity")
features <- f$features; names(features) <- c("id", "feature")


################################################################################
# 2. Extracting only the measurements on the mean and standard deviation for 
# each measurement
################################################################################

used_columns <- grep("(mean|std)\\(", features$feature, value = T)
features[used_columns,]


################################################################################
# 3. Using descriptive activity names to name the activities in the data set
################################################################################

activity <- factor(activity_labels[y[[1]], 2])


################################################################################
# 4. Appropriately labeling the data set with descriptive variable names
################################################################################

colnames(X) <- features[,2]


################################################################################
# 5. Creating a second independent tidy data set with the average of each 
# variable for each activity and each subject
################################################################################

df <- cbind(X[,used_columns], activity, subjects)

grouped <- group_by(df, subject, activity)
final_df <- summarise(grouped, across(used_columns, list(mean)))

write.table(final_df, file = "tidyData.txt", row.names = F)

# Another option to do the same:
# melted <- melt(df, id = c('subject', 'activity'))
# final_df <- dcast(melted, subject + activity ~ variable, mean)
