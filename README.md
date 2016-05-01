"ToSubmit.R" --> Is the R sctipt to be executed.

Answers:


1. Merges the training and the test sets to create one data set.

Refer line number : 53 (datatable <- cbind(allSubjAct, datatable))

2. Extracts only the measurements on the mean and standard deviation for each measurement.

Refer line number : 58 (datatable<- subset(datatable,select=featuresMeanStd) )

3. Uses descriptive activity names to name the activities in the data set

Refer line number : 68 ( datatable<- tbl_df(arrange(dataAggr,subject,activityName)))

4. Appropriately labels the data set with descriptive variable names.

Refer line number : 71 to 78


5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Refer line number : 81 (write.table(datatable, "OutputData.txt", row.name=FALSE))