setwd("D:\\Matt\\Documents\\Coursera\\3 Getting and Cleaning Data\\Project")

# 1 Merge the training and the test sets to create one data set.
        # - Combine the three components of the test dataset into one file.
        measures.test <- read.table("./UCI HAR Dataset\\test\\X_test.txt", header = FALSE)
        subjects.test <- read.table("./UCI HAR Dataset\\test\\subject_test.txt", header = FALSE)
        activities.test  <- read.table("./UCI HAR Dataset\\test\\y_test.txt", header = FALSE)
        test <- cbind.data.frame(subjects.test, activities.test, measures.test)
        
        # - Now do the same for the training components.
        measures.train <- read.table("./UCI HAR Dataset\\train\\X_train.txt", header = FALSE)
        subjects.train <- read.table("./UCI HAR Dataset\\train\\subject_train.txt", header = FALSE)
        activities.train  <- read.table("./UCI HAR Dataset\\train\\y_train.txt", header = FALSE)
        train <- cbind.data.frame(subjects.train, activities.train, measures.train)

        # create a SOURCE variable and then rbind the two data frames
        test$SOURCE <- "test"
        train$SOURCE <- "train"
        combined <- rbind.data.frame(test, train)

# 2 Extract only the measurements on the mean and standard deviation for 
# each measurement. Note that I am interpreting from this part of the requirements 
# that it is not necessary to extract the 6 "gravityMean" parameters at the
# end of the dataset that are applied to the angle measurements.

        # Get the column names of the 561 measures from features.txt.
        cols <- read.table("./UCI HAR Dataset\\features.txt", header = FALSE)
        colvect <- as.character(cols[,2])
        names(combined) <- c("Subject", "Activity.number", colvect, "Source") 
        # using grep function to search for 'mean()' and 'std()' in column names
        mean_sd_parms <- combined[ , c(1, 2, 564, grep("mean()", names(combined)), 
                                                  grep("std()",  names(combined)))]
        # Removing the 'meanFreq()' parameters that snuck in last subset
        mean_sd_parms <- mean_sd_parms[ , -c(grep("meanFreq()", names(mean_sd_parms)))]
        

# 3 Use descriptive activity names to name the activities in the data set        
        
        # Get dataset that contains the link between activity numbers and 
        # character description
        act <- read.table("./UCI HAR Dataset\\activity_labels.txt", header = FALSE)
        names(act) <- c("Activity.number", "Activity")
        
        mean_sd_parms <- merge(mean_sd_parms, act, by="Activity.number", all = TRUE)
        
        # reorder columns so that mean and corresponding std appear close to each other.
        mean_sd_parms <- mean_sd_parms[, c(2, 3, 1, 70, order(names(mean_sd_parms[4:69]))+3)]
        
# 4 Appropriately label the data set with descriptive variable names.
        
        # This was done in step 2 with the following statement: 
        # names(combined) <- c("Subject", "Activity.number", colvect, "Source") 
        
# 5 From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
                
        library(reshape2)
        skinny_mean_sd <- melt(mean_sd_parms, id=c("Subject", "Activity", "Source"),
                               measure.vars = c(5:70))
        
        library(dplyr)        
        Step5 <- group_by(skinny_mean_sd, Subject, Activity, variable)
        # 11,880 rows expected (30 subjects x 6 activities x 66 parameters)
        Output.file <- summarize(Step5, mean_by_subj_act = mean(value))        
        
        write.table(Output.file, file = "./tidy.txt", row.name=FALSE)
        
        # Dataset is readable in R using the following code if tidy.txt is in 
        # the working directory.
        # tidy <- read.table("./tidy.txt", header=TRUE)
        # View(tidy)
