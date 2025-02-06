##Script from the workbook
  # for tmap v4
  # to install, run: install.packages("tmap")
  # to check which version you have, load tmap: library(tmap)
  # and run: packageVersion("tmap")
  # if you can't install version 4, but want to use it, you can try out on posit.cloud
  # https://nickbearman.github.io/installing-software/r-rstudio.html#posit-cloud

# This contains all the commands from the workbook

## Practical 1: Intro to R & GIS

### R Basics
  6 + 8
  5 * 4
  12 - 14
  6 / 17
  price <- 300
  price - price * 0.2
  discount <- price * 0.2
  price - discount
  house.prices <- c(120,150,212,99,199,299,159)
  house.prices
  mean(house.prices)

### The Data Frame
  hp.data <- read.csv("http://nickbearman.me.uk/data/r/hpdata.csv")
  head(hp.data)
  View(hp.data)
  #rename a column
  colnames(hp.data)[3] <- "Price-thousands"
  #see what has happened
  head(hp.data)
  
### Geographical Information
  #load libraries
  library(sf)
  library(tmap)
  setwd("C:/Users/nick/Documents/work/intro-r-spatial-analysis/data-user")
  download.file("http://www.nickbearman.me.uk/data/r/sthelens.zip","sthelens.zip")
  unzip("sthelens.zip")
  sthelens <- st_read("sthelens.shp")
  qtm(sthelens)
  head(sthelens)
  sthelens <- merge(sthelens, hp.data)
  #use the qtm() function for a Quick TMap
  qtm(sthelens, fill="Burglary")
  
## Practical 2: Making a Map
  
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
  
### Making Maps
  tm_shape(LSOA) +
    tm_polygons("Age00to04")
  
  tm_shape(LSOA) +
    tm_polygons(fill = "Age00to04",
                fill.scale = tm_scale_intervals(values = "brewer.greens", n = 6, style = "jenks"))
  
  tm_shape(LSOA) +
    tm_polygons(fill = "Age00to04",
                fill.scale = tm_scale_intervals(values = "brewer.greens", style = "jenks"),
                fill.legend = tm_legend(title.size = 0.8))

### Colours and Categories
  #load the R Color Brewer library
  library(RColorBrewer)
  #display the palette
  display.brewer.all()
  tm_shape(LSOA) +
    tm_polygons(fill = "Age00to04",
                fill.scale = tm_scale_intervals(values = "brewer.greens", n = 6, style = "jenks"),
                fill.legend = tm_legend(title = "Aged 0 to 4"))
  tm_shape(LSOA) +
    tm_polygons(fill = "Age00to04",
                fill.scale = tm_scale_intervals(values = "brewer.greens", n = 6, style = "fixed", breaks=c(5, 25, 50, 100, 175, 275)),
                fill.legend = tm_legend(title = "Aged 0 to 4"))

### Classification on a Histogram (optional exercise)
  #select the variable
  var <- LSOA$Age00to04
  #calculate the breaks
  library(classInt)
  breaks <- classIntervals(var, n = 6, style = "fisher")
  #draw histogram
  hist(var)
  #add breaks to histogram
  abline(v = breaks$brks, col = "red")

### Histogram on the map
  tm_shape(LSOA) +
    tm_polygons(fill = "Total",
                fill.scale = tm_scale_intervals(values = "brewer.greens", n = 6, style = "jenks"),
                fill.legend = tm_legend(title = "Aged 0 to 4"),
                fill.chart = tm_chart_histogram())

### Scale Bar and North Arrow (optional exercise)
  tm_shape(LSOA) +
    #set column, colours and classification method
	tm_polygons(fill = "Age00to04",
                fill.scale = tm_scale_intervals(values = "brewer.greens", style = "jenks"),
                fill.legend = tm_legend(title = "Aged 0 to 4", size = 0.8)) +
    ##add scale bar
	tm_scalebar(position = c(0.1, 0.1)) + 
    ##north arrow
    tm_compass(size = 1.5, position = c(0.1, 0.3)) +
	#Set title details
	tm_title("Total Population of Liverpool, 2021")

