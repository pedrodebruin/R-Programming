# Problem 1
# 
# The American Community Survey distributes downloadable data about United States communities. 
#
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
# and load the data into R. The code book, describing the variable names is here:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
# Apply strsplit() to split all the names of the data frame on the characters "wgtp". 
# What is the value of the 123 element of the resulting list?

fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
targetpath <- "datasets/acs_idaho_2006.csv"
if (!file.exists(targetpath)) {
        download.file(fileurl, targetpath)
}
df_ex1 <- read.csv(targetpath)

splitnames <- strsplit(names(df_ex1), "wgtp")

splitnames[123]



# Problem 2
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?
#         
#         Original data sources:
#         
#         http://data.worldbank.org/data-catalog/GDP-ranking-table

fileurl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
targetpath2 <- "datasets/countryGDP.csv"
if (!file.exists(targetpath2)) {
        download.file(fileurl2,targetpath2)
}
df_ex2 <- read.csv(targetpath2)


# Column 5 has the gdp values. Has name "X.3". Should probably rename
colnames(df_ex2) <- c("CountryCode", "ranking", "na1", "countryNames", "gdp.in.millionsusd", "na2", "na3", "na4", "na5")

v_gdp1 <- df_ex2$gdp.in.millionsusd
v_gdp1 <- v_gdp1[5:length(v_gdp1)]


v_gdp1 <- gsub( ",","", v_gdp1 )
v_gdp1 <- gsub( " ","", v_gdp1 )

num_gdp1 <- lapply(v_gdp1, function(x) as.numeric(as.character(x)) )
num_gdp1 <- num_gdp1[!is.na(num_gdp1)]

num_gdp1 <- unlist(num_gdp1, use.names=FALSE)

# Last few entries are global regions, read first 190 for actual countries
mean(num_gdp1[1:190])



# Problem 3
# In the data set from Question 2 what is a regular expression that would allow you to count the 
# number of countries whose name begins with "United"? Assume that the variable with the country 
# names in it is named countryNames. How many countries begin with United?

table(grep("^United", df_ex2$countryNames))
# Answer: 3



######################################################

# Problem 4
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Load the educational data from this data set:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# 
# Match the data based on the country shortcode. Of the countries for which the end of the fiscal year is available, how many end in June?
#         
#         Original data sources:
#         
#         http://data.worldbank.org/data-catalog/GDP-ranking-table
# 
# http://data.worldbank.org/data-catalog/ed-stats

##################################################################################
# This block is copy/pasted from a different hw3 exercise, it generates the merged df:
url3_gdp <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
targetpath3 <- "datasets/countryGDP.csv"
if (!file.exists(targetpath3)) {
        download.file(url3_gdp, targetpath3)
}
# Nead to clean df_gdp a bit. 
# Skip first few lines
df_gdp <- read.csv(targetpath3, skip = 5, header = F)

# 3rd, 6th, 7th, 8th, 9th columsn are NA and should be deleted
df_gdp <- df_gdp[-c(3,6:10)]
colnames(df_gdp) <- c("CountryCode", "Ranking", "Country", "Economy")

# Remove empty rows
df_gdp <- df_gdp[df_gdp$CountryCode != "" & df_gdp$Ranking!="", ]

# Convert the ranking column to numeric for df_gdp:
df_gdp$Ranking <- as.numeric(as.character(df_gdp$Ranking))
# Convert the Economy column to numeric for df_gdp:
df_gdp$Economy <- as.numeric(as.character(df_gdp$Economy))

# Now download the education table
url3_edu <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
targetpath3 <- "datasets/countryEDU.csv"
if (!file.exists(targetpath3)) {
        download.file(url3_edu, targetpath3)
}
df_edu <- read.csv(targetpath3)

mergedData <- merge(x=df_gdp, y=df_edu, by.x='CountryCode', by.y='CountryCode', all = TRUE)
mergedData <- arrange(mergedData,desc(Ranking))
mergedData <- mergedData[!is.na(mergedData$Ranking) & !is.na(mergedData$Income.Group),]
####################################################################################


# The fiscal year is written as text in the Special.Notes column
sum(grepl("June", grep("Fiscal year", mergedData$Special.Notes, value = T) ) )
# Answer: 13

#########################################################################


# Problem 5
# You can use the quantmod (http://www.quantmod.com/) package to get historical 
# stock prices for publicly traded companies on the NASDAQ and NYSE. Use the 
# following code to download data on Amazon's stock price and get the times the data was sampled.
#
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
#
# How many values were collected in 2012? How many values were collected on Mondays in 2012?
sum(grepl("^2012-", sampleTimes))

library(lubridate)
sampleTimes2012 <- sampleTimes[grepl("^2012-",sampleTimes)]
weekdays2012 <- lapply(sampleTimes2012, function(x) wday(x,label=TRUE) )
v_weekdays <- unlist(weekdays2012)
sum(grepl("Mon", v_weekdays))
