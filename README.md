# Getting and Cleaning Data Course Project
Created on 5/16/2019


##Goal:
To show ability to read in data, combine data, manipulate data, and summarize data with documentation and reproducibility.

##Data:
Smartphone data that was supplied to us for the course.

##Process:
####Read in and combine the data:
Since we have both a training and test dataset in the same format, I created a function to assist and readability and reduce copying the same code twice.
 In this function we can read in the Subject code files, the feature value files, the activity value files, the feature names, and the activity names.
 We then take the feature names, and rename the feature value columns so we know what the values are. We also join on the activity names to the activity values.
 Finally to finish this step, we merge all the datasets together.
 
####Filter and create descriptive labels:
We used regex and the which function in R to do a bulk filter to reduce the columns we have down to just the columns that contained the standard deviation and mean data.
After the filtering, we use regex again to parse the abbreviated feature names given to us to help expand them into something more descriptive.

####Summarize the data:
After the data was prepped, we combined the training and test data into a singular dataset and found the mean for each variable grouped by the subject and activity.


####Feature Names
The feature names follow a standardized naming scheme.

    * Mean or Standard.Dev - This tells you if the measure is the mean or the standard deviation.
    * Accelerometer or Gyroscope - This tells you if the measurement came from the Accelerometer or the Gyroscope
    * Time or Frequency - This tells you if it is the raw time measurement or if a Fast Fourier Transform happened on the data to get frequency measurements.
    * Body or Gravity - If the measurement was from body movement or from gravity.
    * Jerk - Jerk is the rate of change of acceleration. If this is not included then the measurement is acceleration.
    * Magnitude - The magnitude of the signal processed.
    * XYZ - Which of the 3-dimensional Euclidean directions the measurement occured.
    

