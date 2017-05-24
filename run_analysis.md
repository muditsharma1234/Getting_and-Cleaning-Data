---
title: "run_analysis"
output: html_document
---



## R Markdown

This is the markdown file to complete the course - "Cleaning and getting data". The idea of the assignment is to load the data and then clean the data to generate a tidy data set. 

Checking and installing required packages.

```r
required_packages <- c("dplyr","rebus","data.table")
install_required <- setdiff(required_packages,rownames(installed.packages()))
if(length(install_required)!=0) {install.packages(install_required)}
sapply(required_packages,library,character.only=T,quietly=T)
```

```
##       dplyr        rebus        data.table  
##  [1,] "data.table" "data.table" "data.table"
##  [2,] "markdown"   "markdown"   "markdown"  
##  [3,] "knitr"      "knitr"      "knitr"     
##  [4,] "dplyr"      "dplyr"      "dplyr"     
##  [5,] "rebus"      "rebus"      "rebus"     
##  [6,] "stats"      "stats"      "stats"     
##  [7,] "graphics"   "graphics"   "graphics"  
##  [8,] "grDevices"  "grDevices"  "grDevices" 
##  [9,] "utils"      "utils"      "utils"     
## [10,] "datasets"   "datasets"   "datasets"  
## [11,] "methods"    "methods"    "methods"   
## [12,] "base"       "base"       "base"
```
Downloading the required files 

```r
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("assignment_data.zip")){download.file(url1,dest="assignment_data.zip")}
unzip("assignment_data.zip",overwrite=T)
```
After having downloaded the files in the working directory we setup the paths to read the files in the R environment. 

```r
path_wd <- getwd()
path_files <- file.path(path_wd,"UCI HAR Dataset")
list.files(path_files,recursive=T)
```

```
##  [1] "activity_labels.txt"                         
##  [2] "features.txt"                                
##  [3] "features_info.txt"                           
##  [4] "README.txt"                                  
##  [5] "test/Inertial Signals/body_acc_x_test.txt"   
##  [6] "test/Inertial Signals/body_acc_y_test.txt"   
##  [7] "test/Inertial Signals/body_acc_z_test.txt"   
##  [8] "test/Inertial Signals/body_gyro_x_test.txt"  
##  [9] "test/Inertial Signals/body_gyro_y_test.txt"  
## [10] "test/Inertial Signals/body_gyro_z_test.txt"  
## [11] "test/Inertial Signals/total_acc_x_test.txt"  
## [12] "test/Inertial Signals/total_acc_y_test.txt"  
## [13] "test/Inertial Signals/total_acc_z_test.txt"  
## [14] "test/subject_test.txt"                       
## [15] "test/X_test.txt"                             
## [16] "test/y_test.txt"                             
## [17] "train/Inertial Signals/body_acc_x_train.txt" 
## [18] "train/Inertial Signals/body_acc_y_train.txt" 
## [19] "train/Inertial Signals/body_acc_z_train.txt" 
## [20] "train/Inertial Signals/body_gyro_x_train.txt"
## [21] "train/Inertial Signals/body_gyro_y_train.txt"
## [22] "train/Inertial Signals/body_gyro_z_train.txt"
## [23] "train/Inertial Signals/total_acc_x_train.txt"
## [24] "train/Inertial Signals/total_acc_y_train.txt"
## [25] "train/Inertial Signals/total_acc_z_train.txt"
## [26] "train/subject_train.txt"                     
## [27] "train/X_train.txt"                           
## [28] "train/y_train.txt"
```
We see there are inertial signal directory in test and train folders. We don't need these files for our analysis here and thus we will remove these files to get a clean folder for our analysis.


```r
if(file.exists(file.path(path_files,"test/Inertial Signals")) | file.exists(file.path(path_files,"train/Inertial Signals")))
{
  unlink(file.path(path_files,"test/Inertial Signals"),recursive = T)
  unlink(file.path(path_files,"train/Inertial Signals"),recursive=T)
}
list.files(path_files,recursive=T)
```

