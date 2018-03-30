library(R.utils)
rankall <- function(outcome, num = "best") {
        ## Read outcome data
        rawdata <- read.csv("outcome-of-care-measures.csv")
        
        # state.abb doesn't have DC... use unique()
        #allstates <- state.abb
        allstates <- sort(unique(rawdata$State))
        
        # Load scripts in current path. Make sure rankHospital is in same path
        #pathnames <- list.files(pattern="[.]R$", path="./", full.names=TRUE);
        #sapply(pathnames, FUN=source);
        sourceDirectory("./", modifiedOnly=TRUE);
        
        dfRankAll <- data.frame(state=character(), hospital=character())
                                
        ## For each state, find the hospital of the given rank
        cat("Building rank for outcome ", outcome, "\n")
        for (state in allstates) {
                #cat("\nDoing state ", state, "\n")
                        
                hospital <- (rankhospital(state, outcome, num))[1]
                #cat(bestHospitalInState, "\n")
                dfRankAll <- rbind(dfRankAll, data.frame(state, hospital) )
        }
        
        ## Return a data frame with the hospital names and the
        colnames(dfRankAll) <- c("state", "hospital")
        
        dfRankAll <- dfRankAll[order(dfRankAll$state),]
        dfRankAll

}