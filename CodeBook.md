##CODE BOOK INTRODUCTION


THIS IS FOR SPECIAL INSTRUCTIONS
## About the data set
Using data set from Human Activity Recognition Using Smartphones Dataset by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.

Link:
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## License
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

## Digging through the Data

### 1.)  Looking through the files
Upon closer inspection for the files,  Both Train and Test files are not readable and it seems it had been encrypted.



e.g. (From y_train.txt)
ਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵ਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵ਴਴਴਴਴਴਴਴਴਴਴ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼਴਴਴਴਴਴਴਴਴਴਴਴ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵ਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਲਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵਵ਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴਴ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼ਸ਼਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱਱ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲ਼ਲਲ

Based on this, there isnt any use as of the moment for these data files.

### 2.)  Processing the Files

In order to see through the Garbles data,  I have used R to read the data into a data table, after which is written back to a physical file. ## note to self: put link to r_analysis.r  for loading instructions to R

These are the files needing to be passed.

 
<dl>
  <dt>Train:</dt>
  <dd><p>subject_train.txt</p>
      <p>X_train.txt</p>
      <p>y_train.txt</p></dd>

  <dt>Test:</dt>
  <dd><p>subject_test.txt</p>
      <p>X_test.txt</p>
      <p>y_test.txt</p></dd>


<p> </p>
<p>This is what data looks like (y_train.txt) after it was passed through R.</p>

<p>"V1"</p>
<p>"1" 5</p>
<p>"2" 5</p>
<p>"3" 5</p>
<p>"4" 5</p>
<p>"5" 5</p>
</dl>


## 3.)  Investigate

After the data had been processed, the data is meaningful.  It is now time to Identify what kind of data are in those files.
Lets start.
## TRAIN FILES

### subject_train.txt
<p>How many rows?</p>
<p>nrow(train_subject)</p>
<p>7352</p>


<p>List the unique values?</p>
<p>unique(train_subject[,1])</p>
<p>1  3  5  6  7  8 11 14 15 16 17 19 21 22 23 25 26 27 28 29 30</p>


<p>How many unique values are there?</p>
<p>length(unique(train_subject[,1]))</p>
<p>21</p>


<p>Note:</p>
<p>This file subject_train.txt Holds the information about the Subjects. </p>
<p>Based on this there are 21 individual subjects, and they are spread through the 7352.</p>
TRAIN:

|INDIVIDUALS|RECORD RANGE|
|:--:|:---------:|
| 1 |  1 - 347 | 
| 2 |  NULL  | 
| 3 |  348 - 688 | 
| 4 |  NULL  | 
| 5 |  689 - 990 | 
| 6 |  991 - 1315 | 
| 7 |  1316 - 1623 | 
| 8 |  1624 - 1904 | 
| 9 |  NULL  | 
| 10 |  NULL  | 
| 11 | 1905 - 2220 | 
| 12 |  NULL  | 
| 13 |  NULL  | 
| 14 | 2221 - 2543 | 
| 15 | 2544 - 2871 | 
| 16 | 2872 - 3237 | 
| 17 | 3238 - 3605 | 
| 18 |  NULL  | 
| 19 | 3606 - 3965 | 
| 20 |  NULL  | 
| 21 | 3966 - 4373 | 
| 22 | 4374 - 4694 | 
| 23 | 4695 - 5066 | 
| 24 |  NULL  | 
| 25 | 5067 - 5475 | 
| 26 | 5476 - 5867 | 
| 27 | 5868 - 6243 | 
| 28 | 6244 - 6625 | 
| 29 | 6626 - 6969 | 
| 30 | 6970 - 7352 | 

<p> </p>
<p>The Attributes are not labled.</p>
 <p>  </p>
### X_train.txt
<p>How many rows  are there?</p>
<p> nrow(train_x)</p>
<p> 7352</p>

<p>How many columns are there?</p>
<p> ncol(train_x)</p>
<p> 561</p>

<p>Lets Look at this data</P>
<p>train_x[c(1:5), c(1:3, 559:561)]</p>

| X | V1 |  V2 | V3 | ... | V559 | V560 | V561 | 
|----------|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|
| 1 | 0.2885845 | -0.02029417 | -0.1329051 |... |  -0.8412468 | 0.1799406 | -0.05862692 | 
| 2 | 0.2784188 | -0.01641057 | -0.1235202 |... |  -0.8447876 | 0.1802889 | -0.05431672 | 
| 3 | 0.2796531 | -0.01946716 | -0.1134617 |... |  -0.8489335 | 0.1806373 | -0.04911782 | 
| 4 | 0.2791739 | -0.02620065 | -0.1232826 |... |  -0.8486494 | 0.1819348 | -0.04766318 | 
| 5 | 0.2766288 | -0.01656965 | -0.1153619 |... |  -0.8478653 | 0.1851512 | -0.04389225 | 