```
##  [1] "activity_labels.txt"     "features.txt"           
##  [3] "features_info.txt"       "README.txt"             
##  [5] "test/subject_test.txt"   "test/X_test.txt"        
##  [7] "test/y_test.txt"         "train/subject_train.txt"
##  [9] "train/X_train.txt"       "train/y_train.txt"
```
Now we create the required dataframes for our analysis. Each of the dataframes have to be read from the cleaned out directory. We load each of the text files using the tbl_df function of dplyr package so visualization of each of the elements becomes easier on the user screen.

```r
activity_label <- tbl_df(read.table(file.path(path_files,"activity_labels.txt"),header=F))
features <- tbl_df(read.table(file.path(path_files,"features.txt"),header=F))
Y_test <- tbl_df(read.table(file.path(path_files,"test/y_test.txt"),header=F))
Y_train <- tbl_df(read.table(file.path(path_files,"train/y_train.txt"),header=F))
X_test <- tbl_df(read.table(file.path(path_files,"test/X_test.txt"),header = F))
X_train <- tbl_df(read.table(file.path(path_files,"train/X_train.txt"),header=F))
subject_train <- tbl_df(read.table(file.path(path_files,"train/subject_train.txt"),header=F))
subject_test <- tbl_df(read.table(file.path(path_files,"test/subject_test.txt"),header=F))
```
We create a list containing the variables we create and check their dimensions to understand the possible relationships between the various variables we have created. 

```r
variable_list <- list(activity_label,features,Y_test,Y_train,X_test,X_train,subject_train,subject_test)
names(variable_list) <- c("activity_label","features","Y_test","Y_train","X_test","X_train","subject_train","subject_test")
t(sapply(variable_list,dim,USE.NAMES = T,simplify = T))
```

```
##                [,1] [,2]
## activity_label    6    2
## features        561    2
## Y_test         2947    1
## Y_train        7352    1
## X_test         2947  561
## X_train        7352  561
## subject_train  7352    1
## subject_test   2947    1
```

```r
sapply(variable_list,head,USE.NAMES=T,simplify = T)
```

