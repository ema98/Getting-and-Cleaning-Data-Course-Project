Steps for running the analysis script "run_analysis.R"
======================================================

##Step-1: Start RStudio.

##Step-2: Set the working directory. Assume we set the working directory as "C:\Temp\final" (Note: double backslash)  using the setwd command as follows.

setwd("C:\\Temp\\final")

##Step-2: Install following libraries if they are not installed yet.

tidyr

dplyr

stringr

##Step-3: Download the script "run_analysis.R" and put it under the working directory (i.e. C:\Temp\final as showed above)

##Step-4: Run the script "run_analysis.R" as follows.

source("run_analysis.R")

##Step-5: Check the result in tidy_dataset.txt at the data folder under the working directory (i.e. C:\Temp\final\data).
