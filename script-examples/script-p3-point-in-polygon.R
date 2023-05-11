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
  tm_dots(size = 0.1, shape = 19, col = "darkred", alpha = 0.5)
table(crimes_sf_bng$Crime.type)

### Point in Polygon
#plot the crime data
tm_shape(crimes_sf_bng) +
  tm_dots(size = 0.1, shape = 19, col = "red", alpha = 0.5) +
  #add LSOA on top
  tm_shape(LSOA) +
  tm_borders()

#perform spatial join
LSOA_crimes <- st_join(LSOA, crimes_sf_bng)
#view output
head(LSOA_crimes)

#Aggregate by LSOA
LSOA_crimes_aggregated <- aggregate(x = LSOA_crimes, by = list(LSOA_crimes$lsoa21cd), FUN = length)

#remove additional columns
LSOA_crimes_aggregated <- LSOA_crimes_aggregated[,1:2]
#rename columns
colnames(LSOA_crimes_aggregated) <- c("lsoa21cd", "count of crimes","geometry")
#map using qtm
qtm(LSOA_crimes_aggregated, fill = "count of crimes")

#map using tmap
tm_shape(LSOA_crimes_aggregated) +
  tm_polygons("count of crimes", title = "Number of Crimes", palette = "Greens", style = "jenks")

### Exporting Shapefiles
#save as shapefile
st_write(LSOA_crimes_aggregated, "LSOA-crime-count.shp")