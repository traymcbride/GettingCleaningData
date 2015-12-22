################################################################
#Class project for Getting and Cleaning Data, Dec.2015 session.
#Data Science Specialization through John Hopkins University
#on Coursera.org.
#
#This script accomplishes steps 1 through 5 in the project's
#instructions.
################################################################

library(dplyr)
library(data.table)

#####################################################
#Read in all of the relevant raw data 
#####################################################

features <- read.table("features.txt",header=FALSE,stringsAsFactors = FALSE)
activities <- read.table("activity_labels.txt",header=FALSE)

x_test <- read.table("X_test.txt",header=FALSE)
y_test <- read.table("y_test.txt",header=FALSE)

x_train <- read.table("X_train.txt",header=FALSE)
y_train <- read.table("y_train.txt",header=FALSE)

subject_test <- read.table("subject_test.txt",header=FALSE)
subject_train <- read.table("subject_train.txt",header=FALSE)


#####################################################
#Prepare it to be combined 
#####################################################

features <- rename(features, VariableNumber = V1, VariableName = V2)
activities <- rename(activities, ActivityNumber = V1, ActivityName = V2)
#Remove underscores
activities <- mutate(activities,ActivityName = gsub("_"," ",ActivityName))
y_test <- rename(y_test,ActivityNumber = V1)
y_train <- rename(y_train,ActivityNumber = V1)
subject_test <- rename(subject_test,Subject = V1)
subject_train <- rename(subject_train,Subject = V1)

#####################################################
#Combine the test data
#####################################################

#Let's assign the activity names to y_test.  We must keep the order!
#An inner join preserves the order of the activity numbers.

y_test <- inner_join(y_test,activities,by="ActivityNumber")

#We next extract the mean and standard deviation variables from 
#features using grep. grep returns the row numbers where the pattern
#appears in VariableName.  We search for mean() and std() as
#detailed in features.txt.

mean_indices <- grep("mean\\(\\)",features$VariableName)
std_indices <- grep("std\\(\\)",features$VariableName)

#Combine the indices and sort them in ascending order

desired_indices <- sort(c(mean_indices,std_indices))

#Now we extract the desired columns from x_test
#and *then* rename the columns.  If we first try to rename the all of the
#columns of x_test, and then try to extract the mean and std columns with 
#select, we get an error since, for example, fBodyAcc-bandsEnergy()-1,8  
#is a duplicate name.  Checking by using duplicated on features$VariableName 
#demonstates this.

x_test <- select(x_test,desired_indices)
columns <- features$VariableName[desired_indices]

#Note the special characters in columns such as ( are turned into .
#by names().  For example tBodyAcc-mean()-X becomes tBodyAcc.mean...X

names(x_test) <- make.names(columns)

#Now we combine x_test, y_test and the test subjects
#so that the resulting data has subject and activity values for 
#every observation of the features data with the desired columns.

test_data <- cbind(subject_test,y_test,x_test)

#####################################################
#Combine the test data, using some of our work above,
#and in the same spirit.
#####################################################
y_train <- inner_join(y_train,activities,by="ActivityNumber")
x_train <- select(x_train,desired_indices)
names(x_train) <- make.names(columns)
train_data <- cbind(subject_train,y_train,x_train)

#####################################################
#Combine the test and training data
#####################################################

all_data <- rbind(test_data,train_data)

#Clean up the column names.  

names(all_data) <-make.names(gsub("\\.","",names(all_data)))
names(all_data) <-make.names(gsub("mean","Mean",names(all_data)))
names(all_data) <-make.names(gsub("std","Std",names(all_data)))

#####################################################
#Remove ActivityNumber in the captured data for our
#final cut of it.
#####################################################

#We kept the activity number up until this point during our investigations 
#as a sanity check to make sure the order was preserved in the observations.

all_data <- select(all_data,-(ActivityNumber))

#####################################################
#Perform the analysis and create a tidy dataset
#####################################################

#Group the data first
all_data <- group_by(all_data,Subject,ActivityName)

#Next call summarize_each.  Since we do not pass anything in for
#vars, it will only perform the mean on non-grouping variables,
#which is precisely what we want.

tidy_data <- summarize_each(all_data,funs(mean))

#Change the names to reflect that we're taking averages

names(tidy_data) <-make.names(gsub("Mean","AvgMean",names(tidy_data)))
names(tidy_data) <-make.names(gsub("Std","AvgStd",names(tidy_data)))

#Write out the data.  The row names are not meaningful, so we drop them.
#I chose comma delimited data since I find it easier to read.

write.table(tidy_data,file="HumanMovementMeanSummary.txt",sep=",",row.names=FALSE)