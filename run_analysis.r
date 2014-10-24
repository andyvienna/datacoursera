# 1.
trainx <- read.table("train\\x_train.txt")
trainy <- read.table("train\\y_train.txt", col.names=c("aid"))
subjecttrain <- read.table("train\\subject_train.txt", col.names=c("sid"))
train <- cbind(subjecttrain,trainy,trainx)

testx <- read.table("test\\x_test.txt")
testy <- read.table("test\\y_test.txt", col.names=c("aid"))
subjecttest <- read.table("test\\subject_test.txt", col.names=c("sid"))
test <- cbind(subjecttest,testy,testx)

d <- rbind(train, test)

# 2.
features <- read.table("features.txt", col.names=c("fid","ftype"))
myfeatures <- features[grepl("mean\\(\\)", features$ftype) | grepl("std\\(\\)", features$ftype), ]
d2 <- d[,c(1,2,myfeatures$fid + 2)]

# 3.
labels <- read.table("activity_labels.txt", col.names=c("aid","alabel"))
d3 <- merge(d2,labels)

# 4.
colnames(d3)[3:68] <- as.character(myfeatures$ftype)

# 5.
sumdata <- data.frame(tapply(d3[,3], d3$sid, mean))
for (i in 4:68) {
  sumdata[,i-2] <- tapply(d3[,i], d3$sid, mean)
}
colnames(sumdata) <- as.character(myfeatures$ftype)
write.table(sumdata,"output.txt",row.name=F)
