#load libraries
  library(maptools)
  library(rgdal)
  library(classInt)
  library(RColorBrewer)
#download csv file
  download.file("http://www.nickbearman.me.uk/data/r/KS102EW_2596_2011SOA_NW.csv","KS102EW_2596_2011SOA_NW.csv")
#read in csv file to pop2011
  pop2011 <- read.csv("KS102EW_2596_2011SOA_NW.csv", header = TRUE, skip = 5)
#create a new variable which contains the new variable names
  newcolnames <- c("AllUsualResidentsc","Age00to04c","Age00to04pc","Age05to07c","Age05to07pc",
                   "Age08to09c","Age08to09pc","Age10to14c","Age10to14pc","Age15c","Age15pc","Age16to17c",
                   "Age16to17pc","Age18to19c","Age18to19pc","Age20to24c","Age20to24pc","Age25to29c",
                   "Age25to29pc","Age30to44c","Age30to44pc","Age45to59c","Age45to59pc","Age60to64c",
                   "Age60to64pc","Age65to74c","Age65to74pc","Age75to84c","Age75to84pc","Age85to89c",
                   "Age85to89pc","Age90andOverc","Age90andOverpc","MeanAge","MedianAge")
#apply these to pop2011 data frame
  colnames(pop2011)[11:45] <- newcolnames
#download shapefile
  download.file("http://www.nickbearman.me.uk/data/r/england_lsoa_2011.zip","england_lsoa_2011.zip")
#unzip shapefile
  unzip("england_lsoa_2011.zip")
#read in shapefile
  LSOA <- readOGR(".", "england_lsoa_2011")
#join attribute data to LSOA
  LSOA@data <- merge(pop2011,LSOA@data,by.x="LSOA_CODE",by.y="code")
#select variable
  var <- LSOA@data[,"Age0to4pc"]
#set colours & breaks
  breaks <- classIntervals(var, n = 6, style = "fisher")
  my_colours <- brewer.pal(6, "Greens")
#write out PDF  
  pdf(file="image.pdf")
#select variable
  var <- LSOA@data[,"Age00to04pc"]
#set colours & breaks
  breaks <- classIntervals(var, n = 6, style = "fisher")
  my_colours <- brewer.pal(6, "Greens")
#plot map
  plot(LSOA, col = my_colours[findInterval(var, breaks$brks, all.inside = TRUE)],   
       axes = FALSE, border = rgb(0.8,0.8,0.8))
#add legend
  legend(x = 330130, y = 385506.5, legend = leglabs(breaks$brks), fill = my_colours, bty = "n")
#add title  
  title('Percentage of Population ages 0 to 4 in Liverpool')
#add north arrow
  SpatialPolygonsRescale(layout.north.arrow(2), offset= c(336030,382006), scale = 2000, 
                         plot.grid=F)
#add scale bar
  SpatialPolygonsRescale(layout.scale.bar(), offset= c(328030,381506), scale= 5000, 
                         fill= c("white", "black"), plot.grid= F)
#add text to scale bar 
  text(331030,379206,"0km", cex=.6)
  text(331030 + 2500,379206,"2.5km", cex=.6)
  text(331030 + 5000,379206,"5km", cex=.6)
#stop PDF output
  dev.off()
  