### Interactive Maps (optional exercise)
  #set tmap to view mode
  tmap_mode("view")
  #plot using qtm
  qtm(sthelens)
  #plot using tm_shape
  tm_shape(LSOA) +
    #Set colours and classification methods
    tm_polygons(fill = "Total",
                fill.scale = tm_scale_intervals(values = "brewer.greens", style = "jenks"))
  #return tmap to plot mode
  tmap_mode("plot")

### Exporting and Creating Multiple Maps
  #create map
  m <- tm_shape(LSOA) +
    tm_polygons(fill = "Total",
                fill.scale = tm_scale_intervals(values = "brewer.greens", style = "jenks"),
                fill.legend = tm_legend(title = "Liverpool", size = 0.8)) +
    tm_scalebar(position = c(0.1, 0.1)) + 
    ##north arrow
    tm_compass(size = 1.5, position = c(0.1, 0.3))
  #save map
  tmap_save(m)


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

## Practical 3: Clustering of Crime Points
  #Read the data into a variable called crimes
  crimes <- read.csv("http://nickbearman.me.uk/data/r/police-uk-2020-04-merseyside-street.csv")
  head(crimes)
  #create crimes data
  crimes_sf <- st_as_sf(crimes, coords = c('Longitude', 'Latitude'), crs = 4326)
  qtm(crimes_sf)
  #reproject to British National Grid, from Latitude/Longitude
  crimes_sf_bng <- st_transform(crimes_sf, crs = 27700)
  qtm(crimes_sf_bng)
  tm_shape(crimes_sf_bng) +
    tm_symbols(size = 0.1,
               col = "darkred", 
               col_alpha = 0.5)  
  table(crimes_sf_bng$Crime.type)
  
### Point in Polygon
  #plot the crime data
  tm_shape(crimes_sf_bng) +
    tm_symbols(size = 0.1,
               col = "red", 
               col_alpha = 0.5) +
    #add LSOA on top
    tm_shape(LSOA) +
    tm_borders()

  #perform spatial join
  LSOA_crimes <- st_join(LSOA, crimes_sf_bng)
  #view output
  head(LSOA_crimes)
  
  #Aggregate by LSOA, this takes ~20 seconds to run
  LSOA_crimes_aggregated <- aggregate(x = LSOA_crimes, by = list(LSOA_crimes$lsoa21cd), FUN = length)
  #gives us count of points in each polygon
  head(LSOA_crimes_aggregated)
  
  #remove additional columns
  LSOA_crimes_aggregated <- LSOA_crimes_aggregated[,1:2]
  #rename columns
  colnames(LSOA_crimes_aggregated) <- c("lsoa21cd", "count of crimes","geometry")
  #map using qtm
  qtm(LSOA_crimes_aggregated, fill = "count of crimes")
  #map using tmap
  tm_shape(LSOA_crimes_aggregated) +
    tm_polygons(fill = "count of crimes",
                fill.scale = tm_scale_intervals(values = "brewer.greens", style = "jenks"),
                fill.legend = tm_legend(title = "Number of Crimes", size = 0.8))
  
  #alternative using summarise (from dplyr library)
  LSOA_crimes_summarised <- 
    LSOA_crimes %>%
    group_by(lsoa21cd) %>%
    summarise(count = n()) 
  
  head(LSOA_crimes_summarised)
  
  #map using tmap
  tm_shape(LSOA_crimes_aggregated) +
    tm_polygons(fill = "count of crimes",
                fill.scale = tm_scale_intervals(values = "brewer.greens", style = "jenks"),
                fill.legend = tm_legend(title = "Number of Crimes", size = 0.8))

### Exporting Shapefiles
  #save as shapefile
  st_write(LSOA_crimes_aggregated, "LSOA-crime-count.shp")

