# Getting-and-Clear-Data.-Course-Project

To run program you must compile code and run function main(path), when path - working directory .
Working directory must have - two folders  - "train", "test"(both with three files - "X_...txt", "y_...txt", "subject_...txt"), and files "activity_labels.txt", "features.txt";
 
run_analysis.R read and concatenate test and train dataset in one data set and add column names to its. 
after that, extract variables from this dataset, which mean mean and standard deviation of observations(in this data set 33 columns mean mean and 33 columns mean standard deviation).
next, change names of columns to more descriptive.
finally, create a new tidy dataset, with the average of each variable for each activity and each subject and write to "res.txt".

main(path) - main function, which run program. path - work directory path;

readfiles(type) - read file with name ("X_"+type) in folder with name type, and add column names from file "features.txt";

concatenateTestAndTrain(train, test) - merge two data frames - train and test;

extractMeanAndStd(mydf) - extract only columns, which mean 'mean' or 'std' variable from mydf;

readSubjAndY(type) - read files with names ("y_"+type, "subject"+type) from folder type and return dataframe with two columns("y", "subject");

changeActivityNames(df) - read levels activity from file "activity_labels.txt" and replace column with name "TypeActivity" from numbers to levels.

renameDF(mydf) - rename column names to more descriptive names;

gettype(activity, subject, amountActivities) - convert pair activity-subject - to number of type(from 1 to 180);

getActivityUsingType(num, amountSubjects) - extract activity level from type

getSubjectUsingType(num, amountSubjects) - extract subject from type

fifth(mydf, amountActivities, amountSubjects, amountVariablesToMean) - give dataframe - mydf, amount of activity - amountActivities, amount of subject - amountSubjects, and amount variable to mean - amountVariablesToMean and return tidy dataframe(which contains only means for every pair(activity-subject));
