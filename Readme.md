# Week 3 Project 

The script run_analysis.R  will perform the following tasks:

    1. Creates a directory within the current working directory called 'data'
    2. Accesses the internet to download the master data set from this url: 
      https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
    3. Unzips the resulting download and processes the files within according to thse
    guidelines:

       a. Merges the training and the test sets to create one data set.
       b. Extracts only the measurements on the mean and standard deviation for 
          each measurement. 
       c. Uses descriptive activity names to name the activities in the data set
       d. Appropriately labels the data set with descriptive variable names. 
       e. Creates a second, independent tidy data set with the average of each 
          variable for each activity and each subject. 
    4. The resulting data summary is called finished_data.txt and will reside in the
      'data' directory created in step 1
    5. All measurements have been round()-ed to 4 places for space and brevity.

You will require approximately 330 MB of drive space for this script to perform correctly.

The data represented in this code is courtesy of the following study:

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. 
Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support 
Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). 
Vitoria-Gasteiz, Spain. Dec 2012

