#practical 3

library(sf)
library(rgdal)
library(GISTools)
library(tmap)

setwd("C:/Users/nick/Dropbox/Work/course-repos/03-intro-r-spatial-analysis/data-user")

crimes <- read.csv("http://nickbearman.me.uk/data/r/police-uk-2020-04-merseyside-street.csv")

#create crimes data 
#crimes_sf <- st_as_sf(crimes, coords = c('Longitude', 'Latitude'), crs = "+init=epsg:4326")
crimes_sf <- st_as_sf(crimes, coords = c('Longitude', 'Latitude'), crs = "epsg:4326")

qtm(crimes_sf)

#reproject to British National Grid, from Latitude/Longitude
#crimes_sf_bng <- st_transform(crimes_sf, crs = "+init=epsg:27700")
crimes_sf_bng <- st_transform(crimes_sf, crs = "epsg:27700")

tm_shape(crimes_sf_bng) +
  tm_dots(size = 0.1, shape = 19, col = "darkred", alpha = 0.5)

table(crimes_sf_bng$Crime.type)

#point in polygon

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


head(LSOA_sp@data)
