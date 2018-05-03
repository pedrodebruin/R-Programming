
# This file reads some ACS data using a data.table

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"

if(!file.exists("./data/ACS.csv"))  {
        download.file(fileUrl,"./data/ACS.csv")
}
#doc <- read.csv(datapath)

datapath <- "./data/ACS.csv"

DT <- fread(fileUrl)
DT <- na.omit(DT) # this wasn't in the instructions but without it rowMeans below complains

function1 <- function(DT){ 
        tapply(DT$pwgtp15,DT$SEX,mean) 
}

function2 <- function(DT){ 
        sapply(split(DT$pwgtp15,DT$SEX),mean) 
}

function3 <- function(DT){ 
        mean(DT[DT$SEX==1,]$pwgtp15); 
        mean(DT[DT$SEX==2,]$pwgtp15) 
}

function4 <- function(DT){ 
        rowMeans(DT)[DT$SEX==1]; 
        rowMeans(DT)[DT$SEX==2] 
}

function5 <- function(DT){ 
        mean(DT$pwgtp15,by=DT$SEX) 
}

function6 <- function(DT) {
        DT[,mean(pwgtp15),by=SEX] 
}

ptm <- proc.time()
function1(DT)
ptm2 <- proc.time()
time1 <- ptm2-ptm

ptm <- proc.time()
function2(DT)
ptm2 <- proc.time()
time2 <- ptm2-ptm

ptm <- proc.time()
function3(DT)
ptm2 <- proc.time()
time3 <- ptm2-ptm

ptm <- proc.time()
function4(DT)
ptm2 <- proc.time()
time4 <- ptm2-ptm

ptm <- proc.time()
function5(DT)
ptm2 <- proc.time()
time5 <- ptm2-ptm

ptm <- proc.time()
function6(DT)
ptm2 <- proc.time()
time6 <- ptm2-ptm


# Using system.time seems to give poor precision, almost all give 0 elapsed time
#system.time (time2 <- function2(DT))
#system.time (time3 <- function3(DT))
#system.time (time4 <- function4(DT))
#system.time (time5 <- function5(DT))
#system.time (time6 <- function6(DT))
