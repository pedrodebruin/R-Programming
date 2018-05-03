

# This file reads the restaurants.xml, parses it and reads some entries in it

doc <- xmlTreeParse("./data/restaurants.xml", useInternal=TRUE)
rootNode <- xmlRoot(doc)

zipcodes <- xpathSApply(doc, "/response/row/row/zipcode", xmlValue)

sum(zipcodes=="21231")
