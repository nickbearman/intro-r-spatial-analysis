#load libraries
  library(maptools)
  library(rgdal)
  library(classInt)
  library(RColorBrewer)
#download csv file
  #download.file("http://www.nickbearman.me.uk/data/r/nomis-2011-age-data.zip","nomis-2011-age-data.zip")
#unzip csv file
  #unzip("nomis-2011-age-data.zip")
#read in csv file to pop2021
  pop2021 <- read.csv("census2021-ts007a-lsoa.csv", header = TRUE)
#create a new variable which contains the new variable names
  newcolnames <- c("Total","Age00to04","Age05to09","Age10to14","Age15to19",
                   "Age20to24","Age25to29","Age30to34","Age35to39",
                   "Age40to44","Age45to49","Age50to54","Age55to59",
                   "Age60to64","Age65to69","Age70to74","Age75to79",
                   "Age80to84","Age85andOver")
#apply these to pop2021 data frame
  colnames(pop2021)[4:22] <- newcolnames
#download shapefile
  #download.file("http://www.nickbearman.me.uk/data/r/england_lsoa_2011.zip","england_lsoa_2011.zip")
#unzip shapefile
  #unzip("england_lsoa_2011.zip")
#read in shapefile
  LSOA <- readOGR(".", "england_lsoa_2021")
#join attribute data to LSOA
  LSOA@data <- merge(pop2021,LSOA@data,by.x="geography.code",by.y="lsoa21cd")
#select variable
  var <- LSOA@data[,"Age00to04"]
#set colours & breaks
  breaks <- classIntervals(var, n = 6, style = "fisher")
  my_colours <- brewer.pal(6, "Greens")
#plot map
  plot(LSOA, col = my_colours[findInterval(var, breaks$brks, all.inside = TRUE)], axes = FALSE, 
       border = rgb(0.8,0.8,0.8))
#draw legend
  legend(x = 329130, y = 386506.5, legend = leglabs(breaks$brks), fill = my_colours, bty = "n")
  