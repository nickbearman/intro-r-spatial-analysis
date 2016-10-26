#setup variable with list of maps to print
mapvariables <- c(13,15,17)
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
  title(colnames(LSOA@data)[mapvariables[i]])
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