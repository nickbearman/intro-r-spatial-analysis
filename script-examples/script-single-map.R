#load libraries
  library(maptools)
  library(rgdal)
  library(classInt)
  library(RColorBrewer)
#download csv file
  download.file("http://www.nickbearman.me.uk/data/r/nomis-2011-age-data.zip","nomis-2011-age-data.zip")
#unzip csv file
  unzip("nomis-2011-age-data.zip")
#read in csv file to pop2011
  pop2011 <- read.csv("bulk.csv", header = TRUE)
#create a new variable which contains the new variable names
  newcolnames <- c("AllUsualResidentsc","Age00to04","Age05to07",
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
  LSOA <- readOGR(".", "england_lsoa_2011")
#join attribute data to LSOA
  LSOA@data <- merge(pop2011,LSOA@data,by.x="geography.code",by.y="code")
#select variable
  var <- LSOA@data[,"Age00to04"]
#set colours & breaks
  breaks <- classIntervals(var, n = 6, style = "fisher")
  my_colours <- brewer.pal(6, "Greens")
#plot map
  plot(LSOA, col = my_colours[findInterval(var, breaks$brks, all.inside = TRUE)], axes = FALSE, 
       border = rgb(0.8,0.8,0.8))
#draw legend
  legend(x = 328130, y = 386506.5, legend = leglabs(breaks$brks), fill = my_colours, bty = "n")
  