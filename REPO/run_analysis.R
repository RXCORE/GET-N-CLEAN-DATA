#
# run_analysis.R
# Submitted BY Ron Rick Chua
#

# Note: Please change your directory to UCI HAR Dataset is located. Scripts might not work if it # is not set properly.
# First Load Every thing to R

# Load Library
library(data.table);

# Read Phase
feature_names <- read.table("features.txt");
activity_labels <- read.table("activity_labels.txt");

# Train
train_subject <- read.table("train/subject_train.txt");
train_x <- read.table("train/X_train.txt");
train_y <- read.table("train/y_train.txt");

# Test
test_subject <- read.table("test/subject_test.txt");
test_x <- read.table("test/X_test.txt");
test_y <- read.table("test/y_test.txt");


# The only purpose of this, is that you can see the data (not Garbled like the original file)
# Write Phase
# Train
write.table(train_subject , "train/CLEAN_subject_train.txt");
write.table(train_x , "train/CLEAN_X_train.txt");
write.table(train_y , "train/CLEAN_y_train.txt");

# Test
write.table(test_subject , "test/CLEAN_subject_test.txt");
write.table(test_x , "test/CLEAN_X_test.txt");
write.table(test_y , "test/CLEAN_y_test.txt");




# Labeling


# Adding Labels to Activity Label with Code and Activity type
setnames(activity_labels, c("V1", "V2"),c("CODE", "ACTIVITY_TYPE"));

# Naming Train/Test Subject as Individual Subjects
setnames(train_subject , "V1", "IND_SUBJECTS");
setnames(test_subject , "V1", "IND_SUBJECTS");

# Adding Labels y train\test
setnames(train_y , "V1", "CODE");
setnames(test_y , "V1", "CODE"); 



# Converts feature_names(factor vector) to a character vector
conv_featname <- paste( feature_names[,2] ,  sep=""); 

# Applying the vector names(conv_featname) to X train\test 
setnames(train_x, 1:561, conv_featname);
setnames(test_x, 1:561, conv_featname);


# Making vectors to a Data Table
activity_labels <- data.table(activity_labels);

#train_y <- data.table(train_y);
#test_y <- data.table(test_y);

#Adding Keys to Data table for activity, train and test y
activity_labels <- setkey(activity_labels ,"CODE");

#train_y <- setkey(train_y ,"CODE");
#test_y <- setkey(test_y ,"CODE");




#---------------------------MASTER TRANSFORMER  Train
# Make a list from 1 to 7352
ROWLIST <- list(ROWNUM =  1:7352 );

# Column bind the row list, Train Individual subjects, 
# and the Activity of the individual
stage1 <- cbind( ROWLIST, train_subject, train_y) ;

# Convert to a Data Table
stage1 <- data.table(stage1);

# Setting keys to CODE
stage1 <- setkey(stage1, "CODE");

# Merge stage 1  joining Activity lables via CODE.  
#This is to get the description of the type of activity.
stage2 <- merge (stage1 , activity_labels);

# Setting keys to ROWNUM
stage2  <- setkey(stage2 , "ROWNUM") ;

# Adding a column that describes where the data set came from. Tagging as TRAIN.
stage3 <- cbind(stage2, SCR=rep("TRAIN", 7352));

# Adding the Measurements from Train x
stage4 <- cbind(stage3 , train_x) ;

# Writing this to a file. to remove the behavior of a data table.
write.table(stage4 , "STAGING4.txt");

# Loading it in memory as TIDY_TRAIN
TIDY_TRAIN <- read.table("STAGING4.txt");

#head(TIDY_TRAIN[, c(2:566)]);     query to check

 
#=================================MASTER TRANSFORMER  Test

#---------------------------
# Make a list from 1 to 2947
ROWLIST <- list(ROWNUM =  1:2947 );

# Column bind the row list, Train Individual subjects, 
# and the Activity of the individual
stage1test <- cbind( ROWLIST, test_subject, test_y) ;

# Convert to a Data Table
stage1test <- data.table(stage1test);

# Setting keys to CODE
stage1test <- setkey(stage1test, "CODE");

# Merge stage 1 test  joining Activity lables via CODE.  
#This is to get the description of the type of activity.
stage2test <- merge (stage1test , activity_labels);

# Setting keys to ROWNUM
stage2test  <- setkey(stage2test , "ROWNUM") ;

# Adding a column that describes where the data set came from. Tagging as TRAIN.
stage3test <- cbind(stage2test, SCR=rep("TEST", 2947));

# Adding the Measurements from Test x
stage4test <- cbind(stage3test  , test_x) ;

# Writing this to a file. to remove the behavior of a data table.
write.table(stage4test , "STAGING4TEST.txt");

# Loading it in memory as TIDY_TEST
TIDY_TEST <- read.table("STAGING4TEST.txt");

#head(TIDY_TEST[, c(5:566)]);     query to check



#======================== run_analysis.R
# Merge Data of Train and Test
TIDY_DATA <- rbind(TIDY_TRAIN,TIDY_TEST);
# Set Lables for Measures
setnames(TIDY_DATA, 6:566, conv_featname);
#mode(TIDY_DATA[6:566])<- "numeric"


# Creating 

EXTRAXT_MEANS_SDEV <- data.table( x=1,y=1,z=1 );
setnames(EXTRAXT_MEANS_SDEV , "x", "MEASURES"); 
setnames(EXTRAXT_MEANS_SDEV , "y", "MEANS"); 
setnames(EXTRAXT_MEANS_SDEV , "z", "STANDARD DEVIATION"); 