```
## $activity_label
## # A tibble: 6 × 2
##      V1                 V2
##   <int>             <fctr>
## 1     1            WALKING
## 2     2   WALKING_UPSTAIRS
## 3     3 WALKING_DOWNSTAIRS
## 4     4            SITTING
## 5     5           STANDING
## 6     6             LAYING
## 
## $features
## # A tibble: 6 × 2
##      V1                V2
##   <int>            <fctr>
## 1     1 tBodyAcc-mean()-X
## 2     2 tBodyAcc-mean()-Y
## 3     3 tBodyAcc-mean()-Z
## 4     4  tBodyAcc-std()-X
## 5     5  tBodyAcc-std()-Y
## 6     6  tBodyAcc-std()-Z
## 
## $Y_test
## # A tibble: 6 × 1
##      V1
##   <int>
## 1     5
## 2     5
## 3     5
## 4     5
## 5     5
## 6     5
## 
## $Y_train
## # A tibble: 6 × 1
##      V1
##   <int>
## 1     5
## 2     5
## 3     5
## 4     5
## 5     5
## 6     5
## 
## $X_test
## # A tibble: 6 × 561
##          V1          V2          V3         V4         V5         V6
##       <dbl>       <dbl>       <dbl>      <dbl>      <dbl>      <dbl>
## 1 0.2571778 -0.02328523 -0.01465376 -0.9384040 -0.9200908 -0.6676833
## 2 0.2860267 -0.01316336 -0.11908252 -0.9754147 -0.9674579 -0.9449582
## 3 0.2754848 -0.02605042 -0.11815167 -0.9938190 -0.9699255 -0.9627480
## 4 0.2702982 -0.03261387 -0.11752018 -0.9947428 -0.9732676 -0.9670907
## 5 0.2748330 -0.02784779 -0.12952716 -0.9938525 -0.9674455 -0.9782950
## 6 0.2792199 -0.01862040 -0.11390197 -0.9944552 -0.9704169 -0.9653163
## # ... with 555 more variables: V7 <dbl>, V8 <dbl>, V9 <dbl>, V10 <dbl>,
## #   V11 <dbl>, V12 <dbl>, V13 <dbl>, V14 <dbl>, V15 <dbl>, V16 <dbl>,
## #   V17 <dbl>, V18 <dbl>, V19 <dbl>, V20 <dbl>, V21 <dbl>, V22 <dbl>,
## #   V23 <dbl>, V24 <dbl>, V25 <dbl>, V26 <dbl>, V27 <dbl>, V28 <dbl>,
## #   V29 <dbl>, V30 <dbl>, V31 <dbl>, V32 <dbl>, V33 <dbl>, V34 <dbl>,
## #   V35 <dbl>, V36 <dbl>, V37 <dbl>, V38 <dbl>, V39 <dbl>, V40 <dbl>,
## #   V41 <dbl>, V42 <dbl>, V43 <dbl>, V44 <dbl>, V45 <dbl>, V46 <dbl>,
## #   V47 <dbl>, V48 <dbl>, V49 <dbl>, V50 <dbl>, V51 <dbl>, V52 <dbl>,
## #   V53 <dbl>, V54 <dbl>, V55 <dbl>, V56 <dbl>, V57 <dbl>, V58 <dbl>,
## #   V59 <dbl>, V60 <dbl>, V61 <dbl>, V62 <dbl>, V63 <dbl>, V64 <dbl>,
## #   V65 <dbl>, V66 <dbl>, V67 <dbl>, V68 <dbl>, V69 <dbl>, V70 <dbl>,
## #   V71 <dbl>, V72 <dbl>, V73 <dbl>, V74 <dbl>, V75 <dbl>, V76 <dbl>,
## #   V77 <dbl>, V78 <dbl>, V79 <dbl>, V80 <dbl>, V81 <dbl>, V82 <dbl>,
## #   V83 <dbl>, V84 <dbl>, V85 <dbl>, V86 <dbl>, V87 <dbl>, V88 <dbl>,
## #   V89 <dbl>, V90 <dbl>, V91 <dbl>, V92 <dbl>, V93 <dbl>, V94 <dbl>,
## #   V95 <dbl>, V96 <dbl>, V97 <dbl>, V98 <dbl>, V99 <dbl>, V100 <dbl>,
## #   V101 <dbl>, V102 <dbl>, V103 <dbl>, V104 <dbl>, V105 <dbl>,
## #   V106 <dbl>, ...
## 
## $X_train
## # A tibble: 6 × 561
##          V1          V2         V3         V4         V5         V6
##       <dbl>       <dbl>      <dbl>      <dbl>      <dbl>      <dbl>
## 1 0.2885845 -0.02029417 -0.1329051 -0.9952786 -0.9831106 -0.9135264
## 2 0.2784188 -0.01641057 -0.1235202 -0.9982453 -0.9753002 -0.9603220
## 3 0.2796531 -0.01946716 -0.1134617 -0.9953796 -0.9671870 -0.9789440
## 4 0.2791739 -0.02620065 -0.1232826 -0.9960915 -0.9834027 -0.9906751
## 5 0.2766288 -0.01656965 -0.1153619 -0.9981386 -0.9808173 -0.9904816
## 6 0.2771988 -0.01009785 -0.1051373 -0.9973350 -0.9904868 -0.9954200
## # ... with 555 more variables: V7 <dbl>, V8 <dbl>, V9 <dbl>, V10 <dbl>,
## #   V11 <dbl>, V12 <dbl>, V13 <dbl>, V14 <dbl>, V15 <dbl>, V16 <dbl>,
## #   V17 <dbl>, V18 <dbl>, V19 <dbl>, V20 <dbl>, V21 <dbl>, V22 <dbl>,
## #   V23 <dbl>, V24 <dbl>, V25 <dbl>, V26 <dbl>, V27 <dbl>, V28 <dbl>,
## #   V29 <dbl>, V30 <dbl>, V31 <dbl>, V32 <dbl>, V33 <dbl>, V34 <dbl>,
## #   V35 <dbl>, V36 <dbl>, V37 <dbl>, V38 <dbl>, V39 <dbl>, V40 <dbl>,
## #   V41 <dbl>, V42 <dbl>, V43 <dbl>, V44 <dbl>, V45 <dbl>, V46 <dbl>,
## #   V47 <dbl>, V48 <dbl>, V49 <dbl>, V50 <dbl>, V51 <dbl>, V52 <dbl>,
## #   V53 <dbl>, V54 <dbl>, V55 <dbl>, V56 <dbl>, V57 <dbl>, V58 <dbl>,
## #   V59 <dbl>, V60 <dbl>, V61 <dbl>, V62 <dbl>, V63 <dbl>, V64 <dbl>,
## #   V65 <dbl>, V66 <dbl>, V67 <dbl>, V68 <dbl>, V69 <dbl>, V70 <dbl>,
## #   V71 <dbl>, V72 <dbl>, V73 <dbl>, V74 <dbl>, V75 <dbl>, V76 <dbl>,
## #   V77 <dbl>, V78 <dbl>, V79 <dbl>, V80 <dbl>, V81 <dbl>, V82 <dbl>,
## #   V83 <dbl>, V84 <dbl>, V85 <dbl>, V86 <dbl>, V87 <dbl>, V88 <dbl>,
## #   V89 <dbl>, V90 <dbl>, V91 <dbl>, V92 <dbl>, V93 <dbl>, V94 <dbl>,
## #   V95 <dbl>, V96 <dbl>, V97 <dbl>, V98 <dbl>, V99 <dbl>, V100 <dbl>,
## #   V101 <dbl>, V102 <dbl>, V103 <dbl>, V104 <dbl>, V105 <dbl>,
## #   V106 <dbl>, ...
## 
## $subject_train
## # A tibble: 6 × 1
##      V1
##   <int>
## 1     1
## 2     1
## 3     1
## 4     1
## 5     1
## 6     1
## 
## $subject_test
## # A tibble: 6 × 1
##      V1
##   <int>
## 1     2
## 2     2
## 3     2
## 4     2
## 5     2
## 6     2
```
We can see that X_train and X_test are the main datasets it has a 561 columns. 
Subject_train and Subject_test are the subjects for the experiments the number of rows in test and train are respectively equal to the number in the main datasets mentioned above. Y_train and Y_test are the activity codes which have same number of observations as in main datasets. Activity Labels are the activity code mapped to activity name. Subject Test and Subject Train are the codes of subjects who have performed these activities. Features is the list of measurment performed and the number of observations are equal to the columns in the main datasets. 
We need to perform following steps to merge and generate a tidy data set:
1. Map the columns names to the features 
2. Extract the columns/ features which are measurements on mean and standard deviations
3. Add the activity codes to the main dataset and then map the descriptive names from the activity_lables
4. Change the variable labels to generate descriptive names 
5. Finally create the summary of means and standard deviation based on subject and activitycodes

