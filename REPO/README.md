## REPO Contents
<p> Means and Standard Deviation per Measurements</p>
<p> Preview</p>
[https://github.com/RXCORE/GET-N-CLEAN-DATA/blob/master/REPO/FINAL_MEANS_AND_SD.md](https://github.com/RXCORE/GET-N-CLEAN-DATA/blob/master/REPO/FINAL_MEANS_AND_SD.md)

<p>The File Outputs:</p>
[https://github.com/RXCORE/GET-N-CLEAN-DATA/blob/master/REPO/FINAL_TABLE_MEANS_SD.txt](https://github.com/RXCORE/GET-N-CLEAN-DATA/blob/master/REPO/FINAL_TABLE_MEANS_SD.txt)

<p> Means per Individual Activity</p>
<p> Preview</p>
[https://github.com/RXCORE/GET-N-CLEAN-DATA/blob/master/REPO/IND_TIDY_DATA.md](https://github.com/RXCORE/GET-N-CLEAN-DATA/blob/master/REPO/IND_TIDY_DATA.md)

<p>The File Outputs:</p>
[https://raw.githubusercontent.com/RXCORE/GET-N-CLEAN-DATA/master/REPO/IND_TIDY_DATA.txt](https://raw.githubusercontent.com/RXCORE/GET-N-CLEAN-DATA/master/REPO/IND_TIDY_DATA.txt)




## Run Analysis Code
[https://github.com/RXCORE/GET-N-CLEAN-DATA/blob/master/REPO/run_analysis.R](https://github.com/RXCORE/GET-N-CLEAN-DATA/blob/master/REPO/run_analysis.R)

### Labeling the columns

###  Adding Labels to Activity Label with Code and Activity type
setnames(activity_labels, c("V1", "V2"),c("CODE", "ACTIVITY_TYPE"));

###  Naming Train/Test Subject as Individual Subjects
setnames(train_subject , "V1", "IND_SUBJECTS");
setnames(test_subject , "V1", "IND_SUBJECTS");

###  Adding Labels y train\test
setnames(train_y , "V1", "CODE");
setnames(test_y , "V1", "CODE");

###  Converts feature_names(factor vector) to a character vector
conv_featname <- paste( feature_names[,2] , sep="");

###  Applying the vector names(conv_featname) to X train\test
setnames(train_x, 1:561, conv_featname);
setnames(test_x, 1:561, conv_featname);


###  Making vectors to a Data Table
activity_labels <- data.table(activity_labels);


### Adding Keys to Data table for activity, train and test y
activity_labels <- setkey(activity_labels ,"CODE");


### Making the Tidy data set for train
###  Make a list from 1 to 7352
ROWLIST <- list(ROWNUM = 1:7352 );

### Column bind the row list, Train Individual subjects,
###  and the Activity of the individual
stage1 <- cbind( ROWLIST, train_subject, train_y) ;

###  Convert to a Data Table
stage1 <- data.table(stage1);

###  Setting keys to CODE
stage1 <- setkey(stage1, "CODE");

###  Merge stage 1 joining Activity lables via CODE.  This is to get the description of the type of activity.
stage2 <- merge (stage1 , activity_labels);

###  Setting keys to ROWNUM
stage2 <- setkey(stage2 , "ROWNUM") ;

###  Adding a column that describes where the data set came from. Tagging as TRAIN.
stage3 <- cbind(stage2, SCR=rep("TRAIN", 7352));

###  Adding the Measurements from Train x
stage4 <- cbind(stage3 , train_x) ;

###  Writing this to a file. to remove the behavior of a data table.
write.table(stage4 , "STAGING4.txt");

###  Loading it in memory as TIDY_TRAIN
TIDY_TRAIN <- read.table("STAGING4.txt");

### head(TIDY_TRAIN[, c(2:566)]); query to check

 
###  Making the Tidy data set for test
###  Make a list from 1 to 2947
ROWLIST <- list(ROWNUM = 1:2947 );

###  Column bind the row list, Train Individual subjects,
###  and the Activity of the individual
stage1test <- cbind( ROWLIST, test_subject, test_y) ;

###  Convert to a Data Table
stage1test <- data.table(stage1test);

###  Setting keys to CODE
stage1test <- setkey(stage1test, "CODE");

###  Merge stage 1 test joining Activity lables via CODE. This is to get the description of the type of activity.
stage2test <- merge (stage1test , activity_labels);

###  Setting keys to ROWNUM
stage2test <- setkey(stage2test , "ROWNUM") ;

###  Adding a column that describes where the data set came from. Tagging as TRAIN.
stage3test <- cbind(stage2test, SCR=rep("TEST", 2947));

###  Adding the Measurements from Test x
stage4test <- cbind(stage3test , test_x) ;

###  Writing this to a file. to remove the behavior of a data table.
write.table(stage4test , "STAGING4TEST.txt");

###  Loading it in memory as TIDY_TEST
TIDY_TEST <- read.table("STAGING4TEST.txt");

### head(TIDY_TEST[, c(5:566)]); query to check



# run_analysis.R
### Merge Data of Train and Test
TIDY_DATA <- rbind(TIDY_TRAIN,TIDY_TEST);
###  Set Lables for Measures
setnames(TIDY_DATA, 6:566, conv_featname);
 


###  Creating Data Table

EXTRAXT_MEANS_SDEV <- data.table( x=1,y=1,z=1 );
setnames(EXTRAXT_MEANS_SDEV , "x", "MEASURES");
setnames(EXTRAXT_MEANS_SDEV , "y", "MEANS");
setnames(EXTRAXT_MEANS_SDEV , "z", "STANDARD DEVIATION");


###  Making the Means and standard deviation data sets for each measures
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV , data.table(MEASURES="tBodyAcc-mean()-X", MEANS=mean(TIDY_DATA$"tBodyAcc-mean()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-mean()-X", na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV , data.table(MEASURES="tBodyAcc-mean()-Y", MEANS=mean(TIDY_DATA$"tBodyAcc-mean()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-mean()-Y", na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV , data.table(MEASURES="tBodyAcc-mean()-Z", MEANS=mean(TIDY_DATA$"tBodyAcc-mean()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-mean()-Z", na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV , data.table(MEASURES="tBodyAcc-std()-X", MEANS=mean(TIDY_DATA$"tBodyAcc-std()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-std()-X", na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV , data.table(MEASURES="tBodyAcc-std()-Y", MEANS=mean(TIDY_DATA$"tBodyAcc-std()-Y"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-std()-Y", na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV , data.table(MEASURES="tBodyAcc-std()-Z", MEANS=mean(TIDY_DATA$"tBodyAcc-std()-Z"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-std()-Z", na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV , data.table(MEASURES="tBodyAcc-mad()-X", MEANS=mean(TIDY_DATA$"tBodyAcc-mad()-X"), "STANDARD DEVIATION"=sd(TIDY_DATA$"tBodyAcc-mad()-X", na.rm = FALSE)));
### ...... 
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV , data.table(MEASURES="angle(tBodyGyroJerkMean,gravityMean)", MEANS=mean(TIDY_DATA$"angle(tBodyGyroJerkMean,gravityMean)"), "STANDARD DEVIATION"=sd(TIDY_DATA$"angle(tBodyGyroJerkMean,gravityMean)", na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV , data.table(MEASURES="angle(X,gravityMean)", MEANS=mean(TIDY_DATA$"angle(X,gravityMean)"), "STANDARD DEVIATION"=sd(TIDY_DATA$"angle(X,gravityMean)", na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV , data.table(MEASURES="angle(Y,gravityMean)", MEANS=mean(TIDY_DATA$"angle(Y,gravityMean)"), "STANDARD DEVIATION"=sd(TIDY_DATA$"angle(Y,gravityMean)", na.rm = FALSE)));
EXTRAXT_MEANS_SDEV <- rbind( EXTRAXT_MEANS_SDEV , data.table(MEASURES="angle(Z,gravityMean)", MEANS=mean(TIDY_DATA$"angle(Z,gravityMean)"), "STANDARD DEVIATION"=sd(TIDY_DATA$"angle(Z,gravityMean)", na.rm = FALSE)));


### Write to a file
write.table(EXTRAXT_MEANS_SDEV[2:562,] , "FINAL_TABLE_MEANS_SD.txt");

EXTRAXT_MEANS_SDEV <- read.table("FINAL_TABLE_MEANS_SD.txt");



## Independent tidy data set with the average of each variable for each activity and each subject.

IND_TIDY_DATA <- data.table (aggregate(TIDY_DATA[6:566], by=list(sort(TIDY_DATA$IND_SUBJECTS, decreasing = FALSE),TIDY_DATA$ACTIVITY_TYPE), FUN=mean));
 
###  Changing Label names
setnames(IND_TIDY_DATA, "Group.1", "INDIVIDUALS");
setnames(IND_TIDY_DATA, "Group.2", "ACTIVITY");

###  Setting a keys
IND_TIDY_DATA <- setkey(IND_TIDY_DATA, "INDIVIDUALS","ACTIVITY");

### Write to a file
write.table(IND_TIDY_DATA , "IND_TIDY_DATA.txt");