# Making the Means and standard deviation data sets for each measures
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-mean()-X", MEANS=mean(TIDY_DATA$"tBodyAcc-mean()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-mean()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-mean()-Y", MEANS=mean(TIDY_DATA$"tBodyAcc-mean()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-mean()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-mean()-Z", MEANS=mean(TIDY_DATA$"tBodyAcc-mean()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-mean()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-std()-X", MEANS=mean(TIDY_DATA$"tBodyAcc-std()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-std()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-std()-Y", MEANS=mean(TIDY_DATA$"tBodyAcc-std()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-std()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-std()-Z", MEANS=mean(TIDY_DATA$"tBodyAcc-std()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-std()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-mad()-X", MEANS=mean(TIDY_DATA$"tBodyAcc-mad()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-mad()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-mad()-Y", MEANS=mean(TIDY_DATA$"tBodyAcc-mad()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-mad()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-mad()-Z", MEANS=mean(TIDY_DATA$"tBodyAcc-mad()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-mad()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-max()-X", MEANS=mean(TIDY_DATA$"tBodyAcc-max()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-max()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-max()-Y", MEANS=mean(TIDY_DATA$"tBodyAcc-max()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-max()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-max()-Z", MEANS=mean(TIDY_DATA$"tBodyAcc-max()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-max()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-min()-X", MEANS=mean(TIDY_DATA$"tBodyAcc-min()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-min()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-min()-Y", MEANS=mean(TIDY_DATA$"tBodyAcc-min()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-min()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-min()-Z", MEANS=mean(TIDY_DATA$"tBodyAcc-min()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-min()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-sma()", MEANS=mean(TIDY_DATA$"tBodyAcc-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-energy()-X", MEANS=mean(TIDY_DATA$"tBodyAcc-energy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-energy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-energy()-Y", MEANS=mean(TIDY_DATA$"tBodyAcc-energy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-energy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-energy()-Z", MEANS=mean(TIDY_DATA$"tBodyAcc-energy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-energy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-iqr()-X", MEANS=mean(TIDY_DATA$"tBodyAcc-iqr()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-iqr()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-iqr()-Y", MEANS=mean(TIDY_DATA$"tBodyAcc-iqr()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-iqr()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-iqr()-Z", MEANS=mean(TIDY_DATA$"tBodyAcc-iqr()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-iqr()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-entropy()-X", MEANS=mean(TIDY_DATA$"tBodyAcc-entropy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-entropy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-entropy()-Y", MEANS=mean(TIDY_DATA$"tBodyAcc-entropy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-entropy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-entropy()-Z", MEANS=mean(TIDY_DATA$"tBodyAcc-entropy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-entropy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-arCoeff()-X,1", MEANS=mean(TIDY_DATA$"tBodyAcc-arCoeff()-X,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-arCoeff()-X,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-arCoeff()-X,2", MEANS=mean(TIDY_DATA$"tBodyAcc-arCoeff()-X,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-arCoeff()-X,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-arCoeff()-X,3", MEANS=mean(TIDY_DATA$"tBodyAcc-arCoeff()-X,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-arCoeff()-X,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-arCoeff()-X,4", MEANS=mean(TIDY_DATA$"tBodyAcc-arCoeff()-X,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-arCoeff()-X,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-arCoeff()-Y,1", MEANS=mean(TIDY_DATA$"tBodyAcc-arCoeff()-Y,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-arCoeff()-Y,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-arCoeff()-Y,2", MEANS=mean(TIDY_DATA$"tBodyAcc-arCoeff()-Y,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-arCoeff()-Y,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-arCoeff()-Y,3", MEANS=mean(TIDY_DATA$"tBodyAcc-arCoeff()-Y,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-arCoeff()-Y,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-arCoeff()-Y,4", MEANS=mean(TIDY_DATA$"tBodyAcc-arCoeff()-Y,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-arCoeff()-Y,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-arCoeff()-Z,1", MEANS=mean(TIDY_DATA$"tBodyAcc-arCoeff()-Z,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-arCoeff()-Z,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-arCoeff()-Z,2", MEANS=mean(TIDY_DATA$"tBodyAcc-arCoeff()-Z,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-arCoeff()-Z,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-arCoeff()-Z,3", MEANS=mean(TIDY_DATA$"tBodyAcc-arCoeff()-Z,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-arCoeff()-Z,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-arCoeff()-Z,4", MEANS=mean(TIDY_DATA$"tBodyAcc-arCoeff()-Z,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-arCoeff()-Z,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-correlation()-X,Y", MEANS=mean(TIDY_DATA$"tBodyAcc-correlation()-X,Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-correlation()-X,Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-correlation()-X,Z", MEANS=mean(TIDY_DATA$"tBodyAcc-correlation()-X,Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-correlation()-X,Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAcc-correlation()-Y,Z", MEANS=mean(TIDY_DATA$"tBodyAcc-correlation()-Y,Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-correlation()-Y,Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-mean()-X", MEANS=mean(TIDY_DATA$"tGravityAcc-mean()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-mean()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-mean()-Y", MEANS=mean(TIDY_DATA$"tGravityAcc-mean()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-mean()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-mean()-Z", MEANS=mean(TIDY_DATA$"tGravityAcc-mean()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-mean()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-std()-X", MEANS=mean(TIDY_DATA$"tGravityAcc-std()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-std()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-std()-Y", MEANS=mean(TIDY_DATA$"tGravityAcc-std()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-std()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-std()-Z", MEANS=mean(TIDY_DATA$"tGravityAcc-std()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-std()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-mad()-X", MEANS=mean(TIDY_DATA$"tGravityAcc-mad()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-mad()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-mad()-Y", MEANS=mean(TIDY_DATA$"tGravityAcc-mad()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-mad()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-mad()-Z", MEANS=mean(TIDY_DATA$"tGravityAcc-mad()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-mad()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-max()-X", MEANS=mean(TIDY_DATA$"tGravityAcc-max()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-max()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-max()-Y", MEANS=mean(TIDY_DATA$"tGravityAcc-max()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-max()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-max()-Z", MEANS=mean(TIDY_DATA$"tGravityAcc-max()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-max()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-min()-X", MEANS=mean(TIDY_DATA$"tGravityAcc-min()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-min()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-min()-Y", MEANS=mean(TIDY_DATA$"tGravityAcc-min()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-min()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-min()-Z", MEANS=mean(TIDY_DATA$"tGravityAcc-min()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-min()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-sma()", MEANS=mean(TIDY_DATA$"tGravityAcc-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-energy()-X", MEANS=mean(TIDY_DATA$"tGravityAcc-energy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-energy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-energy()-Y", MEANS=mean(TIDY_DATA$"tGravityAcc-energy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-energy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-energy()-Z", MEANS=mean(TIDY_DATA$"tGravityAcc-energy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-energy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-iqr()-X", MEANS=mean(TIDY_DATA$"tGravityAcc-iqr()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-iqr()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-iqr()-Y", MEANS=mean(TIDY_DATA$"tGravityAcc-iqr()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-iqr()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-iqr()-Z", MEANS=mean(TIDY_DATA$"tGravityAcc-iqr()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-iqr()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-entropy()-X", MEANS=mean(TIDY_DATA$"tGravityAcc-entropy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-entropy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-entropy()-Y", MEANS=mean(TIDY_DATA$"tGravityAcc-entropy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-entropy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-entropy()-Z", MEANS=mean(TIDY_DATA$"tGravityAcc-entropy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-entropy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-arCoeff()-X,1", MEANS=mean(TIDY_DATA$"tGravityAcc-arCoeff()-X,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-arCoeff()-X,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-arCoeff()-X,2", MEANS=mean(TIDY_DATA$"tGravityAcc-arCoeff()-X,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-arCoeff()-X,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-arCoeff()-X,3", MEANS=mean(TIDY_DATA$"tGravityAcc-arCoeff()-X,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-arCoeff()-X,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-arCoeff()-X,4", MEANS=mean(TIDY_DATA$"tGravityAcc-arCoeff()-X,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-arCoeff()-X,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-arCoeff()-Y,1", MEANS=mean(TIDY_DATA$"tGravityAcc-arCoeff()-Y,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-arCoeff()-Y,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-arCoeff()-Y,2", MEANS=mean(TIDY_DATA$"tGravityAcc-arCoeff()-Y,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-arCoeff()-Y,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-arCoeff()-Y,3", MEANS=mean(TIDY_DATA$"tGravityAcc-arCoeff()-Y,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-arCoeff()-Y,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-arCoeff()-Y,4", MEANS=mean(TIDY_DATA$"tGravityAcc-arCoeff()-Y,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-arCoeff()-Y,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-arCoeff()-Z,1", MEANS=mean(TIDY_DATA$"tGravityAcc-arCoeff()-Z,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-arCoeff()-Z,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-arCoeff()-Z,2", MEANS=mean(TIDY_DATA$"tGravityAcc-arCoeff()-Z,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-arCoeff()-Z,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-arCoeff()-Z,3", MEANS=mean(TIDY_DATA$"tGravityAcc-arCoeff()-Z,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-arCoeff()-Z,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-arCoeff()-Z,4", MEANS=mean(TIDY_DATA$"tGravityAcc-arCoeff()-Z,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-arCoeff()-Z,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-correlation()-X,Y", MEANS=mean(TIDY_DATA$"tGravityAcc-correlation()-X,Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-correlation()-X,Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-correlation()-X,Z", MEANS=mean(TIDY_DATA$"tGravityAcc-correlation()-X,Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-correlation()-X,Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAcc-correlation()-Y,Z", MEANS=mean(TIDY_DATA$"tGravityAcc-correlation()-Y,Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAcc-correlation()-Y,Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-mean()-X", MEANS=mean(TIDY_DATA$"tBodyAccJerk-mean()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-mean()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-mean()-Y", MEANS=mean(TIDY_DATA$"tBodyAccJerk-mean()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-mean()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-mean()-Z", MEANS=mean(TIDY_DATA$"tBodyAccJerk-mean()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-mean()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-std()-X", MEANS=mean(TIDY_DATA$"tBodyAccJerk-std()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-std()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-std()-Y", MEANS=mean(TIDY_DATA$"tBodyAccJerk-std()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-std()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-std()-Z", MEANS=mean(TIDY_DATA$"tBodyAccJerk-std()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-std()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-mad()-X", MEANS=mean(TIDY_DATA$"tBodyAccJerk-mad()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-mad()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-mad()-Y", MEANS=mean(TIDY_DATA$"tBodyAccJerk-mad()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-mad()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-mad()-Z", MEANS=mean(TIDY_DATA$"tBodyAccJerk-mad()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-mad()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-max()-X", MEANS=mean(TIDY_DATA$"tBodyAccJerk-max()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-max()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-max()-Y", MEANS=mean(TIDY_DATA$"tBodyAccJerk-max()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-max()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-max()-Z", MEANS=mean(TIDY_DATA$"tBodyAccJerk-max()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-max()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-min()-X", MEANS=mean(TIDY_DATA$"tBodyAccJerk-min()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-min()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-min()-Y", MEANS=mean(TIDY_DATA$"tBodyAccJerk-min()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-min()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-min()-Z", MEANS=mean(TIDY_DATA$"tBodyAccJerk-min()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-min()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-sma()", MEANS=mean(TIDY_DATA$"tBodyAccJerk-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-energy()-X", MEANS=mean(TIDY_DATA$"tBodyAccJerk-energy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-energy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-energy()-Y", MEANS=mean(TIDY_DATA$"tBodyAccJerk-energy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-energy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-energy()-Z", MEANS=mean(TIDY_DATA$"tBodyAccJerk-energy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-energy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-iqr()-X", MEANS=mean(TIDY_DATA$"tBodyAccJerk-iqr()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-iqr()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-iqr()-Y", MEANS=mean(TIDY_DATA$"tBodyAccJerk-iqr()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-iqr()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-iqr()-Z", MEANS=mean(TIDY_DATA$"tBodyAccJerk-iqr()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-iqr()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-entropy()-X", MEANS=mean(TIDY_DATA$"tBodyAccJerk-entropy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-entropy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-entropy()-Y", MEANS=mean(TIDY_DATA$"tBodyAccJerk-entropy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-entropy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-entropy()-Z", MEANS=mean(TIDY_DATA$"tBodyAccJerk-entropy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-entropy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-arCoeff()-X,1", MEANS=mean(TIDY_DATA$"tBodyAccJerk-arCoeff()-X,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-arCoeff()-X,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-arCoeff()-X,2", MEANS=mean(TIDY_DATA$"tBodyAccJerk-arCoeff()-X,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-arCoeff()-X,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-arCoeff()-X,3", MEANS=mean(TIDY_DATA$"tBodyAccJerk-arCoeff()-X,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-arCoeff()-X,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-arCoeff()-X,4", MEANS=mean(TIDY_DATA$"tBodyAccJerk-arCoeff()-X,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-arCoeff()-X,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-arCoeff()-Y,1", MEANS=mean(TIDY_DATA$"tBodyAccJerk-arCoeff()-Y,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-arCoeff()-Y,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-arCoeff()-Y,2", MEANS=mean(TIDY_DATA$"tBodyAccJerk-arCoeff()-Y,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-arCoeff()-Y,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-arCoeff()-Y,3", MEANS=mean(TIDY_DATA$"tBodyAccJerk-arCoeff()-Y,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-arCoeff()-Y,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-arCoeff()-Y,4", MEANS=mean(TIDY_DATA$"tBodyAccJerk-arCoeff()-Y,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-arCoeff()-Y,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-arCoeff()-Z,1", MEANS=mean(TIDY_DATA$"tBodyAccJerk-arCoeff()-Z,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-arCoeff()-Z,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-arCoeff()-Z,2", MEANS=mean(TIDY_DATA$"tBodyAccJerk-arCoeff()-Z,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-arCoeff()-Z,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-arCoeff()-Z,3", MEANS=mean(TIDY_DATA$"tBodyAccJerk-arCoeff()-Z,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-arCoeff()-Z,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-arCoeff()-Z,4", MEANS=mean(TIDY_DATA$"tBodyAccJerk-arCoeff()-Z,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-arCoeff()-Z,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-correlation()-X,Y", MEANS=mean(TIDY_DATA$"tBodyAccJerk-correlation()-X,Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-correlation()-X,Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-correlation()-X,Z", MEANS=mean(TIDY_DATA$"tBodyAccJerk-correlation()-X,Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-correlation()-X,Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerk-correlation()-Y,Z", MEANS=mean(TIDY_DATA$"tBodyAccJerk-correlation()-Y,Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerk-correlation()-Y,Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-mean()-X", MEANS=mean(TIDY_DATA$"tBodyGyro-mean()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-mean()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-mean()-Y", MEANS=mean(TIDY_DATA$"tBodyGyro-mean()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-mean()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-mean()-Z", MEANS=mean(TIDY_DATA$"tBodyGyro-mean()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-mean()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-std()-X", MEANS=mean(TIDY_DATA$"tBodyGyro-std()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-std()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-std()-Y", MEANS=mean(TIDY_DATA$"tBodyGyro-std()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-std()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-std()-Z", MEANS=mean(TIDY_DATA$"tBodyGyro-std()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-std()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-mad()-X", MEANS=mean(TIDY_DATA$"tBodyGyro-mad()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-mad()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-mad()-Y", MEANS=mean(TIDY_DATA$"tBodyGyro-mad()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-mad()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-mad()-Z", MEANS=mean(TIDY_DATA$"tBodyGyro-mad()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-mad()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-max()-X", MEANS=mean(TIDY_DATA$"tBodyGyro-max()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-max()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-max()-Y", MEANS=mean(TIDY_DATA$"tBodyGyro-max()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-max()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-max()-Z", MEANS=mean(TIDY_DATA$"tBodyGyro-max()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-max()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-min()-X", MEANS=mean(TIDY_DATA$"tBodyGyro-min()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-min()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-min()-Y", MEANS=mean(TIDY_DATA$"tBodyGyro-min()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-min()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-min()-Z", MEANS=mean(TIDY_DATA$"tBodyGyro-min()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-min()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-sma()", MEANS=mean(TIDY_DATA$"tBodyGyro-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-energy()-X", MEANS=mean(TIDY_DATA$"tBodyGyro-energy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-energy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-energy()-Y", MEANS=mean(TIDY_DATA$"tBodyGyro-energy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-energy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-energy()-Z", MEANS=mean(TIDY_DATA$"tBodyGyro-energy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-energy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-iqr()-X", MEANS=mean(TIDY_DATA$"tBodyGyro-iqr()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-iqr()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-iqr()-Y", MEANS=mean(TIDY_DATA$"tBodyGyro-iqr()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-iqr()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-iqr()-Z", MEANS=mean(TIDY_DATA$"tBodyGyro-iqr()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-iqr()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-entropy()-X", MEANS=mean(TIDY_DATA$"tBodyGyro-entropy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-entropy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-entropy()-Y", MEANS=mean(TIDY_DATA$"tBodyGyro-entropy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-entropy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-entropy()-Z", MEANS=mean(TIDY_DATA$"tBodyGyro-entropy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-entropy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-arCoeff()-X,1", MEANS=mean(TIDY_DATA$"tBodyGyro-arCoeff()-X,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-arCoeff()-X,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-arCoeff()-X,2", MEANS=mean(TIDY_DATA$"tBodyGyro-arCoeff()-X,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-arCoeff()-X,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-arCoeff()-X,3", MEANS=mean(TIDY_DATA$"tBodyGyro-arCoeff()-X,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-arCoeff()-X,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-arCoeff()-X,4", MEANS=mean(TIDY_DATA$"tBodyGyro-arCoeff()-X,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-arCoeff()-X,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-arCoeff()-Y,1", MEANS=mean(TIDY_DATA$"tBodyGyro-arCoeff()-Y,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-arCoeff()-Y,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-arCoeff()-Y,2", MEANS=mean(TIDY_DATA$"tBodyGyro-arCoeff()-Y,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-arCoeff()-Y,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-arCoeff()-Y,3", MEANS=mean(TIDY_DATA$"tBodyGyro-arCoeff()-Y,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-arCoeff()-Y,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-arCoeff()-Y,4", MEANS=mean(TIDY_DATA$"tBodyGyro-arCoeff()-Y,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-arCoeff()-Y,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-arCoeff()-Z,1", MEANS=mean(TIDY_DATA$"tBodyGyro-arCoeff()-Z,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-arCoeff()-Z,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-arCoeff()-Z,2", MEANS=mean(TIDY_DATA$"tBodyGyro-arCoeff()-Z,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-arCoeff()-Z,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-arCoeff()-Z,3", MEANS=mean(TIDY_DATA$"tBodyGyro-arCoeff()-Z,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-arCoeff()-Z,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-arCoeff()-Z,4", MEANS=mean(TIDY_DATA$"tBodyGyro-arCoeff()-Z,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-arCoeff()-Z,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-correlation()-X,Y", MEANS=mean(TIDY_DATA$"tBodyGyro-correlation()-X,Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-correlation()-X,Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-correlation()-X,Z", MEANS=mean(TIDY_DATA$"tBodyGyro-correlation()-X,Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-correlation()-X,Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyro-correlation()-Y,Z", MEANS=mean(TIDY_DATA$"tBodyGyro-correlation()-Y,Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyro-correlation()-Y,Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-mean()-X", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-mean()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-mean()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-mean()-Y", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-mean()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-mean()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-mean()-Z", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-mean()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-mean()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-std()-X", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-std()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-std()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-std()-Y", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-std()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-std()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-std()-Z", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-std()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-std()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-mad()-X", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-mad()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-mad()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-mad()-Y", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-mad()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-mad()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-mad()-Z", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-mad()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-mad()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-max()-X", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-max()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-max()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-max()-Y", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-max()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-max()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-max()-Z", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-max()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-max()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-min()-X", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-min()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-min()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-min()-Y", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-min()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-min()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-min()-Z", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-min()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-min()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-sma()", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-energy()-X", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-energy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-energy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-energy()-Y", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-energy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-energy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-energy()-Z", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-energy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-energy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-iqr()-X", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-iqr()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-iqr()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-iqr()-Y", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-iqr()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-iqr()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-iqr()-Z", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-iqr()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-iqr()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-entropy()-X", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-entropy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-entropy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-entropy()-Y", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-entropy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-entropy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-entropy()-Z", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-entropy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-entropy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-arCoeff()-X,1", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-arCoeff()-X,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-arCoeff()-X,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-arCoeff()-X,2", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-arCoeff()-X,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-arCoeff()-X,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-arCoeff()-X,3", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-arCoeff()-X,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-arCoeff()-X,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-arCoeff()-X,4", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-arCoeff()-X,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-arCoeff()-X,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-arCoeff()-Y,1", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Y,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Y,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-arCoeff()-Y,2", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Y,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Y,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-arCoeff()-Y,3", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Y,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Y,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-arCoeff()-Y,4", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Y,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Y,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-arCoeff()-Z,1", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Z,1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Z,1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-arCoeff()-Z,2", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Z,2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Z,2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-arCoeff()-Z,3", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Z,3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Z,3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-arCoeff()-Z,4", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Z,4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-arCoeff()-Z,4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-correlation()-X,Y", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-correlation()-X,Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-correlation()-X,Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-correlation()-X,Z", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-correlation()-X,Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-correlation()-X,Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerk-correlation()-Y,Z", MEANS=mean(TIDY_DATA$"tBodyGyroJerk-correlation()-Y,Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerk-correlation()-Y,Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccMag-mean()", MEANS=mean(TIDY_DATA$"tBodyAccMag-mean()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccMag-mean()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccMag-std()", MEANS=mean(TIDY_DATA$"tBodyAccMag-std()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccMag-std()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccMag-mad()", MEANS=mean(TIDY_DATA$"tBodyAccMag-mad()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccMag-mad()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccMag-max()", MEANS=mean(TIDY_DATA$"tBodyAccMag-max()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccMag-max()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccMag-min()", MEANS=mean(TIDY_DATA$"tBodyAccMag-min()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccMag-min()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccMag-sma()", MEANS=mean(TIDY_DATA$"tBodyAccMag-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccMag-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccMag-energy()", MEANS=mean(TIDY_DATA$"tBodyAccMag-energy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccMag-energy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccMag-iqr()", MEANS=mean(TIDY_DATA$"tBodyAccMag-iqr()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccMag-iqr()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccMag-entropy()", MEANS=mean(TIDY_DATA$"tBodyAccMag-entropy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccMag-entropy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccMag-arCoeff()1", MEANS=mean(TIDY_DATA$"tBodyAccMag-arCoeff()1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccMag-arCoeff()1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccMag-arCoeff()2", MEANS=mean(TIDY_DATA$"tBodyAccMag-arCoeff()2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccMag-arCoeff()2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccMag-arCoeff()3", MEANS=mean(TIDY_DATA$"tBodyAccMag-arCoeff()3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccMag-arCoeff()3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccMag-arCoeff()4", MEANS=mean(TIDY_DATA$"tBodyAccMag-arCoeff()4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccMag-arCoeff()4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAccMag-mean()", MEANS=mean(TIDY_DATA$"tGravityAccMag-mean()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAccMag-mean()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAccMag-std()", MEANS=mean(TIDY_DATA$"tGravityAccMag-std()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAccMag-std()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAccMag-mad()", MEANS=mean(TIDY_DATA$"tGravityAccMag-mad()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAccMag-mad()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAccMag-max()", MEANS=mean(TIDY_DATA$"tGravityAccMag-max()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAccMag-max()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAccMag-min()", MEANS=mean(TIDY_DATA$"tGravityAccMag-min()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAccMag-min()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAccMag-sma()", MEANS=mean(TIDY_DATA$"tGravityAccMag-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAccMag-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAccMag-energy()", MEANS=mean(TIDY_DATA$"tGravityAccMag-energy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAccMag-energy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAccMag-iqr()", MEANS=mean(TIDY_DATA$"tGravityAccMag-iqr()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAccMag-iqr()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAccMag-entropy()", MEANS=mean(TIDY_DATA$"tGravityAccMag-entropy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAccMag-entropy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAccMag-arCoeff()1", MEANS=mean(TIDY_DATA$"tGravityAccMag-arCoeff()1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAccMag-arCoeff()1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAccMag-arCoeff()2", MEANS=mean(TIDY_DATA$"tGravityAccMag-arCoeff()2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAccMag-arCoeff()2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAccMag-arCoeff()3", MEANS=mean(TIDY_DATA$"tGravityAccMag-arCoeff()3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAccMag-arCoeff()3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tGravityAccMag-arCoeff()4", MEANS=mean(TIDY_DATA$"tGravityAccMag-arCoeff()4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tGravityAccMag-arCoeff()4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerkMag-mean()", MEANS=mean(TIDY_DATA$"tBodyAccJerkMag-mean()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerkMag-mean()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerkMag-std()", MEANS=mean(TIDY_DATA$"tBodyAccJerkMag-std()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerkMag-std()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerkMag-mad()", MEANS=mean(TIDY_DATA$"tBodyAccJerkMag-mad()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerkMag-mad()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerkMag-max()", MEANS=mean(TIDY_DATA$"tBodyAccJerkMag-max()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerkMag-max()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerkMag-min()", MEANS=mean(TIDY_DATA$"tBodyAccJerkMag-min()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerkMag-min()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerkMag-sma()", MEANS=mean(TIDY_DATA$"tBodyAccJerkMag-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerkMag-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerkMag-energy()", MEANS=mean(TIDY_DATA$"tBodyAccJerkMag-energy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerkMag-energy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerkMag-iqr()", MEANS=mean(TIDY_DATA$"tBodyAccJerkMag-iqr()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerkMag-iqr()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerkMag-entropy()", MEANS=mean(TIDY_DATA$"tBodyAccJerkMag-entropy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerkMag-entropy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerkMag-arCoeff()1", MEANS=mean(TIDY_DATA$"tBodyAccJerkMag-arCoeff()1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerkMag-arCoeff()1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerkMag-arCoeff()2", MEANS=mean(TIDY_DATA$"tBodyAccJerkMag-arCoeff()2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerkMag-arCoeff()2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerkMag-arCoeff()3", MEANS=mean(TIDY_DATA$"tBodyAccJerkMag-arCoeff()3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerkMag-arCoeff()3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyAccJerkMag-arCoeff()4", MEANS=mean(TIDY_DATA$"tBodyAccJerkMag-arCoeff()4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAccJerkMag-arCoeff()4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroMag-mean()", MEANS=mean(TIDY_DATA$"tBodyGyroMag-mean()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroMag-mean()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroMag-std()", MEANS=mean(TIDY_DATA$"tBodyGyroMag-std()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroMag-std()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroMag-mad()", MEANS=mean(TIDY_DATA$"tBodyGyroMag-mad()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroMag-mad()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroMag-max()", MEANS=mean(TIDY_DATA$"tBodyGyroMag-max()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroMag-max()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroMag-min()", MEANS=mean(TIDY_DATA$"tBodyGyroMag-min()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroMag-min()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroMag-sma()", MEANS=mean(TIDY_DATA$"tBodyGyroMag-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroMag-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroMag-energy()", MEANS=mean(TIDY_DATA$"tBodyGyroMag-energy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroMag-energy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroMag-iqr()", MEANS=mean(TIDY_DATA$"tBodyGyroMag-iqr()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroMag-iqr()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroMag-entropy()", MEANS=mean(TIDY_DATA$"tBodyGyroMag-entropy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroMag-entropy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroMag-arCoeff()1", MEANS=mean(TIDY_DATA$"tBodyGyroMag-arCoeff()1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroMag-arCoeff()1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroMag-arCoeff()2", MEANS=mean(TIDY_DATA$"tBodyGyroMag-arCoeff()2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroMag-arCoeff()2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroMag-arCoeff()3", MEANS=mean(TIDY_DATA$"tBodyGyroMag-arCoeff()3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroMag-arCoeff()3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroMag-arCoeff()4", MEANS=mean(TIDY_DATA$"tBodyGyroMag-arCoeff()4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroMag-arCoeff()4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerkMag-mean()", MEANS=mean(TIDY_DATA$"tBodyGyroJerkMag-mean()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerkMag-mean()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerkMag-std()", MEANS=mean(TIDY_DATA$"tBodyGyroJerkMag-std()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerkMag-std()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerkMag-mad()", MEANS=mean(TIDY_DATA$"tBodyGyroJerkMag-mad()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerkMag-mad()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerkMag-max()", MEANS=mean(TIDY_DATA$"tBodyGyroJerkMag-max()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerkMag-max()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerkMag-min()", MEANS=mean(TIDY_DATA$"tBodyGyroJerkMag-min()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerkMag-min()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerkMag-sma()", MEANS=mean(TIDY_DATA$"tBodyGyroJerkMag-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerkMag-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerkMag-energy()", MEANS=mean(TIDY_DATA$"tBodyGyroJerkMag-energy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerkMag-energy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerkMag-iqr()", MEANS=mean(TIDY_DATA$"tBodyGyroJerkMag-iqr()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerkMag-iqr()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerkMag-entropy()", MEANS=mean(TIDY_DATA$"tBodyGyroJerkMag-entropy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerkMag-entropy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerkMag-arCoeff()1", MEANS=mean(TIDY_DATA$"tBodyGyroJerkMag-arCoeff()1"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerkMag-arCoeff()1",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerkMag-arCoeff()2", MEANS=mean(TIDY_DATA$"tBodyGyroJerkMag-arCoeff()2"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerkMag-arCoeff()2",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerkMag-arCoeff()3", MEANS=mean(TIDY_DATA$"tBodyGyroJerkMag-arCoeff()3"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerkMag-arCoeff()3",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="tBodyGyroJerkMag-arCoeff()4", MEANS=mean(TIDY_DATA$"tBodyGyroJerkMag-arCoeff()4"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyGyroJerkMag-arCoeff()4",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-mean()-X", MEANS=mean(TIDY_DATA$"fBodyAcc-mean()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-mean()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-mean()-Y", MEANS=mean(TIDY_DATA$"fBodyAcc-mean()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-mean()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-mean()-Z", MEANS=mean(TIDY_DATA$"fBodyAcc-mean()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-mean()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-std()-X", MEANS=mean(TIDY_DATA$"fBodyAcc-std()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-std()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-std()-Y", MEANS=mean(TIDY_DATA$"fBodyAcc-std()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-std()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-std()-Z", MEANS=mean(TIDY_DATA$"fBodyAcc-std()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-std()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-mad()-X", MEANS=mean(TIDY_DATA$"fBodyAcc-mad()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-mad()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-mad()-Y", MEANS=mean(TIDY_DATA$"fBodyAcc-mad()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-mad()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-mad()-Z", MEANS=mean(TIDY_DATA$"fBodyAcc-mad()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-mad()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-max()-X", MEANS=mean(TIDY_DATA$"fBodyAcc-max()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-max()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-max()-Y", MEANS=mean(TIDY_DATA$"fBodyAcc-max()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-max()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-max()-Z", MEANS=mean(TIDY_DATA$"fBodyAcc-max()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-max()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-min()-X", MEANS=mean(TIDY_DATA$"fBodyAcc-min()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-min()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-min()-Y", MEANS=mean(TIDY_DATA$"fBodyAcc-min()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-min()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-min()-Z", MEANS=mean(TIDY_DATA$"fBodyAcc-min()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-min()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-sma()", MEANS=mean(TIDY_DATA$"fBodyAcc-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-energy()-X", MEANS=mean(TIDY_DATA$"fBodyAcc-energy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-energy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-energy()-Y", MEANS=mean(TIDY_DATA$"fBodyAcc-energy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-energy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-energy()-Z", MEANS=mean(TIDY_DATA$"fBodyAcc-energy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-energy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-iqr()-X", MEANS=mean(TIDY_DATA$"fBodyAcc-iqr()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-iqr()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-iqr()-Y", MEANS=mean(TIDY_DATA$"fBodyAcc-iqr()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-iqr()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-iqr()-Z", MEANS=mean(TIDY_DATA$"fBodyAcc-iqr()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-iqr()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-entropy()-X", MEANS=mean(TIDY_DATA$"fBodyAcc-entropy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-entropy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-entropy()-Y", MEANS=mean(TIDY_DATA$"fBodyAcc-entropy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-entropy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-entropy()-Z", MEANS=mean(TIDY_DATA$"fBodyAcc-entropy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-entropy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-maxInds-X", MEANS=mean(TIDY_DATA$"fBodyAcc-maxInds-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-maxInds-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-maxInds-Y", MEANS=mean(TIDY_DATA$"fBodyAcc-maxInds-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-maxInds-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-maxInds-Z", MEANS=mean(TIDY_DATA$"fBodyAcc-maxInds-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-maxInds-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-meanFreq()-X", MEANS=mean(TIDY_DATA$"fBodyAcc-meanFreq()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-meanFreq()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-meanFreq()-Y", MEANS=mean(TIDY_DATA$"fBodyAcc-meanFreq()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-meanFreq()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-meanFreq()-Z", MEANS=mean(TIDY_DATA$"fBodyAcc-meanFreq()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-meanFreq()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-skewness()-X", MEANS=mean(TIDY_DATA$"fBodyAcc-skewness()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-skewness()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-kurtosis()-X", MEANS=mean(TIDY_DATA$"fBodyAcc-kurtosis()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-kurtosis()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-skewness()-Y", MEANS=mean(TIDY_DATA$"fBodyAcc-skewness()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-skewness()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-kurtosis()-Y", MEANS=mean(TIDY_DATA$"fBodyAcc-kurtosis()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-kurtosis()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-skewness()-Z", MEANS=mean(TIDY_DATA$"fBodyAcc-skewness()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-skewness()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-kurtosis()-Z", MEANS=mean(TIDY_DATA$"fBodyAcc-kurtosis()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-kurtosis()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-1,8", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,8"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,8",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-9,16", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-9,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-9,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-17,24", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-17,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-17,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-25,32", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-25,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-25,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-33,40", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-33,40"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-33,40",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-41,48", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-41,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-41,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-49,56", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-49,56"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-49,56",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-57,64", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-57,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-57,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-1,16", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-17,32", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-17,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-17,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-33,48", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-33,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-33,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-49,64", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-49,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-49,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-1,24", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-25,48", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-25,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-25,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-1,8", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,8"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,8",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-9,16", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-9,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-9,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-17,24", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-17,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-17,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-25,32", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-25,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-25,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-33,40", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-33,40"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-33,40",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-41,48", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-41,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-41,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-49,56", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-49,56"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-49,56",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-57,64", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-57,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-57,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-1,16", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-17,32", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-17,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-17,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-33,48", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-33,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-33,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-49,64", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-49,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-49,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-1,24", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-25,48", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-25,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-25,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-1,8", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,8"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,8",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-9,16", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-9,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-9,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-17,24", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-17,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-17,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-25,32", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-25,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-25,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-33,40", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-33,40"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-33,40",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-41,48", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-41,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-41,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-49,56", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-49,56"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-49,56",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-57,64", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-57,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-57,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-1,16", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-17,32", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-17,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-17,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-33,48", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-33,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-33,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-49,64", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-49,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-49,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-1,24", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-1,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAcc-bandsEnergy()-25,48", MEANS=mean(TIDY_DATA$"fBodyAcc-bandsEnergy()-25,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAcc-bandsEnergy()-25,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-mean()-X", MEANS=mean(TIDY_DATA$"fBodyAccJerk-mean()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-mean()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-mean()-Y", MEANS=mean(TIDY_DATA$"fBodyAccJerk-mean()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-mean()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-mean()-Z", MEANS=mean(TIDY_DATA$"fBodyAccJerk-mean()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-mean()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-std()-X", MEANS=mean(TIDY_DATA$"fBodyAccJerk-std()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-std()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-std()-Y", MEANS=mean(TIDY_DATA$"fBodyAccJerk-std()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-std()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-std()-Z", MEANS=mean(TIDY_DATA$"fBodyAccJerk-std()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-std()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-mad()-X", MEANS=mean(TIDY_DATA$"fBodyAccJerk-mad()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-mad()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-mad()-Y", MEANS=mean(TIDY_DATA$"fBodyAccJerk-mad()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-mad()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-mad()-Z", MEANS=mean(TIDY_DATA$"fBodyAccJerk-mad()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-mad()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-max()-X", MEANS=mean(TIDY_DATA$"fBodyAccJerk-max()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-max()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-max()-Y", MEANS=mean(TIDY_DATA$"fBodyAccJerk-max()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-max()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-max()-Z", MEANS=mean(TIDY_DATA$"fBodyAccJerk-max()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-max()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-min()-X", MEANS=mean(TIDY_DATA$"fBodyAccJerk-min()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-min()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-min()-Y", MEANS=mean(TIDY_DATA$"fBodyAccJerk-min()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-min()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-min()-Z", MEANS=mean(TIDY_DATA$"fBodyAccJerk-min()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-min()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-sma()", MEANS=mean(TIDY_DATA$"fBodyAccJerk-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-energy()-X", MEANS=mean(TIDY_DATA$"fBodyAccJerk-energy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-energy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-energy()-Y", MEANS=mean(TIDY_DATA$"fBodyAccJerk-energy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-energy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-energy()-Z", MEANS=mean(TIDY_DATA$"fBodyAccJerk-energy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-energy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-iqr()-X", MEANS=mean(TIDY_DATA$"fBodyAccJerk-iqr()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-iqr()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-iqr()-Y", MEANS=mean(TIDY_DATA$"fBodyAccJerk-iqr()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-iqr()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-iqr()-Z", MEANS=mean(TIDY_DATA$"fBodyAccJerk-iqr()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-iqr()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-entropy()-X", MEANS=mean(TIDY_DATA$"fBodyAccJerk-entropy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-entropy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-entropy()-Y", MEANS=mean(TIDY_DATA$"fBodyAccJerk-entropy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-entropy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-entropy()-Z", MEANS=mean(TIDY_DATA$"fBodyAccJerk-entropy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-entropy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-maxInds-X", MEANS=mean(TIDY_DATA$"fBodyAccJerk-maxInds-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-maxInds-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-maxInds-Y", MEANS=mean(TIDY_DATA$"fBodyAccJerk-maxInds-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-maxInds-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-maxInds-Z", MEANS=mean(TIDY_DATA$"fBodyAccJerk-maxInds-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-maxInds-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-meanFreq()-X", MEANS=mean(TIDY_DATA$"fBodyAccJerk-meanFreq()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-meanFreq()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-meanFreq()-Y", MEANS=mean(TIDY_DATA$"fBodyAccJerk-meanFreq()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-meanFreq()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-meanFreq()-Z", MEANS=mean(TIDY_DATA$"fBodyAccJerk-meanFreq()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-meanFreq()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-skewness()-X", MEANS=mean(TIDY_DATA$"fBodyAccJerk-skewness()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-skewness()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-kurtosis()-X", MEANS=mean(TIDY_DATA$"fBodyAccJerk-kurtosis()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-kurtosis()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-skewness()-Y", MEANS=mean(TIDY_DATA$"fBodyAccJerk-skewness()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-skewness()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-kurtosis()-Y", MEANS=mean(TIDY_DATA$"fBodyAccJerk-kurtosis()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-kurtosis()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-skewness()-Z", MEANS=mean(TIDY_DATA$"fBodyAccJerk-skewness()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-skewness()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-kurtosis()-Z", MEANS=mean(TIDY_DATA$"fBodyAccJerk-kurtosis()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-kurtosis()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-1,8", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,8"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,8",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-9,16", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-9,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-9,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-17,24", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-17,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-17,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-25,32", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-25,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-25,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-33,40", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-33,40"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-33,40",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-41,48", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-41,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-41,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-49,56", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-49,56"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-49,56",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-57,64", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-57,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-57,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-1,16", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-17,32", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-17,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-17,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-33,48", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-33,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-33,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-49,64", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-49,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-49,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-1,24", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-25,48", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-25,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-25,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-1,8", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,8"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,8",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-9,16", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-9,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-9,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-17,24", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-17,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-17,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-25,32", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-25,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-25,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-33,40", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-33,40"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-33,40",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-41,48", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-41,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-41,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-49,56", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-49,56"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-49,56",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-57,64", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-57,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-57,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-1,16", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-17,32", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-17,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-17,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-33,48", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-33,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-33,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-49,64", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-49,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-49,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-1,24", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-25,48", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-25,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-25,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-1,8", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,8"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,8",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-9,16", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-9,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-9,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-17,24", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-17,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-17,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-25,32", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-25,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-25,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-33,40", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-33,40"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-33,40",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-41,48", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-41,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-41,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-49,56", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-49,56"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-49,56",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-57,64", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-57,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-57,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-1,16", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-17,32", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-17,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-17,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-33,48", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-33,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-33,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-49,64", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-49,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-49,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-1,24", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-1,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccJerk-bandsEnergy()-25,48", MEANS=mean(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-25,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccJerk-bandsEnergy()-25,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-mean()-X", MEANS=mean(TIDY_DATA$"fBodyGyro-mean()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-mean()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-mean()-Y", MEANS=mean(TIDY_DATA$"fBodyGyro-mean()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-mean()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-mean()-Z", MEANS=mean(TIDY_DATA$"fBodyGyro-mean()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-mean()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-std()-X", MEANS=mean(TIDY_DATA$"fBodyGyro-std()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-std()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-std()-Y", MEANS=mean(TIDY_DATA$"fBodyGyro-std()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-std()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-std()-Z", MEANS=mean(TIDY_DATA$"fBodyGyro-std()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-std()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-mad()-X", MEANS=mean(TIDY_DATA$"fBodyGyro-mad()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-mad()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-mad()-Y", MEANS=mean(TIDY_DATA$"fBodyGyro-mad()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-mad()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-mad()-Z", MEANS=mean(TIDY_DATA$"fBodyGyro-mad()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-mad()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-max()-X", MEANS=mean(TIDY_DATA$"fBodyGyro-max()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-max()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-max()-Y", MEANS=mean(TIDY_DATA$"fBodyGyro-max()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-max()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-max()-Z", MEANS=mean(TIDY_DATA$"fBodyGyro-max()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-max()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-min()-X", MEANS=mean(TIDY_DATA$"fBodyGyro-min()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-min()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-min()-Y", MEANS=mean(TIDY_DATA$"fBodyGyro-min()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-min()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-min()-Z", MEANS=mean(TIDY_DATA$"fBodyGyro-min()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-min()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-sma()", MEANS=mean(TIDY_DATA$"fBodyGyro-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-energy()-X", MEANS=mean(TIDY_DATA$"fBodyGyro-energy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-energy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-energy()-Y", MEANS=mean(TIDY_DATA$"fBodyGyro-energy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-energy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-energy()-Z", MEANS=mean(TIDY_DATA$"fBodyGyro-energy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-energy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-iqr()-X", MEANS=mean(TIDY_DATA$"fBodyGyro-iqr()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-iqr()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-iqr()-Y", MEANS=mean(TIDY_DATA$"fBodyGyro-iqr()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-iqr()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-iqr()-Z", MEANS=mean(TIDY_DATA$"fBodyGyro-iqr()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-iqr()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-entropy()-X", MEANS=mean(TIDY_DATA$"fBodyGyro-entropy()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-entropy()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-entropy()-Y", MEANS=mean(TIDY_DATA$"fBodyGyro-entropy()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-entropy()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-entropy()-Z", MEANS=mean(TIDY_DATA$"fBodyGyro-entropy()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-entropy()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-maxInds-X", MEANS=mean(TIDY_DATA$"fBodyGyro-maxInds-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-maxInds-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-maxInds-Y", MEANS=mean(TIDY_DATA$"fBodyGyro-maxInds-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-maxInds-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-maxInds-Z", MEANS=mean(TIDY_DATA$"fBodyGyro-maxInds-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-maxInds-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-meanFreq()-X", MEANS=mean(TIDY_DATA$"fBodyGyro-meanFreq()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-meanFreq()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-meanFreq()-Y", MEANS=mean(TIDY_DATA$"fBodyGyro-meanFreq()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-meanFreq()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-meanFreq()-Z", MEANS=mean(TIDY_DATA$"fBodyGyro-meanFreq()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-meanFreq()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-skewness()-X", MEANS=mean(TIDY_DATA$"fBodyGyro-skewness()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-skewness()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-kurtosis()-X", MEANS=mean(TIDY_DATA$"fBodyGyro-kurtosis()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-kurtosis()-X",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-skewness()-Y", MEANS=mean(TIDY_DATA$"fBodyGyro-skewness()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-skewness()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-kurtosis()-Y", MEANS=mean(TIDY_DATA$"fBodyGyro-kurtosis()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-kurtosis()-Y",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-skewness()-Z", MEANS=mean(TIDY_DATA$"fBodyGyro-skewness()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-skewness()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-kurtosis()-Z", MEANS=mean(TIDY_DATA$"fBodyGyro-kurtosis()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-kurtosis()-Z",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-1,8", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,8"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,8",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-9,16", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-9,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-9,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-17,24", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-17,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-17,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-25,32", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-25,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-25,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-33,40", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-33,40"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-33,40",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-41,48", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-41,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-41,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-49,56", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-49,56"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-49,56",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-57,64", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-57,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-57,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-1,16", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-17,32", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-17,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-17,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-33,48", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-33,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-33,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-49,64", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-49,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-49,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-1,24", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-25,48", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-25,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-25,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-1,8", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,8"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,8",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-9,16", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-9,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-9,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-17,24", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-17,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-17,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-25,32", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-25,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-25,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-33,40", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-33,40"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-33,40",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-41,48", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-41,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-41,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-49,56", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-49,56"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-49,56",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-57,64", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-57,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-57,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-1,16", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-17,32", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-17,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-17,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-33,48", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-33,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-33,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-49,64", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-49,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-49,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-1,24", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-25,48", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-25,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-25,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-1,8", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,8"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,8",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-9,16", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-9,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-9,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-17,24", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-17,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-17,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-25,32", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-25,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-25,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-33,40", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-33,40"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-33,40",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-41,48", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-41,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-41,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-49,56", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-49,56"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-49,56",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-57,64", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-57,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-57,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-1,16", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,16"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,16",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-17,32", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-17,32"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-17,32",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-33,48", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-33,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-33,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-49,64", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-49,64"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-49,64",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-1,24", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,24"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-1,24",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyGyro-bandsEnergy()-25,48", MEANS=mean(TIDY_DATA$"fBodyGyro-bandsEnergy()-25,48"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyGyro-bandsEnergy()-25,48",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccMag-mean()", MEANS=mean(TIDY_DATA$"fBodyAccMag-mean()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccMag-mean()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccMag-std()", MEANS=mean(TIDY_DATA$"fBodyAccMag-std()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccMag-std()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccMag-mad()", MEANS=mean(TIDY_DATA$"fBodyAccMag-mad()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccMag-mad()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccMag-max()", MEANS=mean(TIDY_DATA$"fBodyAccMag-max()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccMag-max()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccMag-min()", MEANS=mean(TIDY_DATA$"fBodyAccMag-min()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccMag-min()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccMag-sma()", MEANS=mean(TIDY_DATA$"fBodyAccMag-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccMag-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccMag-energy()", MEANS=mean(TIDY_DATA$"fBodyAccMag-energy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccMag-energy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccMag-iqr()", MEANS=mean(TIDY_DATA$"fBodyAccMag-iqr()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccMag-iqr()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccMag-entropy()", MEANS=mean(TIDY_DATA$"fBodyAccMag-entropy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccMag-entropy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccMag-maxInds", MEANS=mean(TIDY_DATA$"fBodyAccMag-maxInds"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccMag-maxInds",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccMag-meanFreq()", MEANS=mean(TIDY_DATA$"fBodyAccMag-meanFreq()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccMag-meanFreq()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccMag-skewness()", MEANS=mean(TIDY_DATA$"fBodyAccMag-skewness()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccMag-skewness()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyAccMag-kurtosis()", MEANS=mean(TIDY_DATA$"fBodyAccMag-kurtosis()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyAccMag-kurtosis()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyAccJerkMag-mean()", MEANS=mean(TIDY_DATA$"fBodyBodyAccJerkMag-mean()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyAccJerkMag-mean()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyAccJerkMag-std()", MEANS=mean(TIDY_DATA$"fBodyBodyAccJerkMag-std()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyAccJerkMag-std()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyAccJerkMag-mad()", MEANS=mean(TIDY_DATA$"fBodyBodyAccJerkMag-mad()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyAccJerkMag-mad()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyAccJerkMag-max()", MEANS=mean(TIDY_DATA$"fBodyBodyAccJerkMag-max()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyAccJerkMag-max()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyAccJerkMag-min()", MEANS=mean(TIDY_DATA$"fBodyBodyAccJerkMag-min()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyAccJerkMag-min()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyAccJerkMag-sma()", MEANS=mean(TIDY_DATA$"fBodyBodyAccJerkMag-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyAccJerkMag-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyAccJerkMag-energy()", MEANS=mean(TIDY_DATA$"fBodyBodyAccJerkMag-energy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyAccJerkMag-energy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyAccJerkMag-iqr()", MEANS=mean(TIDY_DATA$"fBodyBodyAccJerkMag-iqr()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyAccJerkMag-iqr()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyAccJerkMag-entropy()", MEANS=mean(TIDY_DATA$"fBodyBodyAccJerkMag-entropy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyAccJerkMag-entropy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyAccJerkMag-maxInds", MEANS=mean(TIDY_DATA$"fBodyBodyAccJerkMag-maxInds"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyAccJerkMag-maxInds",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyAccJerkMag-meanFreq()", MEANS=mean(TIDY_DATA$"fBodyBodyAccJerkMag-meanFreq()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyAccJerkMag-meanFreq()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyAccJerkMag-skewness()", MEANS=mean(TIDY_DATA$"fBodyBodyAccJerkMag-skewness()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyAccJerkMag-skewness()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyAccJerkMag-kurtosis()", MEANS=mean(TIDY_DATA$"fBodyBodyAccJerkMag-kurtosis()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyAccJerkMag-kurtosis()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroMag-mean()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroMag-mean()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroMag-mean()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroMag-std()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroMag-std()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroMag-std()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroMag-mad()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroMag-mad()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroMag-mad()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroMag-max()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroMag-max()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroMag-max()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroMag-min()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroMag-min()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroMag-min()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroMag-sma()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroMag-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroMag-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroMag-energy()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroMag-energy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroMag-energy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroMag-iqr()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroMag-iqr()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroMag-iqr()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroMag-entropy()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroMag-entropy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroMag-entropy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroMag-maxInds", MEANS=mean(TIDY_DATA$"fBodyBodyGyroMag-maxInds"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroMag-maxInds",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroMag-meanFreq()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroMag-meanFreq()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroMag-meanFreq()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroMag-skewness()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroMag-skewness()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroMag-skewness()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroMag-kurtosis()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroMag-kurtosis()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroMag-kurtosis()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroJerkMag-mean()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroJerkMag-mean()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroJerkMag-mean()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroJerkMag-std()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroJerkMag-std()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroJerkMag-std()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroJerkMag-mad()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroJerkMag-mad()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroJerkMag-mad()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroJerkMag-max()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroJerkMag-max()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroJerkMag-max()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroJerkMag-min()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroJerkMag-min()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroJerkMag-min()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroJerkMag-sma()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroJerkMag-sma()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroJerkMag-sma()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroJerkMag-energy()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroJerkMag-energy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroJerkMag-energy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroJerkMag-iqr()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroJerkMag-iqr()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroJerkMag-iqr()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroJerkMag-entropy()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroJerkMag-entropy()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroJerkMag-entropy()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroJerkMag-maxInds", MEANS=mean(TIDY_DATA$"fBodyBodyGyroJerkMag-maxInds"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroJerkMag-maxInds",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroJerkMag-meanFreq()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroJerkMag-meanFreq()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroJerkMag-meanFreq()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroJerkMag-skewness()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroJerkMag-skewness()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroJerkMag-skewness()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="fBodyBodyGyroJerkMag-kurtosis()", MEANS=mean(TIDY_DATA$"fBodyBodyGyroJerkMag-kurtosis()"), "STANDARD DEVIATION"=sd(TIDY_DATA$"fBodyBodyGyroJerkMag-kurtosis()",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="angle(tBodyAccMean,gravity)", MEANS=mean(TIDY_DATA$"angle(tBodyAccMean,gravity)"), "STANDARD DEVIATION"=sd(TIDY_DATA$"angle(tBodyAccMean,gravity)",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="angle(tBodyAccJerkMean),gravityMean)", MEANS=mean(TIDY_DATA$"angle(tBodyAccJerkMean),gravityMean)"), "STANDARD DEVIATION"=sd(TIDY_DATA$"angle(tBodyAccJerkMean),gravityMean)",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="angle(tBodyGyroMean,gravityMean)", MEANS=mean(TIDY_DATA$"angle(tBodyGyroMean,gravityMean)"), "STANDARD DEVIATION"=sd(TIDY_DATA$"angle(tBodyGyroMean,gravityMean)",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="angle(tBodyGyroJerkMean,gravityMean)", MEANS=mean(TIDY_DATA$"angle(tBodyGyroJerkMean,gravityMean)"), "STANDARD DEVIATION"=sd(TIDY_DATA$"angle(tBodyGyroJerkMean,gravityMean)",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="angle(X,gravityMean)", MEANS=mean(TIDY_DATA$"angle(X,gravityMean)"), "STANDARD DEVIATION"=sd(TIDY_DATA$"angle(X,gravityMean)",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="angle(Y,gravityMean)", MEANS=mean(TIDY_DATA$"angle(Y,gravityMean)"), "STANDARD DEVIATION"=sd(TIDY_DATA$"angle(Y,gravityMean)",  na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV ,   data.table(MEASURES="angle(Z,gravityMean)", MEANS=mean(TIDY_DATA$"angle(Z,gravityMean)"), "STANDARD DEVIATION"=sd(TIDY_DATA$"angle(Z,gravityMean)",  na.rm = FALSE)));


#Write to a file
write.table(EXTRAXT_MEANS_SDEV[2:562,] , "FINAL_TABLE_MEANS_SD.txt");

EXTRAXT_MEANS_SDEV <- read.table("FINAL_TABLE_MEANS_SD.txt");

#====================

## Independent tidy data set with the average of each variable for each activity and each subject.

IND_TIDY_DATA <- data.table (aggregate(TIDY_DATA[6:566], by=list(sort(TIDY_DATA$IND_SUBJECTS, decreasing = FALSE),TIDY_DATA$ACTIVITY_TYPE), FUN=mean));
 
# Changing Label names
setnames(IND_TIDY_DATA, "Group.1", "INDIVIDUALS"); 
setnames(IND_TIDY_DATA, "Group.2", "ACTIVITY"); 

# Setting a keys
IND_TIDY_DATA <- setkey(IND_TIDY_DATA, "INDIVIDUALS","ACTIVITY");

#Write to a file
write.table(IND_TIDY_DATA , "IND_TIDY_DATA.txt");



