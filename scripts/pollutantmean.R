pollutantmean <- function(directory, pollutant, id=1:332) {

        all_files <- list.files(directory)
        selected_files <- all_files[id]
        #print(l_files)
        
        #read the files into list of dataframes
        Data = lapply(file.path(directory,selected_files),read.csv)
        
        #convert into data frame
        Data = do.call(rbind.data.frame,Data)
        
        #calculate mean
        mean(Data[,pollutant],na.rm=TRUE)
}

