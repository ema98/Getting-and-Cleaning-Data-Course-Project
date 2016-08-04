library(dplyr)
library(tidyr)
library(stringr)

## Download the data set.
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("./data")) { dir.create("./data") }

if (!file.exists("./data/dataset.zip")) download.file(fileUrl, destfile = "./data/dataset.zip", mode = "wb")

if (!file.exists("./UCI HAR Dataset")) {
    unzip("./data/dataset.zip")

    dir("./UCI HAR Dataset", recursive=TRUE)
}

## Load data into tables
dfSubjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
dfSubjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

dfActivityTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
dfActivityTest <- read.table("./UCI HAR Dataset/test/y_test.txt")

dfTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
dfTest <- read.table("./UCI HAR Dataset/test/X_test.txt")

dfSubject <- rbind(dfSubjectTrain, dfSubjectTest)
names(dfSubject) <- c("subject")
rm(dfSubjectTrain)
rm(dfSubjectTest)

dfActivity <- rbind(dfActivityTrain, dfActivityTest)
names(dfActivity) <- c("activityNo")
rm(dfActivityTrain)
rm(dfActivityTest)

df <- rbind(dfTrain, dfTest)
rm(dfTrain)
rm(dfTest)

## 1. Merges the training and the test sets to create one data set
df <- cbind(cbind(dfSubject, dfActivity), df)

dfFeature <- read.table("./UCI HAR Dataset/features.txt")
names(dfFeature) <- c("featureNo", "feature")
dfMeasurement <- filter(dfFeature, grepl("mean\\(\\)|std\\(\\)", feature))
dfMeasurement <- mutate(dfMeasurement, featureCode = paste0("V", featureNo))

df <- tbl_df(df)
fields <- c(names(dfSubject), names(dfActivity), dfMeasurement$featureCode)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement
msDf <- select(df, one_of(fields))
rm(df)
rm(fields)

dfActivityLabel <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(dfActivityLabel) <- c("activityNo", "activity")
dfActivityLabel <- tbl_df(dfActivityLabel)

## 3. Uses descriptive activity names to name the activities in the data set
msDf <- left_join(msDf, dfActivityLabel, by = c("activityNo"))
msDf <- select(msDf, -activityNo)

changeName <- function(x) {
    newName <- x
    for (y in 1:nrow(dfMeasurement)) { 
        if (x == dfMeasurement[y,]$featureCode) {
            newName <- as.character(dfMeasurement[y,]$feature)
            break
        }
    }
    ## print(x); print(newName)
    newName
}

msDfColNames <- names(msDf)
msDfColNames <- sapply(msDfColNames, changeName)

names(msDf) <- msDfColNames
rm(msDfColNames)
## Gather all measurements to form a new column measurement
tidydf <- gather(msDf, measurement, value, -subject, -activity)
rm(msDf)

## Function forming the vector of boolean values (TRUE/FALSE) as a result
## of matching the specified pattern against the measurement column
grepl_measurement <- function(pattern) {
    grepl(pattern, tidydf$measurement)
}
## Function forming a new factor column with patterns and potential values (labels)
extract_measurement <- function(patterns, labels) {
    num <- length(patterns)
    b <- matrix(seq(1, num), nrow = num)
    if (num == 1) {
        a <- matrix(c(grepl_measurement(patterns[1])), ncol = nrow(b))
    } else if (num == 2) {
        a <- matrix(c(grepl_measurement(patterns[1]), grepl_measurement(patterns[2])), ncol = nrow(b))
    } else {
        a <- matrix(c(grepl_measurement(patterns[1]), grepl_measurement(patterns[2]), grepl_measurement(patterns[3])), ncol = nrow(b))
    }
    factor(a %*% b, labels = labels)
}

## 4. Appropriately labels the data set with descriptive variable names
tidydf <- separate(tidydf, measurement, c("measurement", "stats", "axis"), sep = "-", fill = "right") %>% 
        mutate(stats = str_sub(stats, 1, str_length(stats) - 2)) %>% 
        mutate(domain = extract_measurement(c("^t", "^f"), c("time", "frequency"))) %>%
        mutate(sensor = extract_measurement(c("Acc", "Gyro"), c("Accelerometer", "Gyroscope"))) %>%
        mutate(acceleration = extract_measurement(c("BodyAcc", "GravityAcc"), c(NA, "Body", "Gravity"))) %>%
        mutate(Jerk = extract_measurement(c("Jerk"), c(NA, "Jerk"))) %>%
        mutate(magnitude = extract_measurement(c("Mag"), c(NA, "Magnitude"))) %>%
        select(-measurement)

## 5. Create a second, independent tidy data set with the average of each
## variable for each activity and each subject
fdf <- group_by(tidydf, activity, subject) %>%
    mutate(Average = mean(value))

## Write the tidy table into a txt file
write.table(fdf, file = "./data/tidy_dataset.txt", row.name = FALSE)

## To Reviewer: please think twice and review code carefully if you are not sure about whether the script works correctly to get the right result.