First we extract the column names from the features dataset which contains the names - mean or standard deviations. For which we use the grep function along with regex created by the rebus packages we installed.


```r
## Here we use rebus package to generate a regular expression containing mean or std
regex_mean_std <- zero_or_more(ANY_CHAR)%R%or("mean","std")%R%zero_or_more(ANY_CHAR)

## We print the regex to evaluate the value which is same as the standard regular expression I use rebus here because it becomes easier to generate the regular expression using that the format is ANY_CHAR - any character %R% means followed by or("mean","std") means either mean or std in the text %R% again is followed by then ANY_CHAR we use argument ignore.case=T so we don't have to write regex comprising of caps and small separately
regex_mean_std
```

```
## <regex> [.]*(?:mean|std)[.]*
```

```r
mean_std_cols <- grep(regex_mean_std,features$V2,ignore.case = T)
## Here we extract the mean and standard deviation features names into features_mean_std dataframe
features_mean_std <- features[mean_std_cols,]
## Replacing (,),- and , from the feature names to generate standard variable names
features_mean_std$V2 <- gsub("\\(|\\)|_","",features_mean_std$V2)
##Then we convert all the names to lower case and replace mean and std with _STD_ or _MEAN_ to highlight the variables being computed
features_mean_std$V2 <- tolower(features_mean_std$V2)
features_mean_std$V2 <- gsub("mean","MEAN",features_mean_std$V2)
features_mean_std$V2 <- gsub("std","STD",features_mean_std$V2)
##This will generate additional _ at the end of the string if mean/ std are at the end of the string thus we will remove the final _ from the names using END constant of our rebus package
features_mean_std$V2 <- gsub("_"%R%END,"",features_mean_std$V2)
## We check the value of the columns 

features_mean_std$V2
```

