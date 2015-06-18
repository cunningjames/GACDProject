# GACDProject Code Book

The dataset constructed by run_analysis is an aggregated version of raw data
from the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) provided by the UCI Machine Learning Repository. The raw dataset provides multidimensional motion information recorded for 30 individuals using the accelerometer and gyroscope on a modern cellular phone.

Here, following to the instructions given in the course project description, we provide an aggregated and 'tidy' version of this dataset. In so doing we followed this basic procedure:

1. Aggregate test and training datasets;
2. Select only measurement types that represent means or standard deviations;
3. Lengthen the dataset so that each row represents a single measurement type m 
   for individual i performing activity j;
4. Finally, take the mean of each measurement for each type / individual / 
   activity combination.

The dataset includes the following four variables:

1. subject_id -- Uniquely identifies each subject (an integer from 1 - 30)
2. acitivity -- Indicates what activity the individual was undertaking for the measurement
   in that row (one of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).
3. motion_label -- labels what kind of measurement this row corresponds to;
4. mean -- the mean value for this measurement for an individual / activity.
