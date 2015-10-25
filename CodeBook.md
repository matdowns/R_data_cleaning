---
title: Tidy.txt code book
author: Matt Downs
date: 25OCT2015
output:
  html_document:
    keep_md: yes
---

## Project Description
The run_analysis.R script in this repository creates the tidy dataset, tidy.txt, for the project assignment for Coursera's Getting and Cleaning Data course. The script produces the long form of a tidy dataset; as mentioned in the grading rubric, either a long or wide form would be acceptable.

The goal of the assignment is to produce a tidy dataset containing the mean values for each subject and activity for the collected mean and standard deviations for the 33 collected parameters in the raw data.

The dataset fulfills the principles of tidy data because:
* each column contains only one type of data,
* each row contains data from one observation,
* it includes a row at the top of the file with variable names, and
* variable names are human readable.
	
##Study design and data processing

###Collection of the raw data
Briefly, the investigators collected time series data on 33 motion parameters for a group of 30 volunteers who each performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) while wearing a smartphone (Samsung Galaxy S II) on the waist.

The 33 parameters were:
* [1-3] 		tBodyAcc-XYZ
* [4-6] 		tGravityAcc-XYZ
* [7-9]		tBodyAccJerk-XYZ
* [10-12]	tBodyGyro-XYZ
* [13-15]	tBodyGyroJerk-XYZ
* [16]		tBodyAccMag
* [17]		tGravityAccMag
* [18]		tBodyAccJerkMag
* [19]		tBodyGyroMag
* [20]		tBodyGyroJerkMag
* [21-23]	fBodyAcc-XYZ
* [24-26]	fBodyAccJerk-XYZ
* [27-29]	fBodyGyro-XYZ
* [30]		fBodyAccMag
* [31]		fBodyAccJerkMag
* [32]		fBodyGyroMag
* [33]		fBodyGyroJerkMag

For each of these parameters, the following summary statistics were collected:
* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

For this assignment, we used only the mean() and std() set of variables and dropped the other calculated summary statistics for each parameter.

A detailed description of the experimental design of the study can be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. The raw datasets themselves are located at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

###Notes on the original (raw) data 
The assignment required use of 8 of the provided raw datasets:
* test/X_test.txt: contains the summary statistics for the 33 motion parameters for the 9 subjects included in the test dataset.
* test/subject_test.txt: contains the subject number who performed each set of measurements in X_test.txt file.
* test/y_test.txt: contains the activity coded as a numeric variable corresponding to the activity performed for each set of measurements in X_test.txt.

* train/X_train.txt: identical file in structure and content as X_test.txt, except that it includes only the 21 subjects in the training dataset.
* train/subject_train: identical file to subject_test.txt, except for the 21 subjects in the training dataset.
* train/y_train: identical file to y_test.txt, except for the 21 subjects in the training dataset.

* features.txt: contains the variable labels for the 561 combinations of parameter and summary statistic contained in X_test.txt and X_train.txt.
* activity_labels.txt: contains the mapping of the coded activity number in y_test.txt and y_train.txt to the character description of the activity.

