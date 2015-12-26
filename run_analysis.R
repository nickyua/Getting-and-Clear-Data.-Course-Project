readfiles <- function(type)
{
  filename1 <- paste("X_",type,".txt", sep="");
  file1 <- read.table(filename1, sep = "", header = FALSE);
  filename4 <- "features.txt";
  file4 <- read.table(filename4);
  
  names <-make.names(file4$V2);
  colnames(file1) <- names;
  
  return (file1);
}

concatenateTestAndTrain <- function(train, test)
{
  newdf <- train;
  newdf <- rbind(test);
  
  return (newdf);
}

extractMeanAndStd <- function(mydf)
{
  if (is.null(mydf)) return (NULL);
  
  newdf<- mydf[,grepl("mean", names(mydf))];
  newdf <- cbind(newdf, mydf[,grepl("std", names(mydf))])
  newdf <- newdf[,-grep("meanFreq", names(newdf))];
  newdf["TypeActivity"] <- mydf["y"];
  newdf["Subject"] <- mydf["subject"];
  
  return (newdf);
}

readSubjAndY <- function(type)
{
  filename1 <- paste("y_",type, ".txt", sep="");
  filename2 <- paste("subject_",type, ".txt", sep="");
  
  file1 <- read.table(filename1);
  file2 <- read.table(filename2);
  
  nm <- c("y", "subject");
  file1 <- cbind(file1, file2);
  names(file1) <- nm;
  
  return (file1);
}

changeActivityNames <- function(df)
{
  activites <- read.table("activity_labels.txt");
  df$TypeActivity <- factor(df$TypeActivity, levels = activites$V1, labels = activites$V2);
  return (df);
}

renameDF <- function(mydf)
{
  nm <- names(mydf);
  newnames <- gsub("^t", "Time", nm);
  newnames <- gsub("^f", "Frequency", newnames);
  
  newnames <- gsub(".mean()", "Mean", newnames);
  newnames <- gsub(".std()", "StandardDeviation", newnames);
  
  newnames <- gsub("Acc", "Accelometer", newnames);
  newnames <- gsub("Gyro", "Gyroscope", newnames);
  
  newnames <- gsub("Mag", "Magnitude", newnames);

  newnames <- gsub("\\.", "", newnames);
  
  names(mydf) <- newnames;
  return (mydf);
}

gettype <- function(activity, subject, amountActivities)
{
  return (as.numeric(activity)+ (subject - 1) * amountActivities);
}

getActivityUsingType <- function(num, amountSubjects)
{
  activites <- read.table("activity_labels.txt");
  
  return (activites$V2[(num-1) / amountSubjects+1]);
}

getSubjectUsingType <- function(num, amountSubjects)
{
  if (num - as.integer(num/ amountSubjects) * amountSubjects == 0)
    return (amountSubjects);
  return (num - as.integer(num/ amountSubjects) * amountSubjects);
}

fifth <- function(mydf, amountActivities, amountSubjects, amountVariablesToMean)
{
  len <- length(mydf)
  mydf['type'] <- mapply(gettype, mydf$TypeActivity, mydf$Subject, amountActivities);
  resmean <- as.data.frame(matrix(ncol = 0, nrow = 180));
  for (i in 1:amountVariablesToMean)
  {
    variable <- colnames(mydf)[i];

    res <- tapply(mydf[,i], list(Type=mydf$type), mean);
    resmean[variable] <- res;
   
  }    
  position <- 1:(amountActivities*amountSubjects);
  
  resmean['TypeActivity'] <- mapply(getActivityUsingType, position, amountSubjects);
  resmean['Subject'] <- mapply(getSubjectUsingType, position, amountSubjects);
  return (resmean); 
}

main<-function(path, amountTypesActivity = 6, amountSubjects = 30)
{
  setwd(path);
  train <- readfiles("train");
  test <- readfiles("test");
  allsets <- concatenateTestAndTrain(train, test);
  newtrain <- extractMeanAndStd(allset);
  amountVariablesToMean <- dim(newtrain)[2] - 2;
  newres <- changeActivityNames(newtrain);
  newnames <- renameDF(newres);
  res <- fifth(newnames, amountTypesActivity, amountSubjects, amountVariablesToMean); 
  write.table(res, "res.txt", row.names = FALSE)
}
