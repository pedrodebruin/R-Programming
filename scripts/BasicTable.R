# Collection of commands to answer # https://www.coursera.org/learn/r-programming/exam/lB1sR/week-1-quiz
# dataset used can be found at https://d396qusza40orc.cloudfront.net/rprog/data/quiz1_data.zip

# In the dataset provided for this Quiz, what are the column names of the dataset?
data[1,]
#Ozone Solar.R Wind Temp Month Day
#1    41     190  7.4   67     5   1

#Extract the first 2 rows of the data frame and print them to the console. What does the output look like?
data[1:2,]
#Ozone Solar.R Wind Temp Month Day
#1    41     190  7.4   67     5   1
#2    36     118  8.0   72     5   2
  
# How many observations (i.e. rows) are in this data frame?
length(data[,1])
#[1] 153

# Extract the last 2 rows of the data frame and print them to the console. What does the output look like?
tail(data, 2)
#Ozone Solar.R Wind Temp Month Day
#152    18     131  8.0   76     9  29
#153    20     223 11.5   68     9  30

# What is the value of Ozone in the 47th row?
data[47,1]
#[1] 21

# How many missing values are in the Ozone column of this data frame?
length(data[is.na(data[,1]),1])
# [1] 37
# OR (using grep to find arbitrary columns)
colidx <- grep("Ozone", colnames(data)); length( data[is.na(data['Ozone']), colidx] )
#[1] 37

#What is the mean of the Ozone column in this dataset? Exclude missing values (coded as NA) from this calculation.
mean(data[!is.na(data['Ozone']),'Ozone'])

# Extract the subset of rows of the data frame where Ozone values are above 31 and Temp values are above 90. 
# What is the mean of Solar.R in this subset?
mean(data[!is.na(data['Ozone']) & data['Ozone']>31 & data['Temp']>90,'Solar.R'])

# What is the mean of "Temp" when "Month" is equal to 6?
mean( data[ !is.na(data['Temp']) & data['Month']==6 , 'Temp'] )

# What was the maximum ozone value in the month of May (i.e. Month is equal to 5)?
