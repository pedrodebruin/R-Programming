corr <- function(directory, threshold=0) {

        # See warnings
        warnings()
        
        allIDs <- 1:332
        all_files <- list.files(directory)
        #print(all_files)
        #read the files into list of dataframes
        allData = lapply(file.path(directory, all_files),read.csv)
        
        #convert into data frame
        allData = do.call(rbind.data.frame,allData)
        print ("passed Data building. Data has dimension: ")
        print(dim(allData))
        
        #allGoodDF <- subset( allData[!is.na(allData[,"sulfate"]) & !is.na(allData[,"nitrate"]), ] )
        print("allGoodDF:") 
        print(head(allData))
        
        completeDF <- complete("./specdata", allIDs)
        print("completeDF:") 
        print(head(completeDF))
        
        passThresholdIDs <- completeDF[completeDF[,"nobs"]>threshold, "id"] 
        
        print("Number of good IDs passing threshold:")
        print(length(passThresholdIDs))
        print(passThresholdIDs[1:10])
        
        print("About to run by structure")
        
        allData$ID <- factor(allData$ID)

        results <- list()        
        results <- 
        by (allData, allData$ID , function(x) {
                
                print("Number of good data for this ID:")
                print(length(x$ID))
                #print(sum(x$sulfate, na.rm=TRUE))
                #print(sum(x$nitrate, na.rm=TRUE))
                v_s <- x$sulfate[!is.na(x$sulfate) & !is.na(x$nitrate)]
                v_n <- x$nitrate[!is.na(x$sulfate) & !is.na(x$nitrate)]
                
                print("First 10 elements of sulfate that are good for it and nitrate:")
                print(v_s[1:10])
                print("First 10 elements of nitrate that are good for it and sulfate:")
                print(v_n[1:10])
                
                cor(v_s,v_n)
        })
        
        print(dim(results))
        # turn into a matrix
        results <- t(sapply(results, I))
        print(dim(results))
        
        #  get it as a column
        results <- t(as.data.frame(results))
        print(dim(results))
        # keep only good IDs 
        results <- results[passThresholdIDs,]
        
        #print(dim(results))
        #print(class(results))
        #results[1:5,]
        #print(head(results[passThresholdIDs,]))
        
}