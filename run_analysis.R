    #    Objectives:
    #    This script will do the following:
    #    Merges the training and the test sets to create one data set.
    #    Extracts only the measurements on the mean and standard deviation for each measurement.
    #    Uses descriptive activity names to name the activities in the data set
    #    Appropriately labels the data set with descriptive variable names.
    #    Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

    # load the reshape2 library for melt/dcast
    library(reshape2)

    # Create data dir and switch there
    if(!file.exists("./data")) {
        dir.create("./data")
        setwd("./data")
    } else {
        setwd("./data")
    }

    file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(file.url,"data.zip",method="curl")
    if(file.exists("data.zip")) {
        unzip("data.zip")
    } else {
        stop("There was a problem downloading the file")
    }

    # This zip decompresses to the "UCI HAR Dataset" directory, setwd there if it exists
    if(file.exists("./UCI HAR Dataset")) {
        setwd("./UCI HAR Dataset")
    } else {
        stop("The UCI HAR Dataset directory does not exist")
    }

    # Read test and train measurements into temp frames
    test.data <- read.table("test/X_test.txt")
    train.data <- read.table("train/X_train.txt")

    # combine the temp frames; rbind is the simplest way to do this
    # However, this requires that all further data be read in in
    # test then train order
    all.data <- rbind(test.data,train.data)

    # Remove temp tables to conserve memory
    rm(test.data)
    rm(train.data)

    # Read in measurement names
    data.names <- read.table("features.txt")
    names(all.data) <- data.names[,2]

    # Use grep to match the columns that contain mean\\(|std\\(
    # which should be columns that have the mean() and std() applied
    # to them
    wanted_columns<-grep('mean\\(|std\\(',data.names[,2],perl=TRUE,value=TRUE)

    # Using wanted.columns[] as a vector, subset all.data into wanted.data
    # which will only contain mean and std measurements
    wanted.data <- all.data[,wanted_columns]

    # read test and train subject data into temp frames
    test.subject <- read.table("test/subject_test.txt")
    train.subject <- read.table("train/subject_train.txt")

    # merge the data frames; note the order
    subjects <- rbind(test.subject,train.subject)

    # Remove temp frames
    rm(test.subject)
    rm(train.subject)

    # give the subjects data a nice name
    names(subjects)<-c("Subject")

    # Read activity data from test and train files
    test.activity <- read.table("test/y_test.txt")
    train.activity <- read.table("train/y_train.txt")

    # Combine activity data into 1 data frame
    activities <- rbind(test.activity,train.activity)

    # Remove temp frames
    rm(test.activity)
    rm(train.activity)

    # Read activity labels
    activity.names <- read.table("activity_labels.txt")

    # Factor activities and label appropriately
    Activity <- factor(activities[,1], labels=activity.names[,2])

    # bind subject and Activity columns
    wanted.data <-cbind(subjects,Activity,wanted.data)

    # melt and recast the data into the format we want. You could get
    # the same result with the following command:
    #   aggregate(wanted.data[,4:69],by=list(wanted.data$Activity,wanted.data$Subject), FUN=mean)
    # but aggregate refused to allow me to use Activity as a selector since it's a factor
    # of a different length than subject. The aggregate above produces the same data,
    # but the column names are not preserved. Not sure how to work around this.

    wanted.melt <- melt(wanted.data, id=c("Subject","Activity"), measure.vars=wanted_columns)

    # dcast the data into a frame in Subject/Activity sort order

    finished <- dcast(wanted.melt, Subject+Activity~variable,mean)

    # Round the variables to 4 digits
    numeric.vars <- sapply(finished, is.numeric)
    finished[numeric.vars] <- lapply(finished[numeric.vars], round, digits=4)

    # All done with "UCI HAR Dataset", go back to ../ which should be "data"
    setwd("../")

    # Write this tidy data out to disk
    write.table(finished, "./finished_data.txt", row.names=FALSE)

    # quit
    q()
