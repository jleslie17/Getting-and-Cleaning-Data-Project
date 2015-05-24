Codebook for the Week 3 project, Getting and Cleaning Data
Jonathan Leslie
24 May, 2015


## Project Description
### Background Information
This is a project to tidy-up a data set. The data describe readings from a Samsung Galaxy S smartphone in which subjects were put through several activities and measurements were made on their acceleration and angular velocity. A full description of the data set is available at this site:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The data is contained here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

A full description of the experimental design and the measured and calculated variables can be found in the README.txt and features_info.txt files, respectively. This data includes the raw measured data as well as processed data.

### Output
I have written a script (“LeslieScript.R”) that reads in the processed experimental data and generates a tidy data set listing the mean values for 79 variables for each subject in each of six activities (walking, walking up stairs, walking down stairs, sitting, standing and laying down). The final, tidy dataset is a dataframe containing 180 observations (30 subjects x 6 activities) and 81 variables (the 79 aforementioned variables plus columns for subject identification number and the experimental activity).

### Script overview
A more detailed desciption of the script can be found in the README.md file in this repository. 

The script reads the experimental data from the “X_train.txt” and “X_test.txt” data files, as well as the labels (“y_train.txt”, “y_test.txt”), subject ID information (“subject_train.txt” and “subject_test.txt”) and the list of measured variables (“features.txt”). An index is assembled, which includes information on subject ID number and activity for both groups (train and test). Each observation is given and ID number. 

The experimental data are assembled for both groups with the full list of 561 experimental measurements for each observation ID. This is filtered to include only those 79 measurments that describe mean or standard deviation values in a dataframe called “dataFeaturesSub”. (Variables labeled with “angle” were omited as these included information based on the means, but not reporting means directly.) 

The index dataframe (“index2”) and experimental data dataframe (“dataFeaturesSub”) were combined and melted so that all experimental measurements were collected into a singe variable. This was then cast to produce a data frame (“dataMeans”) containing the mean value for each experimental measurement for each subject under each activity. The variable names corresponding to the experimental measurements were re-named in order to give more descriptive values in the final table. 

### Variable descriptions
* subject_test/subject_train: identifies the subject ID for each observation in each group.

* subjectTest/subjectTrain: tbl_df versions of subject_test/subject_train

* Y_test/Y_train: identifies the activity by number for each observation in each group.

* activityTest/activityTrain: tbl_df versions of Y_test/Y_train

* trainIndex/testIndex: index dataframes for each group that list the subject ID and the activity. Generated by combining the above objects.

* index: combined trainIndex and testIndex data frames with an additional column for observation ID.

* index2: data frame based on index, in which activity numbers are exchanged for activity descriptive activity names.

* X_train/X_test: data for all 561 experimental measurements for each subject and each activity

* dataFeatures: combined data for all 561 experimental measurements for each subject and each activity with measurement labels included as column names

* featuressFiltered: vector containing the experimental measurement names that only include those describing mean or standard deviation values

* dataFeaturesSub: a subset of dataFeatures corresponding only to those measurements describing mean or standard deviation values are included. Measurement names describing the angle variable are omited

* combinedData: data frame containing the information from both index2 and dataFeaturesSub. 

* featuresFinalList: character vector containing the names of the experimental measurements appearing in combinedData. This is used to melt combinedData so that all experimental measurements appear in a single column called variable.

* dataMelt: melted version of combinedData with all experimental measurements appear in a single column called variable

* dataMeans: final data frame reporting the mean for each experimental measurement for each subject for each activity. 




References:
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012