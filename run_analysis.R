##Project

#To read data and save
x_test <- read.table(file="C:/Users/jhernandezjorge04/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", header = FALSE, sep="")
y_test <- read.table(file="C:/Users/jhernandezjorge04/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", header = FALSE, sep="")
x_train <- read.table(file="C:/Users/jhernandezjorge04/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", header = FALSE, sep="")
y_train <- read.table(file="C:/Users/jhernandezjorge04/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", header = FALSE, sep="")
subject_train <- read.table("C:/Users/jhernandezjorge04/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("C:/Users/jhernandezjorge04/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")


#To read and save labels
etiquetas <- read.table(file="C:/Users/jhernandezjorge04/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/features.txt", header = FALSE, sep="")
actividad_etiqueta <- read.table("C:/Users/jhernandezjorge04/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")


#To change column names of data
colnames(x_train) <- etiquetas$V2
colnames(y_train) <- "actividadId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- etiquetas$V2
colnames(y_test) <- "actividadId"
colnames(subject_test) <- "subjectId"
colnames(actividad_etiqueta) <- c('actividadId','actividadTipo')


#To merge x's and merge and y's
x<-cbind(y_train, subject_train, x_train)
y<-cbind(y_test, subject_test, x_test)
datos <- rbind(x, y)
colNames <- colnames(datos)


#Identify column names in the data frame
momentos_uno_dos <- (grepl("actividadId" , colNames) | 
                 grepl("subjectId" , colNames) | 
                 grepl("mean.." , colNames) | 
                 grepl("std.." , colNames) 
                 )


#To create another table with column names
datos_Std <- datos[ , momentos_uno_dos == TRUE]


#To join activity labels and activity ID´s
nombre_actividad <- merge(datos_Std, actividad_etiqueta,
                              by='actividadId',
                              all.x=TRUE)


#To get mean and standard deviation for each variable
tidy_dat <- aggregate(. ~subjectId + actividadId, nombre_actividad, mean)
tidy_dat <- tidy_dat[order(tidy_dat$subjectId, tidy_dat$actividadId),]


write.table(tidy_dat,"C:/Users/jhernandezjorge04/Downloads/data.txt" , sep="\t", row.name =FALSE)
