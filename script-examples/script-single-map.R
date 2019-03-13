#load libraries
  library(sf)
  library(tmap)
#download csv file
  download.file("http://www.nickbearman.me.uk/data/r/nomis-2011-age-data.zip","nomis-2011-age-data.zip")
#unzip csv file
  unzip("nomis-2011-age-data.zip")
#read in csv file to pop2011
  pop2011 <- read.csv("bulk.csv", header = TRUE)
#create a new variable which contains the new variable names
  newcolnames <- c("AllUsualResidents","Age00to04","Age05to07",
                   "Age08to09","Age10to14","Age15","Age16to17",
                   "Age18to19","Age20to24","Age25to29",
                   "Age30to44","Age45to59","Age60to64",
                   "Age65to74","Age75to84","Age85to89",
                   "Age90andOver","MeanAge","MedianAge")
#apply these to pop2011 data frame
  colnames(pop2011)[5:23] <- newcolnames
#download shapefile
  download.file("http://www.nickbearman.me.uk/data/r/england_lsoa_2011.zip","england_lsoa_2011.zip")
#unzip shapefile
  unzip("england_lsoa_2011.zip")
#read in shapefile
  LSOA <- st_read("england_lsoa_2011.shp")
#join attribute data to LSOA
  LSOA <- merge(LSOA,pop2011,by.x="code",by.y="geography.code")
#map 
  tm_shape(LSOA) +
    tm_polygons("Age00to04", title = "Aged 0 to 4", palette = "Greens", style = "jenks") +
    tm_layout(legend.title.size = 0.8)
 