```
##  [1] "tbodyacc-MEAN-x"                   
##  [2] "tbodyacc-MEAN-y"                   
##  [3] "tbodyacc-MEAN-z"                   
##  [4] "tbodyacc-STD-x"                    
##  [5] "tbodyacc-STD-y"                    
##  [6] "tbodyacc-STD-z"                    
##  [7] "tgravityacc-MEAN-x"                
##  [8] "tgravityacc-MEAN-y"                
##  [9] "tgravityacc-MEAN-z"                
## [10] "tgravityacc-STD-x"                 
## [11] "tgravityacc-STD-y"                 
## [12] "tgravityacc-STD-z"                 
## [13] "tbodyaccjerk-MEAN-x"               
## [14] "tbodyaccjerk-MEAN-y"               
## [15] "tbodyaccjerk-MEAN-z"               
## [16] "tbodyaccjerk-STD-x"                
## [17] "tbodyaccjerk-STD-y"                
## [18] "tbodyaccjerk-STD-z"                
## [19] "tbodygyro-MEAN-x"                  
## [20] "tbodygyro-MEAN-y"                  
## [21] "tbodygyro-MEAN-z"                  
## [22] "tbodygyro-STD-x"                   
## [23] "tbodygyro-STD-y"                   
## [24] "tbodygyro-STD-z"                   
## [25] "tbodygyrojerk-MEAN-x"              
## [26] "tbodygyrojerk-MEAN-y"              
## [27] "tbodygyrojerk-MEAN-z"              
## [28] "tbodygyrojerk-STD-x"               
## [29] "tbodygyrojerk-STD-y"               
## [30] "tbodygyrojerk-STD-z"               
## [31] "tbodyaccmag-MEAN"                  
## [32] "tbodyaccmag-STD"                   
## [33] "tgravityaccmag-MEAN"               
## [34] "tgravityaccmag-STD"                
## [35] "tbodyaccjerkmag-MEAN"              
## [36] "tbodyaccjerkmag-STD"               
## [37] "tbodygyromag-MEAN"                 
## [38] "tbodygyromag-STD"                  
## [39] "tbodygyrojerkmag-MEAN"             
## [40] "tbodygyrojerkmag-STD"              
## [41] "fbodyacc-MEAN-x"                   
## [42] "fbodyacc-MEAN-y"                   
## [43] "fbodyacc-MEAN-z"                   
## [44] "fbodyacc-STD-x"                    
## [45] "fbodyacc-STD-y"                    
## [46] "fbodyacc-STD-z"                    
## [47] "fbodyacc-MEANfreq-x"               
## [48] "fbodyacc-MEANfreq-y"               
## [49] "fbodyacc-MEANfreq-z"               
## [50] "fbodyaccjerk-MEAN-x"               
## [51] "fbodyaccjerk-MEAN-y"               
## [52] "fbodyaccjerk-MEAN-z"               
## [53] "fbodyaccjerk-STD-x"                
## [54] "fbodyaccjerk-STD-y"                
## [55] "fbodyaccjerk-STD-z"                
## [56] "fbodyaccjerk-MEANfreq-x"           
## [57] "fbodyaccjerk-MEANfreq-y"           
## [58] "fbodyaccjerk-MEANfreq-z"           
## [59] "fbodygyro-MEAN-x"                  
## [60] "fbodygyro-MEAN-y"                  
## [61] "fbodygyro-MEAN-z"                  
## [62] "fbodygyro-STD-x"                   
## [63] "fbodygyro-STD-y"                   
## [64] "fbodygyro-STD-z"                   
## [65] "fbodygyro-MEANfreq-x"              
## [66] "fbodygyro-MEANfreq-y"              
## [67] "fbodygyro-MEANfreq-z"              
## [68] "fbodyaccmag-MEAN"                  
## [69] "fbodyaccmag-STD"                   
## [70] "fbodyaccmag-MEANfreq"              
## [71] "fbodybodyaccjerkmag-MEAN"          
## [72] "fbodybodyaccjerkmag-STD"           
## [73] "fbodybodyaccjerkmag-MEANfreq"      
## [74] "fbodybodygyromag-MEAN"             
## [75] "fbodybodygyromag-STD"              
## [76] "fbodybodygyromag-MEANfreq"         
## [77] "fbodybodygyrojerkmag-MEAN"         
## [78] "fbodybodygyrojerkmag-STD"          
## [79] "fbodybodygyrojerkmag-MEANfreq"     
## [80] "angletbodyaccMEAN,gravity"         
## [81] "angletbodyaccjerkMEAN,gravityMEAN" 
## [82] "angletbodygyroMEAN,gravityMEAN"    
## [83] "angletbodygyrojerkMEAN,gravityMEAN"
## [84] "anglex,gravityMEAN"                
## [85] "angley,gravityMEAN"                
## [86] "anglez,gravityMEAN"
```

