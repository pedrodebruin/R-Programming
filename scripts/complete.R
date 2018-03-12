complete <- function(directory, id) {
        
        all_files <- list.files(directory)
        selected_files <- all_files[id]
        print(selected_files)
        
        #read the files into list of dataframes
        Data = lapply(file.path(directory,selected_files),read.csv)
        
        #convert into data frame
        Data = do.call(rbind.data.frame,Data)
        #print(dim(Data))
        
        #print(Data[,"sulfate"])
        goodDF <- subset( Data[!is.na(Data[,"ID"]) & !is.na(Data[,"sulfate"]) & !is.na(Data[,"nitrate"]), ] )[4]
        
        #print(dim(goodDF))
        #print(head(goodDF))
        
        outputDF <- data.frame()
        for (i in id) {
                outputDF <- rbind( outputDF, c(i, sum(goodDF[1]==i)) )
        }
        colnames(outputDF) <- c("id", "nobs")
        outputDF
        
}