<p>Note:</p>
<p>Data from X_train.txt Has 7352 records and 561 attributes.</p>
<p>Looks like this are the Measurements taken from the 21 individual subjects</p>
<p>The Attributes are not labled.</p>

<p>  </p>
### y_train.txt
<p>How many rows  are there?</p>
<p> nrow(train_y)</p>
<p> 7352</p>

<p>  </p> 
<p>How many columns are there?</p>
<p> ncol(train_y)</p>
<p> 1</p>

<p>  </p>
<p>How many unique values are there?</p>
<p> unique(train_y[,1])</p>
<p> 5 4 6 1 3 2</p>
<p>  </p>

<p>Note:</p>
<p>Data from y_train.txt has 7352 records and 1 attribute.</p>
<p>Data has small number of unique values.</p>
<p>The Attributes are not labled.</p>
<p>This can be related to the 21 individual subjects for their activity type</p>
<p>  </p>
### activity_labels.txt
<p>How many rows  are there?</p>
<p>nrow(activity_labels)</p>
<p>6</p>
<p>  </p>
<p>ncol(activity_labels)</p>
<p>2</p>
<p>  </p>
<p>Looking at the data set</p>
<p>activity_labels</p>
| Code | Activity Label |
|----------|:-------------:|
| 1 | WALKING |
| 2 | WALKING_UPSTAIRS |
| 3 | WALKING_DOWNSTAIRS |
| 4 | SITTING |
| 5 | STANDING |
| 6 | LAYING |
<p>  </p>
<p>Note:</p>
<p>Data from activity_labels.txt has a very small set of records of 6 and 2 attributes.</p>
<p>Looks like this might be a referenced value for the y_train.txt, since the unique values from y_train are 1,2,3,4,5, and 6.</p>
<p>  </p>

### features.txt
<p> Based on the instructions from features_info.txt, "The complete list of variables of each feature vector" can be found in features.txt.  Loaded this as well.</p> 
<p>  </p>
<p>How many rows  are there?</p>
<p>nrow(features_names)</p>
<p>561</p>
<p>  </p>
<p>ncol(features_names)</p>
<p>2</p>
<p>  </p>
<p>Looking at the data set</p>
<p>feature_names[c(1:3, 559:561),]</p>

| V1 | V2 | 
|----------|:-------------|
| 1 | tBodyAcc-mean()-X | 
| 2 | tBodyAcc-mean()-Y | 
| 3 | tBodyAcc-mean()-Z | 
| … | … | 
| 559 | angle(X,gravityMean) | 
| 560 | angle(Y,gravityMean) | 
| 561 | angle(Z,gravityMean) | 
<p>  </p>
<p>Note:</p>
<p>Data from features.txt has set of records of 561 and 2 attributes.</p>
<p>
Looks like this are the lables for X_train.txt, since attribute count from X_train is 561 as well</p>
<p>  
</p>



-----------------------------------------------------------------------------------------------------------------------------------

## TEST FILES

### subject_test.txt
<p>How many rows?</p>
<p>nrow(test_subject)</p>
<p>2947</p>


<p>List the unique values?</p>
<p>unique(test_subject[,1])</p>
<p>2  4  9 10 12 13 18 20 24</p>


<p>How many unique values are there?</p>
<p>length(unique(test_subject[,1]))</p>
<p>9</p>


<p>Note:</p>
<p>This file subject_test.txt Holds the information about the Subjects. </p>
<p>Based on this there are 9 individual subjects, and they are spread through the 2947.</p>

Test:

|INDIVIDUALS|RECORD RANGE|
|:--:|:---------:|
| 1 |  NULL | 
| 2 |  1 - 302  | 
| 3 |  NULL |
| 4 |  303 - 619  | 
| 5 |  NULL | 
| 6 |  NULL |
| 7 |  NULL |
| 8 |  NULL |
| 9 |  620 - 907  | 
| 10 |  908 - 1201  | 
| 11 |  NULL |
| 12 |  1202 - 1521  | 
| 13 |  1522 - 1848  | 
| 14 |  NULL |
| 15 |  NULL |
| 16 |  NULL | 
| 17 |  NULL | 
| 18 |  1849 - 2212  | 
| 19 |  NULL | 
| 20 |  2213 - 2566  | 
| 21 |  NULL | 
| 22 |  NULL | 
| 23 |  NULL | 
| 24 |  2567 - 2947 | 
| 25 |  NULL | 
| 26 |  NULL |
| 27 |  NULL | 
| 28 |  NULL | 
| 29 |  NULL |
| 30 |  NULL |

<p> </p>
<p>The Attributes are not labled.</p>
 <p>  </p>
 
 
 
 