```r
## Now that we  have clean column names from the data we can use the data. 
```
Now that we have the clean column names we can extract the same columns from our main datasets and bind them. 

```r
##Extract the columns which represent the std and mean from the data
X_test_mean_std <- X_test[,mean_std_cols]
X_train_mean_std <- X_train[,mean_std_cols]
##Check the dimensions of the created data frames 
dim(X_test_mean_std)
```

```
## [1] 2947   86
```

```r
dim(X_train_mean_std)
```

```
## [1] 7352   86
```

```r
##The dimensions of the data_frame are appropriate as we have 86 variables as filtered by us previously
names(Y_train) <- "Activity_Code"
names(Y_test) <- "Activity_Code"
names(subject_test) <- "Subject_Code"
names(subject_train) <- "Subject_Code"
names(X_test_mean_std) <- features_mean_std$V2
names(X_train_mean_std) <- features_mean_std$V2
X_test_mean_std <- tbl_df(cbind(Y_test,cbind(subject_test,X_test_mean_std)))
X_train_mean_std <- tbl_df(cbind(Y_train,cbind(subject_train,X_train_mean_std)))
dim(X_test_mean_std)
```

```
## [1] 2947   88
```

```r
dim(X_train_mean_std)
```

```
## [1] 7352   88
```
Now we merge the activity_label dataset with our datasets to generate the activity names. To do so we use a left join wherein we keep all the values of left dataset and repeat the corrosponding values in right dataset.

```r
names(activity_label) <- c("Activity_Code","Activity_Name")
X_test_joined <- tbl_df(merge(X_test_mean_std,activity_label,by.x="Activity_Code",by.y="Activity_Code",all.X=T))
X_train_joined <- tbl_df(merge(X_train_mean_std,activity_label,by.x="Activity_Code",by.y="Activity_Code",all.X=T))
## Now we can combine the Training and Test data using rbind function into a single dataframe
X_combined_joined <- as.data.frame(rbind(X_train_joined,X_test_joined))
dim(X_combined_joined)
```

```
## [1] 10299    89
```

```r
##We can see the size of the dataframe is same as the final dataframe 86 columns + 3 generated columns and 7352 + 2947 = 10299 rows - which means all the data has been combined.
```
Creation of Tidy Data frame. Here we aggregate the data using the Activity_Name and Subject_Code and generate mean for all the other variables.

```r
X_combined_joined$Activity_Name <- as.factor(X_combined_joined$Activity_Name)
X_combined_joined$Subject_Code <- as.factor(X_combined_joined$Subject_Code)
##We need to mean over the observations thus we exclude 3 columns for mean compuation - Activity_Code, Activity_Name and Subject_Code which are respectively 1st,2nd and Last columns of our joined data frame

Tidy_Data_Set <- aggregate(X_combined_joined[,3:(ncol(X_combined_joined)-1)],by=list(Activity_Name = X_combined_joined$Activity_Name,Subject_Code = X_combined_joined$Subject_Code),mean)

dim(Tidy_Data_Set)
```

```
## [1] 180  88
```

```r
write.table(Tidy_Data_Set, "tidy.txt", sep="\t")
write.csv(Tidy_Data_Set,"tidy1.csv",row.names=F)
```
Thus we have created a tidy dataset with the mean of all the observations as the final dataframe. This dataframe has been exported in a tab-deliminated text file named Tidy.txt
