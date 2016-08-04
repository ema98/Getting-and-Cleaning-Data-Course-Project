Codebook
========
##The original dataset used for analysis

Available from:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

##Variable list and descriptions of the final tidy table
--------------------------------------------------------

Variable name    | Description
-----------------|-------------------------------------------------------------------------------------------------------------------
subject          | Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
activity         | Activity name given in activity_labels.txt of the original dataset. Its values consists of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, and LAYING.
stats            | Statistics variable: mean (mean value) or std (standard deviation).
axis             | The X, Y and Z directions (X, Y, or Z) for 3-axial signals.
value            | statistics mean value (refer to 'mean' in column 'stats') or Standard deviation (refer to 'std' in column 'stats) of signals. 
domain           | Time (Time domain signal) or Frequency (frequency domain signal).
sensor           | Sources of 3-axial signals  (Accelerometer or Gyroscope).
acceleration     | Acceleration signal (Body or Gravity).
Jerk             | Jerk signal (Jerk) or not a Jerk signal (NA).
magnitude        | The magnitude of these three-dimensional signals: Magnitude (the magnitude was calculated) or NA (the magnitude was not calculated).
Average          | Average of each variable for each activity and each subject. It is calculated as the mean of values of the variable "value" and grouped by "activity" and "subject".

## Summary of the final tidy table
    subject                    activity         stats          
 Min.   : 1.00   LAYING            :128304   Length:679734     
 1st Qu.: 9.00   SITTING           :117282   Class :character  
 Median :17.00   STANDING          :125796   Mode  :character  
 Mean   :16.15   WALKING           :113652                     
 3rd Qu.:24.00   WALKING_DOWNSTAIRS: 92796                     
 Max.   :30.00   WALKING_UPSTAIRS  :101904                     

     axis               value                domain      
 Length:679734      Min.   :-1.00000   time     :411960  
 Class :character   1st Qu.:-0.98122   frequency:267774  
 Mode  :character   Median :-0.55219                     
                    Mean   :-0.51134                     
                    3rd Qu.:-0.09971                     
                    Max.   : 1.00000                     
           sensor        acceleration      Jerk       
 Accelerometer:411960   NA     :267774   NA  :411960  
 Gyroscope    :267774   Body   :329568   Jerk:267774  
                        Gravity: 82392                
                                                      
     magnitude         Average       
 NA       :494352   Min.   :-0.7535  
 Magnitude:185382   1st Qu.:-0.7351  
                    Median :-0.7121  
                    Mean   :-0.5113  
                    3rd Qu.:-0.2818  
                    Max.   : 0.1549  
