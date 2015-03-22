library(dplyr)
library(plyr)

url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip' # url of file containing dataset
download.file(url,destfile = "./data.zip", method = 'auto')     # download file from internet
ProjectData <- unzip('data.zip')              #unzip the downloaded file

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")  # the code in the next few lines read the relevant datasets into R dataframes 
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

y_train <- factor(y_train[,1]) #convert y_train to a factor variable
y_test <- factor(y_test[,1]) 
y_train <- revalue(y_train, c('1'='walking','2'='walking_upstairs','3'='walking_downstairs','4'='sitting','5'='standing','6'='laying')) #rename the factor levels
y_test <- revalue(y_test, c('1'='walking','2'='walking_upstairs','3'='walking_downstairs','4'='sitting','5'='standing','6'='laying'))

features <- make.names(features[,2], unique=TRUE)       # extracts the activity names from features and converts them into valid R variable names
names(x_train) <- features                    # rename the X_train data with more descriptive names
names(x_test) <- features                     # rename the X_test data with more descriptive names

x_train <- cbind(sub_train,y_train,x_train)   #add the matching training subject column to the dataframe
x_test <- cbind(sub_test,y_test,x_test)       #add the matching test subject column to the dataframe
x_train <- rename(x_train, c('y_train'='activity'))
x_test <- rename(x_test, c('y_test'='activity'))

x_mean_std <- select(x_merged,V1,activity,contains('mean'),contains('std')) #Extract only the means and standard deviations from the x_merged dataframe
x_mean_by_subject <- summarise_each(group_by(x_mean_std,V1,activity), funs(mean))

names(x_mean_by_subject) <- paste0('Mean_Value_Of_',names(x_mean_by_subject))      #The variable names of the dataframe are prefixe with 'Mean_Value_Of_'
x_mean_by_subject <- rename(x_mean_by_subject, c('Mean_Value_Of_V1'='subjectID'))  # rename the subject variable from Mean_Value_Of_V1 to subjectID
x_mean_by_subject <- rename(x_mean_by_subject, c('Mean_Value_Of_activity'='activity'))
