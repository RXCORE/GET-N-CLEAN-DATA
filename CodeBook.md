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

In order to see through the Garbles data,  I have used R to read the data into a data table, after which is written back to a physical file. 

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



<p>Data from y_train.txt after it was passed through R.</p>

<p>"V1"</p>
<p>"1" 5</p>
<p>"2" 5</p>
<p>"3" 5</p>
<p>"4" 5</p>
<p>"5" 5</p>
</dl>


## 3.)  Investigate

After the data had been processed, It is now time to Identify what kind of data are in those files.
Lets start.

### subject_train.txt
<p>How may rows?</p>
<p>nrow(train_subject)</p>
<p>7352</p>


<p>List the unique values?</p>
<p>unique(train_subject[,1])</p>
<p>1  3  5  6  7  8 11 14 15 16 17 19 21 22 23 25 26 27 28 29 30</p>


<p>How many unique values are there?</p>
<p>length(unique(train_subject[,1]))</p>
<p>21</p>


<p>Summary:</p>
Based on this there are 21 individual subjects, and they are spread through the 7352.

TRAIN:
<ol>
<li>  1 - 347</li>
<li>   </li>
<li>  348 - 688</li>
<li>  </li>
<li>  689 - 990</li>
<li>  991 - 1315</li>
<li>  1316 - 1623</li>
<li>  1624 - 1904</li>
<li>   </li>
<li>   </li>
<li> 1905 - 2220</li>
<li>  </li>
<li>  </li>
<li> 2221 - 2543</li>
<li> 2544 - 2871</li>
<li> 2872 - 3237</li>
<li> 3238 - 3605</li>
<li>  </li>
<li> 3606 - 3965</li>
<li> </li>
<li> 3966 - 4373</li>
<li> 4374 - 4694</li>
<li> 4695 - 5066</li>
<li>  </li>
<li> 5067 - 5475</li>
<li> 5476 - 5867</li>
<li> 5868 - 6243</li>
<li> 6244 - 6625</li>
<li> 6626 - 6969</li>
<li> 6970 - 7352</li>
</ol>

 

activity_labels.txt
1 WALKING

2 WALKING_UPSTAIRS

3 WALKING_DOWNSTAIRS

4 SITTING

5 STANDING

6 LAYING

