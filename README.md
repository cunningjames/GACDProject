# GACDProject

Getting and Cleaning Data Course Project

The script contained within this repository is intended to satisfy project 
requirements for Getting and Cleaning Data. We've been given some messy data
spread out over several files; our task is to create a new, tidy dataset by
merging and summarizing.

The data in question involve measurements of three-dimensional motion for
thirty individuals. Multiple pieces of information must be aggregated:

1. An X dataset, where the (i, j)th entry records motion type j for some
   individual;
2. A Y dataset, where the entry in the ith row indicates the type of activity
   taking place when the motion was recorded in the corresponding row of X;
3. A subject dataset, where the entry in the ith row indicates the individual
   in question from the corresponding row of X;
4. A dataset of labels describing the motion recordings;
5. A dataset of labels describing the activity taking place;
6. ... where the X, Y, and subject datasets come in 'train' and 'test'
   varieties.

My end goal is a dataset that looks something like this:

  subject_id activity      motion_label        mean
1          1  WALKING tBodyAcc-mean()-X  0.27733076
2          1  WALKING tBodyAcc-mean()-Y -0.01738382
3          1  WALKING tBodyAcc-mean()-Z -0.11114810
4          1  WALKING  tBodyAcc-std()-X -0.28374026
5          1  WALKING  tBodyAcc-std()-Y  0.11446134
6          1  WALKING  tBodyAcc-std()-Z -0.26002790

which fits my interpretation of 'tidy': each row gives the mean value for an
of a motion measurement x for individual i undertaking activity j. YMMV.

All of this is much less complicated than it sounds. Because the raw data files
are all of the same dimension, they can be very simply appended together. Then
it's a matter of using a few dplyr functions to construct the tidy dataset:

1. Select only the mean and standard deviation values;
2. Note that the 'wide' dataset represents four variables (subject_id,
   activity, motion_label, and value), but the motion values are spread
   out in long rows. So we melt them into a longer / thinner dataset with
   the gather function;
3. Take the mean over motion types for each subject / activity by grouping
   and then summarizing.

Check the source in run_analysis.r for more details / comments.