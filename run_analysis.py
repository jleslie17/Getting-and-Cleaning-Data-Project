# -*- coding: utf-8 -*-
"""
Created on Wed Nov 11 16:15:52 2015

@author: jon
"""

import numpy as np
from pandas import Series, DataFrame
import pandas as pd
import re

# 2 Read in first files
features = pd.read_table("UCI HAR Dataset/features.txt", sep=' ',header=None)
subject_test = pd.read_table("UCI HAR Dataset/test/subject_test.txt", 
                             header=None)
subject_train = pd.read_table("UCI HAR Dataset/train/subject_train.txt",
                              header=None)
Y_test = pd.read_table("UCI HAR Dataset/test/y_test.txt",
                         header=None)
Y_train = pd.read_table("UCI HAR Dataset/train/y_train.txt",
                         header=None)

# 3 Assemble the index tables
data = {'subject_ID':subject_train[0],
        'activity':Y_train[0]}
trainIndex = pd.DataFrame(data)
trainIndex['group'] = 'train'

data = {'subject_ID':subject_test[0],
        'activity':Y_test[0]}
testIndex = pd.DataFrame(data)
testIndex['group'] = 'test'

bothIndex = pd.concat([trainIndex, testIndex])
observation_ID = np.arange(1, len(bothIndex)+1)
bothIndex['observation_ID'] = observation_ID
cols = bothIndex.columns.tolist()
cols = [cols[-1], cols[1], cols[0], cols[2]]
bothIndex = bothIndex[cols]

# 4 change activity labels from numbers to descriptions
actLabels = pd.read_table("UCI HAR Dataset/activity_labels.txt", 
                          header=None, sep=' ',
                          names=("activity", "activity_description"))
bothIndex2 = pd.merge(bothIndex, actLabels, on='activity').drop('activity', 
        axis=1).sort('observation_ID')

# 5 Load and merge X data for train and test sets
X_train = pd.read_table("UCI HAR Dataset/train/X_train.txt", sep='\s+',
                        header=None,names=features.ix[:,1])
X_test = pd.read_table("UCI HAR Dataset/test/X_test.txt", sep='\s+',
                        header=None,names=features.ix[:,1])
dataFeatures = pd.concat([X_train, X_test])                        
dataFeatures['observation_ID'] = observation_ID

"""cols = dataFeatures.columns.tolist()
cols = cols[-1:] + cols[:-1]
cols[:5]
dataFeatures.ix[:, cols]
dataFeatures = dataFeatures[[cols]]
dataFeatures = dataFeatures.reindex(columns=cols)
dataFeatures.head(1)"""

# 6 Get only mean or std measurements. Remove angle measurements
featuresSeries = Series(features.ix[:,1])
matches = featuresSeries.str.contains('mean|std', flags=re.IGNORECASE)
featuresAngle = featuresSeries.str.contains('angle', flags=re.IGNORECASE)
featuresFiltered = features.ix[:,1][matches]
featuresFiltered = featuresFiltered[featuresAngle == False]

dataFeaturesSub = dataFeatures[featuresFiltered]

# 7 Combine index and observation data
combinedData = pd.merge(bothIndex2, dataFeaturesSub, 
                        left_index=True, right_index=True)
del combinedData['group']
dataMeans = combinedData.reset_index().groupby(['subject_ID','activity_description']).mean()





