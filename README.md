# Getting-and-Cleaning-Data-Project
Submitted materials for the week 3 project

## Workflow
1. Place the “UCI HAR Dataset” directory containing the study data into the working directory.

2. Load the plyr, dplyr, tidry and reshape2 packages in R. Read in the “features.txt” table containing the full list of experimental measurements in the original dataset. Read in the data for subject IDs (“subject_train” and “subject_test”) and acitivy labels (“y_train” and “y_test”). Convert all to tbl_df objects.  

3. Combine subject IDs and activity ID numbers to get a data frame that lists all of the observations with the variables subject_ID, activity and group (train or test). Include a variable called observation_ID, which is the list of all observations in the combined data set. This dataframe is called “index”. 

4. Change activity ID numbers in “index” to activity labels using the “activity_labels.txt” document. Arrange the data in order of increasing observation ID number. This new index file is called “index2”.

5. Combine the data sets “X_train” and “X_test” into a data frame called “dataFeatures”. This lists all of the 561 measurements for all observations. Variable (column) names were generated from the “features” dataframe. 

6. Extract only the measurements that describe mean or standard deviation values in a data frame called “dataFeaturessSub”. Measurements labeled with “angle” are omited as these included information based on the means, but not reporting means directly. The final list has 79 measurements. 

7. Index information (“index2”) and experimental measurements (“dataFeaturessSub”) are combined into a data frame called “combinedData” and grouped according to subject ID. The variable for “group” is removed. This data frame is melted so that all of the experimental measurements are placed into a single column corresponding to “variable”. This is then cast into a data frame called dataMeans, in which the mean for each variable (experimental measurement) is listed according to subject ID and activity. This data frame has 180 rows (30 subjects x 6 activities) and 81 columns (79 experimental measurements plus columns for subject ID and activity). 

8. The column names (ie variables or experimental measurements) are changed to give more descriptive names.