##Creating the tidy datafile
1. Combine the three test datasets (X_test, subject_test, and y_test) to form one test data frame. Do the same with the three training datasets. For traceability, add a Source variable containing the value "test" or "train", depending on the source. Then, concatenate the test and training data frame.
2. Extract only the measurements on the mean and standard deviation for each measurement. (Note that I am interpreting from this part of the assignment's requirements that it is not necessary to extract the 6 "gravityMean" parameters at the end of the dataset that are applied to the angle measurements.) This was achieved by applying the column names found in features.txt to the data frame created in Step 1 and subsetting only to the columns containing the strings "mean()" and "std()". The Subject column from subject_test and subject_train was also kept as was the activity number from the y_test and y_train files and the Source variable created at the end of Step 1. 
3. Use descriptive activity names to name the activities in the data set by merging activity_labels.txt with the file created in Step 2.
4. From the assignment's requirements, Step 4 was to "Appropriately label the data set with descriptive variable names". This was actually done in the R script as part of Step 2.
5. From the data set in Step 4, write out a text file, tidy.txt, that contains a second, independent tidy data set with the average of each variable for each activity and each subject.

##Description of the variables in the tidy.txt file
General description of the file including:
* Dataset is the long implementation of a tidy dataset
* Contains 11,800 observations, one for each combination of 30 subjects, 6 activities, and 66 parameter/summary statistic combinations.
* 4 variables as described below 

###Variable 1 = Subject
Integer between 1 and 30 inclusive indicating the subject number

###Variable 2 = Activity
Factor with 6 levels indicating the activity performed
Levels: LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS

###Variable 3 = variable
Factor with 66 levels indicating the variable in the original X_test and X_train datasets that is being summarized 
From the original raw data documentation, the name of each factor is composed of 3 or 4 components:
* Variables beginning with f denote frequency domain signals, while those starting with t denote time domain signals.
* The second component of the name indicates the type of parameter being summarized (e.g., BodyAcc indicated body accelerations)
* The third component indicates whether the mean() or std() is being summarized
* The fourth component (if applicable) indicates whether the x, y, or z direction is being summarized

---
Levels:
 [1] fBodyAcc-mean()-X           fBodyAcc-mean()-Y           fBodyAcc-mean()-Z          
 [4] fBodyAcc-std()-X            fBodyAcc-std()-Y            fBodyAcc-std()-Z           
 [7] fBodyAccJerk-mean()-X       fBodyAccJerk-mean()-Y       fBodyAccJerk-mean()-Z      
[10] fBodyAccJerk-std()-X        fBodyAccJerk-std()-Y        fBodyAccJerk-std()-Z       
[13] fBodyAccMag-mean()          fBodyAccMag-std()           fBodyBodyAccJerkMag-mean() 
[16] fBodyBodyAccJerkMag-std()   fBodyBodyGyroJerkMag-mean() fBodyBodyGyroJerkMag-std() 
[19] fBodyBodyGyroMag-mean()     fBodyBodyGyroMag-std()      fBodyGyro-mean()-X         
[22] fBodyGyro-mean()-Y          fBodyGyro-mean()-Z          fBodyGyro-std()-X          
[25] fBodyGyro-std()-Y           fBodyGyro-std()-Z           tBodyAcc-mean()-X          
[28] tBodyAcc-mean()-Y           tBodyAcc-mean()-Z           tBodyAcc-std()-X           
[31] tBodyAcc-std()-Y            tBodyAcc-std()-Z            tBodyAccJerk-mean()-X      
[34] tBodyAccJerk-mean()-Y       tBodyAccJerk-mean()-Z       tBodyAccJerk-std()-X       
[37] tBodyAccJerk-std()-Y        tBodyAccJerk-std()-Z        tBodyAccJerkMag-mean()     
[40] tBodyAccJerkMag-std()       tBodyAccMag-mean()          tBodyAccMag-std()          
[43] tBodyGyro-mean()-X          tBodyGyro-mean()-Y          tBodyGyro-mean()-Z         
[46] tBodyGyro-std()-X           tBodyGyro-std()-Y           tBodyGyro-std()-Z          
[49] tBodyGyroJerk-mean()-X      tBodyGyroJerk-mean()-Y      tBodyGyroJerk-mean()-Z     
[52] tBodyGyroJerk-std()-X       tBodyGyroJerk-std()-Y       tBodyGyroJerk-std()-Z      
[55] tBodyGyroJerkMag-mean()     tBodyGyroJerkMag-std()      tBodyGyroMag-mean()        
[58] tBodyGyroMag-std()          tGravityAcc-mean()-X        tGravityAcc-mean()-Y       
[61] tGravityAcc-mean()-Z        tGravityAcc-std()-X         tGravityAcc-std()-Y        
[64] tGravityAcc-std()-Z         tGravityAccMag-mean()       tGravityAccMag-std()
---

###Variable 4 = mean_by_subj_act
Numeric containing the calculated mean for each combination of Subject, Activity, and variable (i.e., for each combination of the other 3 columns in the data frame). The variable is unitless because the investigators normalized each parameter in the dataset so that it would be in the interval [-1, 1].

##Sources
*Documentation of original experiment: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
*Raw data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
