# Script for Week 2 of Get and Cleaning data course - 05/15/2018

# The sqldf package allows for execution of SQL commands on R data frames. 
# We will use the sqldf package to practice the queries we might send with the dbSendQuery command in RMySQL.

#install.packages("sqldf")
library(sqldf)


######################################################
# Exercise 2: 
print("Download the American Community Survey data and load it into an R object called acs")
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
targetpath <- "C:/Users/Pedro/Documents/Industry/R/R-Programming/datasets/acs.csv"
download.file(fileurl, targetpath)
acs <- read.csv(targetpath)

print("Which of the following commands will select only the data for the probability weights pwgtp1 with ages less than 50?")
sqldf("select pwgtp1 from acs where AGEP < 50")


######################################################
# Exercise 3
print("Using the same data frame you created in the previous problem, what is the equivalent function to unique(acs$AGEP)")
sqldf("select distinct AGEP from acs")


######################################################
# Exercise 4
print("How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page: 
      http://biostat.jhsph.edu/~jleek/contact.html")

fileurl2 <- "http://biostat.jhsph.edu/~jleek/contact.html"

# Open connection, store text in environment then close connection
con <- url(fileurl2)
htmlText <- readLines(con)
close(con)

# Now to answer the question:
nchar(htmlText[10])
nchar(htmlText[20])
nchar(htmlText[30])
nchar(htmlText[100])


######################################################
# Exercise 5 
print("Read this data set into R and report the sum of the numbers in the fourth of the nine columns.")
# (Hint this is a fixed width file format)
#Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for

# Because it's fixed-width, we use read.fwf
x <- read.fwf(
        file=url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"),
        skip=4,
        widths=c(12, 7, 4, 9, 4, 9, 4, 9, 4))

sum(x[,4])
