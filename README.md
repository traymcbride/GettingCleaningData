#Analysis Script High-Level Overview

1. All of the work, from reading in the data to writing out the final tidy data set is done in one script, **run_analysis.R**.  It accomplishes steps 1 through 5 of the course project's instructions.  The script is fully commented.

2. The script requires the user to have the dplyr and data.table packages available.  It will make calls to library() to load them.

3. The [raw data files](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/) it reads in are from the [UCI Machine Learning Repository's](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#) Human Activity Recognition Using Smartphones Data Set.  They are available in a zip file.

4. The script assumes that the raw data files that it reads in reside in the *same* working directory in which it resides. 

5. It reads in the following files from the dataset: 

    * X_test.txt
    * y_test.txt
    * subject_test.txt
    * X_train.txt
    * y_train.txt
    * subject_train.txt
    * activity_labels.txt		
    * features.txt

6. The inertial signals files for both the test and training data were not used.  We were only interested in activities performed. 

7. All of the intermediate data frames are available for review in the environment once the script has finished.

8. The output file created by the script, HumanMovementMeanSummary.txt, is a comma delimited text file with with a header and one observation per line.  Is is created using the final data frame, tidy_data. 

9. The first line of the file -- the header -- contains the names of all of the variables.  The rest of the records consist of 180 observations on 68 variables, with 6 observations per each of the 30 subjects.  The 6 observations per subject are on the recorded activities, such as walking.  Averages of selected mean and standard deviation variables related to each activity are provided.

10. For detailed information on the raw data, how the script transformed the raw data, and descriptions of the output variables, please refer to CodeBook.Rmd.


