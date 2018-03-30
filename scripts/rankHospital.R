library(plyr)
rankhospital <- function (state, outcome, num) {
        
        ## Read outcome data
        rawdata <- read.csv("outcome-of-care-measures.csv")
        
        
        ## Subset to state
        if (! (state %in% rawdata$State)) {
                stop("Error: invalid state")
        }
        statedata <- rawdata[rawdata$State == state,]
        
        if (outcome == "heart attack") {
                colnames(statedata)[
                        which(names(statedata) == "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack")] <- "mortality"
        }
        else if (outcome == "heart failure") {
                colnames(statedata)[
                        which(names(statedata) == "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure")] <- "mortality"
        }
        else if (outcome == "pneumonia") {
                colnames(statedata)[
                        which(names(statedata) == "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")] <- "mortality"
        }
        else {
                stop("You supplied a bad outcome, returning...")
        }
        
        ## Order by outcome and retrieve nth row (or best, or worst)
        gooddata <- statedata[!is.na(statedata$mortality) & statedata$mortality != "Not Available", ]
        data <- gooddata[order(as.numeric(as.character(gooddata$mortality)), gooddata$Hospital.Name) , ]

        if (num=="best") { 
                #print( (data$"Hospital.Name") )
                bestHospital <- as.character(data$"Hospital.Name")[1] 
                rate <- as.character(data$mortality)[1]
        }
        else if (num=="worst") { 
                bestHospital <- as.character(data$"Hospital.Name")[nrow(data)] 
                rate <- as.character(data$mortality)[nrow(data)]
        }
        else { 
                bestHospital <- as.character(data$"Hospital.Name")[num] 
                rate <- as.character(data$mortality)[num]
        }
        
        ## Return hospital name in that state with lowest 30-day death
         
        ## rate
        print(cat("Hospital name in ", state, " is ", bestHospital, " with mortality rate of ", rate))
        c(bestHospital, rate)

}