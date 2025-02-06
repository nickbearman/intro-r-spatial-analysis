#load libraries
  library(sf)
  library(tmap)
#download csv file
  #download.file("http://www.nickbearman.me.uk/data/r/nomis-2011-age-data.zip","nomis-2011-age-data.zip")
#unzip csv file
  #unzip("nomis-2011-age-data.zip")
  pop2021 <- read.csv("census2021-ts007a-lsoa.csv", header = TRUE)
  head(pop2021[,1:5])
#create a new variable which contains the new variable names
  newcolnames <- c("Total","Age00to04","Age05to09","Age10to14","Age15to19",
                   "Age20to24","Age25to29","Age30to34","Age35to39",
                   "Age40to44","Age45to49","Age50to54","Age55to59",
                   "Age60to64","Age65to69","Age70to74","Age75to79",
                   "Age80to84","Age85andOver")
#apply these to pop2021 data frame
  colnames(pop2021)[4:22] <- newcolnames
  head(pop2021[,1:9])
#download.file("http://www.nickbearman.me.uk/data/r/england_lsoa_2021.zip","england_lsoa_2021.zip")
  #unzip("england_lsoa_2021.zip")
#read in shapefile
  LSOA <- st_read("england_lsoa_2021.shp")
#join attribute data to LSOA
  LSOA <- merge(LSOA, pop2021, by.x="lsoa21cd", by.y="geography.code")
#multiple maps
  #set which variables will be mapped
  mapvariables <- c("Total", "Age00to04", "Age05to09")
  #loop through for each map
  for (i in 1:length(mapvariables)) {
    #setup map
    m <- tm_shape(LSOA) +
      tm_polygons(fill = mapvariables[i],
                  fill.scale = tm_scale_intervals(values = "brewer.greens", style = "jenks"),
                  fill.legend = tm_legend(title = "Liverpool", size = 0.8)) +
      tm_scalebar(position = c(0.1, 0.1)) + 
      ##north arrow
      tm_compass(size = 1.5, position = c(0.1, 0.3))
    
    #save map
    tmap_save(m, filename = paste0("map-",mapvariables[i],".png"))
    #end loop
  }
