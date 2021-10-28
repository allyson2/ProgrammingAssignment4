################################################################################
# 1. Merging the training and the test sets to create one data set
################################################################################

# Reading text files
files <- dir(recursive = T, pattern = ".txt$")
files <- files[c(1,2, 5:28)]
file_names <- c('activity_labels'
                ,'features'
                ,'body_acc_x_test'
                ,'body_acc_y_test'
                ,'body_acc_z_test'
                ,'body_gyro_x_test'
                ,'body_gyro_y_test'
                ,'body_gyro_z_test'
                ,'total_acc_x_test'
                ,'total_acc_y_test'
                ,'total_acc_z_test'
                ,'subject_test'
                ,'X_test'
                ,'y_test'
                ,'body_acc_x_train'
                ,'body_acc_y_train'
                ,'body_acc_z_train'
                ,'body_gyro_x_train'
                ,'body_gyro_y_train'
                ,'body_gyro_z_train'
                ,'total_acc_x_train'
                ,'total_acc_y_train'
                ,'total_acc_z_train'
                ,'subject_train'
                ,'X_train'
                ,'y_train')

f <- lapply(files, read.table, header = F, )
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

final_df <- cbind(X[,used_columns], activity, subjects)

write.table(final_df, file = "tidyData.txt", row.names = F)



