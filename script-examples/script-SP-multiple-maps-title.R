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
#setup variable with list of maps to print
  mapvariables <- c(6,7,8,9)
#loop through for each map
  for (i in 1:length(mapvariables)) {
    #setup file name
      filename <- paste0("map",colnames(LSOA@data)[mapvariables[i]],".pdf")
      pdf(file=filename)
    #create map
      var <- LSOA@data[,mapvariables[i]]
    #colours and breaks
      breaks <- classIntervals(var, n = 6, style = "fisher")
      my_colours <- brewer.pal(6, "Greens")
    #plot map
      plot(LSOA, col = my_colours[findInterval(var, breaks$brks, all.inside = TRUE)], 
         axes = FALSE, border = rgb(0.8,0.8,0.8))
    #add legend
      legend(x = 330130, y = 385206.5, legend = leglabs(breaks$brks), fill = my_colours, bty = "n")
    #add title
      #get fieldname and convert to title
        fieldname <- colnames(LSOA@data)[mapvariables[i]]
        firstyear <- substr(fieldname, 4, 5)
        lastyear <- substr(fieldname, 8, 9)
      title(paste0("Count of population Aged ", firstyear, " to ", lastyear))
    #Add North Arrow
      SpatialPolygonsRescale(layout.north.arrow(2), offset= c(332732,385110), scale = 2000, 
                           plot.grid=F)
    #Add Scale Bar
      SpatialPolygonsRescale(layout.scale.bar(), offset= c(331030,379600), scale= 5000, 
                           fill= c("white", "black"), plot.grid= F)
    #Add text to scale bar 
      text(331030,379206,"0km", cex=.6)
      text(331030 + 2500,379206,"2.5km", cex=.6)
      text(331030 + 5000,379206,"5km", cex=.6)
    dev.off()
  }