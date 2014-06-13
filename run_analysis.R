#
# run_analysis.R
# Submitted BY Ron Rick Chua
#

# Note:  Please change your directory to UCI HAR Dataset is located.  Scripts might not work if it is not set properly.
# First Load Every thing to R
# Read Phase
feature_names <-  read.table("features.txt");
activity_labels <-  read.table("activity_labels.txt");

# Train
train_subject <-  read.table("train/subject_train.txt");
train_x <-  read.table("train/X_train.txt");
train_y <-  read.table("train/y_train.txt");

# Test
test_subject <-  read.table("test/subject_test.txt");
test_x <-  read.table("test/X_test.txt");
test_y <-  read.table("test/y_test.txt");


# The only purpose of this, is that you can see the data (not Garbled like the original file)
# Write Phase
# Train
write.table(train_subject , "train/CLEAN_subject_train.txt");
write.table(train_x , "train/CLEAN_X_train.txt");
write.table(train_y  , "train/CLEAN_y_train.txt");

# Test
write.table(test_subject  , "test/CLEAN_subject_test.txt");
write.table(test_x , "test/CLEAN_X_test.txt");
write.table(test_y , "test/CLEAN_y_test.txt");

