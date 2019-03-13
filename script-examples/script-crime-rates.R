#load libraries
  library(sf)
  library(tmap)

#Read the data into a variable called crimes
  crimes <- read.csv("http://nickbearman.me.uk/data/r/police-uk-2018-12-merseyside-street.csv")
#create crimes data 
  crimes_sf <- st_as_sf(crimes, coords = c('Longitude', 'Latitude'), crs = "+init=epsg:4326")
#qtm
  qtm(crimes_sf)
#reproject to British National Grid, from Latitude/Longitude
  crimes_sf_bng <- st_transform(crimes_sf, crs = "+init=epsg:27700")
#plot map
  tm_shape(crimes_sf_bng) +
    tm_dots(size = 0.1, shape = 19, col = "darkred", alpha = 0.5)
#table of crime types
table(crimes_sf_bng$Crime.type)

#Point in Polygon
  #plot the crime data
  tm_shape(crimes_sf_bng) +
    tm_dots(size = 0.1, shape = 19, col = "red", alpha = 0.5)+
    #add LSOA on top
    tm_shape(LSOA) +
    tm_borders()

  #load libraries
    library(rgdal) #for readOGR()
    library(GISTools) #for poly.counts()
  #read shape file in in SP format
    LSOA_sp <- readOGR(".", "england_lsoa_2011")
  #convert crimes SF to sp
  #(see https://cran.r-project.org/web/packages/sf/vignettes/sf2.html#
  #     conversion_to_other_formats:_wkt,_wkb,_sp for details)
    crimes_sp_bng <- as(crimes_sf_bng, "Spatial")
  #calculate the number of crimes in each LSOA
    crimes.count <- poly.counts(crimes_sp_bng, LSOA_sp)
  #add this as a new field to our LSOA data
    LSOA_sp@data$crimes.count <- crimes.count
  #show the first 6 rows (exactly the same as head(LSOA_sp) but for SP data)
    head(LSOA_sp@data)

#tmap of crime count
  tm_shape(crimes_sf_bng) +
    tm_dots(size = 0.1, shape = 19, col = "red", alpha = 0.5) +
    #add LSOA on top
    tm_shape(LSOA_sp) +
    tm_borders()

#Calc Crime Rate
  #join pop data
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
    #read in shapefile
      LSOA <- st_read("england_lsoa_2011.shp")
    #join attribute data to LSOA
      LSOA <- merge(LSOA,pop2011,by.x="code",by.y="geography.code")
    #check data
      head(LSOA)
    #add crime count
      LSOA$crimes.count <- crimes.count
    #check data
      head(LSOA)
    #calculate crime rate
      LSOA$crime.rate <- (LSOA$crimes.count / LSOA$AllUsualResidents) * 10000
    #check
      head(LSOA)
    #map 
      qtm(LSOA, fill="crime.rate")

    #tmap of crime count
      tm_shape(crimes_sf_bng) +
        tm_dots(size = 0.1, shape = 19, col = "red", alpha = 0.5) +
      #add LSOA on top
        tm_shape(LSOA_sp) +
        tm_borders()

    #tmap of crime rate
      tm_shape(LSOA) +
        tm_polygons("crime.rate", title = "Crime rate per 10,000 pop", palette = "Greens", style = "jenks") +
        tm_layout(legend.title.size = 0.8)
    
    #tmap of crime rate & crime points
      tm_shape(LSOA) +
        tm_polygons("crime.rate", title = "Crime rate per 10,000 pop", palette = "Greens", style = "jenks") +
        tm_layout(legend.title.size = 0.8) +
      #add crime points
        tm_shape(crimes_sf_bng) +
          tm_dots(size = 0.1, shape = 19, col = "red", alpha = 0.5)
