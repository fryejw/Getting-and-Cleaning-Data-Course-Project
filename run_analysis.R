######################################################
###
### Project: Getting and Cleaning Data - Course Project
### Date: 5/12/2019
### Goal: Show ability to read data, manipulate it,
###         and export it with R.
###
#######################################################


# Since the Test and Training data are in the same format,
#   I'm going to create a function that takes either test
#   or train as an input and prepares the data.

library(dplyr)


prepare_data <- function(input){
    #Input for this function should be either "test" or "train"
    if(input != "test" & input != "train"){
        stop("Input should be 'test' or 'train'.")
    }
    #This will load in the appropriate test or train files.
    subject.data <- read.table(file = paste0("./UCI HAR Dataset/",input,"/subject_",input,".txt"), col.names = "Subject.ID")
    features <- read.table(file = paste0("./UCI HAR Dataset/features.txt"), col.names = c("Feature.ID","Feature.Name"))
    x.data <- read.table(file = paste0("./UCI HAR Dataset/",input,"/X_",input,".txt"))
    names(x.data) <- features$Feature.Name #This renames the features using the names given to us.
    y.data <- read.table(file = paste0("./UCI HAR Dataset/",input,"/Y_",input,".txt"), col.names = "Activity.Code")
    activity.names <- read.table(file = paste0("./UCI HAR Dataset/activity_labels.txt"), col.names = c("Activity.Code","Activity.Name"))
    y.data <- left_join(x = y.data, y  = activity.names) #This renames the activities using the names given to us.
    output <- cbind(subject.data,y.data,x.data) #Here we combine the subject, activity, and feature data all together.
    
    #This is a bit of an abuse of regex and R stuff. I'll try my best to explain what's going on.
    #   * which(grepl(x = colnames(output),pattern = "(std()|-mean()|Subject|Activity)"))
    #       This line is creating a vector of all the indices of the columns in our dataset that have any of the following in their name:
    #           1. std()
    #           2. -mean()
    #           3. Subject
    #           4. Activity
    #   * [!(which(grepl(x = colnames(output),pattern = "(std()|-mean()|Subject|Activity)")) %in% which(grepl(x = colnames(output), pattern = "Freq()")))]]
    #       This line is creating a logical vector which will be used to subset the above vector.
    #       The entire purpose of this part is to remove anything that has meanFreq() in the name.
    #   * Finally we use the subsetted first vector to pull out what columns we want from the dataset.
    output <- output[,which(grepl(x = colnames(output),pattern = "(std()|-mean()|Subject|Activity)"))[!(which(grepl(x = colnames(output),pattern = "(std()|-mean()|Subject|Activity)")) %in% which(grepl(x = colnames(output), pattern = "Freq()")))]]
    new.names <- as.character()
    #This is another regex moment. Instead of manually going through and renaming each column, I created this loop which
    #   builds up an understandable feature name based on the slightly more cryptic name given to us.
    for(name in names(output)){
        temp.name <- as.character()
        if(grepl(x = name, pattern = "Subject|Activity")){
            temp.name <- paste0(name)
        }
        if(grepl(x = name, pattern = "-mean()")){
            temp.name <- paste0("Mean",temp.name)
        }
        if(grepl(x = name, pattern = "-std()")){
            temp.name <- paste0("Standard.Dev",temp.name)
        }
        if(grepl(x = name, pattern = "Gyro")){
            temp.name <- paste0(temp.name,".Gryoscope")
        }
        if(grepl(x = name, pattern = "Acc")){
            temp.name <- paste0(temp.name,".Accelerometer")
        }
        if(grepl(x = name, pattern = "^t")){
            temp.name <- paste0(temp.name,".Time")
        }
        if(grepl(x = name, pattern = "^f")){
            temp.name <- paste0(temp.name,".Frequency")
        }
        if(grepl(x = name, pattern = "Body")){
            temp.name <- paste0(temp.name,".Body")
        }
        if(grepl(x = name, pattern = "Gravity")){
            temp.name <- paste0(temp.name,".Gravity")
        }
        if(grepl(x = name, pattern = "Jerk")){
            temp.name <- paste0(temp.name,".Jerk")
        }
        if(grepl(x = name, pattern = "Mag")){
            temp.name <- paste0(temp.name,".Magnitude")
        }
        if(grepl(x = name, pattern = "(X|Y|Z)$")){
            temp.name <- paste0(temp.name,".",substr(name,nchar(name),nchar(name)))
        }
        new.names <- append(new.names,temp.name)
    }
    #Take the new names and assign them to the columns of our dataset and return it.
    colnames(output) <- new.names
    return(output)
}

#Prep the test and train data.
test_prep <- prepare_data("test")
train_prep <- prepare_data("train")

#Combine the test and train data.
combined_data <- rbind(test_prep,train_prep)


#Create the summary dataset showing the mean for each variable grouped by activity and subject.
summary_data <- combined_data %>% group_by(Subject.ID, Activity.Name) %>% summarise_at(vars(-Activity.Code),funs(mean(.)))
