CodeBook for the tidy dataset
Data source

This dataset is derived from the "Human Activity Recognition Using Smartphones Data Set" which was originally made avaiable here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Feature Selection

I refer you to the README and features.txt files in the original dataset to learn more about the feature selection for this dataset. And there you will find the follow description:

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

The reasoning behind my selection of features is that the assignment explicitly states "Extracts only the measurements on the mean and standard deviation for each measurement." To be complete, I included all variables having to do with mean or standard deviation.

In short, for this derived dataset, these signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag
The set of variables that were estimated (and kept for this assignment) from these signals are:

mean(): Mean value
std(): Standard deviation
Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean
Other estimates have been removed for the purpose of this excercise.

Following variables are included in the final Tidy Data set
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


Note: features are normalized and bounded within [-1,1].

The resulting variable names are of the following form: tbodyaccmeanx, which means the mean value of tBodyAcc-XYZ.