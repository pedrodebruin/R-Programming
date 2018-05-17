# Master R script of solutions to week 3 quiz

# Use this as an exercise on dplyr
library(dplyr)

# Problem 1
# 
# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
# and load the data into R. The code book, describing the variable names is here:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
# Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth 
# of agriculture products. Assign that logical vector to the variable agricultureLogical. 
# Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE.
# 
# which(agricultureLogical)
# 
# What are the first 3 values that result?

url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
targetpath <- "datasets/acs_idaho_2006.csv"
if (!file.exists(targetpath)) {
        download.file(url1, targetpath)
}

df_acs_idaho <- read.csv(targetpath)

# 10 or more acres means ACR==3
# Sold 10k or more agri productions means AGS==6
agricultureLogical <- (df_acs_idaho$ACR==3 & df_acs_idaho$AGS==6)
#df_acs_idaho %>% mutate(agricultureLogical = (df_acs_idaho$ACR==3 & df_acs_idaho$AGS==6))

which(agricultureLogical)[1:3]


# Problem 2

# Using the jpeg package read in the following picture of your instructor into R
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
# 
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
#         (some Linux systems may produce an answer 638 different for the 30th quantile)

# If you don't have it already:
# install.packages('jpeg')
library(jpeg)

url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
targetpath2 <- "datasets/jeff.jpg"
download.file(url2, targetpath2, mode = "wb")  # if you don't do "wb" (write binary) there will be a corruption issue 

jeffjpg <- jpeg::readJPEG(targetpath2, native=TRUE)

quantile(jeffjpg, probs = c(0.3, 0.8))

# Can plot it if you want (only R versions >= 2.11.0)
if (exists("rasterImage")) { # can plot only in R 2.11.0 and higher
        plot(1:2, type='n')
        
        rasterImage(jeffjpg, 1.5, 1.5, 1.9, 1.8)
}



# Problem 3
# 
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Load the educational data from this data set:
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# 
# Match the data based on the country shortcode. How many of the IDs match? 
# Sort the data frame in descending order by GDP rank (so United States is last). 
# What is the 13th country in the resulting data frame?
#         
#         Original data sources:
#         http://data.worldbank.org/data-catalog/GDP-ranking-table
# 
# http://data.worldbank.org/data-catalog/ed-stats

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
mergedData <- mergedData[!is.na(mergedData$Economy) & !is.na(mergedData$Income.Group),]

#mergedData[13,1:5]
head(mergedData[,1:5], 20)

# Seems south sudan is in one df and not the other:
v_gdp <- df_gdp$CountryCode; v_edu <- df_edu$CountryCode
v_gdp[!(v_gdp %in% v_edu)]
df_gdp$Country[df_gdp$CountryCode=='SSD']


# Problem 4
# What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?

merged_splitInc = split(mergedData$Economy,mergedData$Income.Group)
merged_splitInc
#merged_splitInc <- merged_splitInc[!is.na(merged_splitInc)]


mean(merged_splitInc[1])
mean(merged_splitInc[2])