### X_test.txt
<p>How many rows  are there?</p>
<p> nrow(test_x)</p>
<p> 2947</p>

<p>How many columns are there?</p>
<p> ncol(test_x)</p>
<p> 561</p>

<p>Lets Look at this data, TEST X</P>
<p>test_x[c(1:5), c(1:3, 559:561)]</p>

| X | V1 |  V2 | V3 | ... | V559 | V560 | V561 | 
|----------|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|
| 1 | 0.2571778 | -0.02328523 | -0.01465376 |... | -0.7200093 | 0.2768010 | -0.05797830 | 
| 2 | 0.2860267 | -0.01316336 | -0.11908252 |... | -0.6980908 | 0.2813429 | -0.08389801 | 
| 3 | 0.2754848 | -0.02605042 | -0.11815167 |... | -0.7027715 | 0.2800830 | -0.07934620 | 
| 4 | 0.2702982 | -0.03261387 | -0.11752018 |... | -0.6989538 | 0.2841138 | -0.07710800 | 
| 5 | 0.2748330 | -0.02784779 | -0.12952716 |... | -0.6922450 | 0.2907220 | -0.07385681 | 


<p>Note:</p>
<p>Data from X_test.txt Has 2947 records and 561 attributes.</p>
<p>Looks like this are the Measurements taken from the 21 individual subjects</p>
<p>The Attributes are not labled.</p>

<p>  </p>
### y_test.txt
<p>How many rows  are there?</p>
<p> nrow(test_y)</p>
<p> 2947</p>

<p>  </p> 
<p>How many columns are there?</p>
<p> ncol(test_y)</p>
<p> 1</p>

<p>  </p>
<p>How many unique values are there?</p>
<p> unique(test_y[,1])</p>
<p> 5 4 6 1 3 2</p>
<p>  </p>

<p>Note:</p>
<p>Data from y_test.txt has 2947 records and 1 attribute.</p>
<p>Data has small number of unique values.</p>
<p>The Attributes are not labled.</p>
<p>This can be related to the 9 individual subjects for their activity type</p>
<p>  </p>

## Summary
<p>  </p>
<p>Now that we have seen the data, combining there data sets produce 30 sets of individual producing the complete data set. 
</p>
<p>  </p>

<p>Train + Test</p>
|INDIVIDUALS|RECORD RANGE|SOURCE|
|:--:|:---------:|:---------|
| 1 |  1 - 347 | TRAIN |
| 2 |  1 - 302  | TEST |
| 3 |  348 - 688 | TRAIN |
| 4 |  303 - 619  | TEST |
| 5 |  689 - 990 | TRAIN |
| 6 |  991 - 1315 | TRAIN |
| 7 |  1316 - 1623 | TRAIN |
| 8 |  1624 - 1904 | TRAIN |
| 9 |  620 - 907  | TEST |
| 10 |  908 - 1201  | TEST |
| 11 | 1905 - 2220 | TRAIN |
| 12 |  1202 - 1521  | TEST |
| 13 |  1522 - 1848  | TEST |
| 14 | 2221 - 2543 | TRAIN |
| 15 | 2544 - 2871 | TRAIN |
| 16 | 2872 - 3237 | TRAIN |
| 17 | 3238 - 3605 | TRAIN |
| 18 |  1849 - 2212  | TEST |
| 19 | 3606 - 3965 | TRAIN |
| 20 |  2213 - 2566  | TEST |
| 21 | 3966 - 4373 | TRAIN |
| 22 | 4374 - 4694 | TRAIN |
| 23 | 4695 - 5066 | TRAIN |
| 24 |  2567 - 2947 | TEST |
| 25 | 5067 - 5475 | TRAIN |
| 26 | 5476 - 5867 | TRAIN |
| 27 | 5868 - 6243 | TRAIN |
| 28 | 6244 - 6625 | TRAIN |
| 29 | 6626 - 6969 | TRAIN |
| 30 | 6970 - 7352 | TRAIN |
<p>  </p>
<p> Important Information</p>
<p>X - Contains the actual measurements of an individual</p>
<p>Y - Contains the Activity of an indiviual</p>
<p>Subjects - Are the Actual Individuals in this Data Sets</p>
<p>Activity Labels - Holds the code and description of each Activity types</p>
<p>Features - Holds the column description for each Measurements</p>

<p>  </p>
<p>  </p>
<p>  </p>
##  RUN ANALYSIS CODE
<p>Please go to the link below, this is the part where we do the Analysis part.  Also see run_analysis.r</p>
[https://github.com/RXCORE/GET-N-CLEAN-DATA/blob/master/REPO](https://github.com/RXCORE/GET-N-CLEAN-DATA/blob/master/REPO) 



