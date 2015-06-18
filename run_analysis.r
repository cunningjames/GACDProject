# file: run_analysis.r
# author: James Cunningham
# date: 2015-06-18
#
# This file is intended to satisfy project requirements for the Coursera course
# Getting and Cleaning Data. We're given some messy data spread out over several
# files; our task is to create a new, tidy dataset by merging and summarizing.
#
# The data in question involve measurements of three-dimensional motion for
# thirty individuals. Multiple pieces of information must be aggregated:
#
# 1. An X dataset, where the (i, j)th entry records motion type j for some
#    individual;
# 2. A Y dataset, where the entry in the ith row indicates the type of activity
#    taking place when the motion was recorded in the corresponding row of X;
# 3. A subject dataset, where the entry in the ith row indicates the individual
#    in question from the corresponding row of X;
# 4. A dataset of labels describing the motion recordings;
# 5. A dataset of labels describing the activity taking place;
# 6. ... where the X, Y, and subject datasets come in 'train' and 'test'
#    varieties.
#
# My end goal is a dataset that looks something like this:
#
#   subject_id activity      motion_label        mean
# 1          1  WALKING tBodyAcc-mean()-X  0.27733076
# 2          1  WALKING tBodyAcc-mean()-Y -0.01738382
# 3          1  WALKING tBodyAcc-mean()-Z -0.11114810
# 4          1  WALKING  tBodyAcc-std()-X -0.28374026
# 5          1  WALKING  tBodyAcc-std()-Y  0.11446134
# 6          1  WALKING  tBodyAcc-std()-Z -0.26002790
#
# which fits my interpretation of 'tidy': each row gives the mean value for an
# of a motion measurement x for individual i undertaking activity j. YMMV.
#
# All of this is less complicated than it sounds. More or less I just slurp up
# all the data, append it, and run a couple stock dplyr functions.

library("dplyr")

# Assume we're being run from the main project directory, which contains the
# data directory.
setwd("./UCI HAR Dataset")


# The features here refer to the motion measurements, which vary by kind, type,
# axis, etc. We're appending the subject_id and activity columns, so we'll add
# those; and we only want means and standard deviations, so we'll figure those
# out for subsetting later.
var.names <- read.table("./features.txt")[, 2]
var.names <- c("subject_id", "activity", as.vector(var.names))


# These are the activity labels: whether the individual is walking, standing,
# etc. Keep these around for pretty labeling.
act.labels <- read.table("activity_labels.txt")[, 2]


# Read in the training datasets. This is really just one dataset spread over
# multiple files -- so no fancy merging here, we can just append the columns.
# X is the primary dataset; y gives the activity type; and subject identifies
# the participant.
x.train    <- read.table("./train/X_train.txt")
y.train    <- read.table("./train/y_train.txt")
s.train    <- read.table("./train/subject_train.txt")
full.train <- cbind(s.train, y.train, x.train)

# Read in the test datasets. Same deal as for training.
x.test    <- read.table("./test/X_test.txt")
y.test    <- read.table("./test/y_test.txt")
s.test    <- read.table("./test/subject_test.txt")
full.test <- cbind(s.test, y.test, x.test)


# Now just append the full test and training datasets, taking care to remove
# duplicated column names (or else dplyr won't work -- don't worry, we don't
# need those columns anyway). This satisfies Steps 1 and 4 in the assignment
# instructions.
full.all <- rbind(full.train, full.test)
names(full.all) <- var.names
full.all <- full.all[, unique(names(full.all))]


# Now we construct our tidy dataset:
#   1. Select only the mean and standard deviation values;
#   2. Note that the 'wide' dataset represents four variables (subject_id,
#      activity, motion_label, and value), but the motion values are spread
#      out in long rows. So we melt them into a longer / thinner dataset with
#      the gather function;
#   3. Take the mean over motion types for each subject / activity by grouping
#      and then summarizing.
full.means <-
    full.all %>%
    select(matches("subject_id|activity|mean\\(\\)|std\\(\\)")) %>% # Step 2
    gather(motion_label, value, -(subject_id:activity)) %>%
    group_by(subject_id, activity, motion_label) %>%
    summarize(mean = mean(value))


# As instructed in Step 3 of the assignment instructions, use descriptive
# activity names to label the activities.
full.means$activity <- factor(full.means$activity, labels = act.labels)


# Go back to where we started and save off the tidy dataset (completing Step 5).
setwd("../")

write.table(full.means, file = "motion_data.txt", row.name = F)
