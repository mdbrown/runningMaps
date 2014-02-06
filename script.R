library(plotKML)

# GPX files downloaded from Runkeeper
files <- dir("activities/", pattern = "\\.gpx")
# Consolidate routes in one drata frame
index <- c()
latitude <- c()
longitude <- c()
setwd("activities/")
for (i in 1:length(files)) {
  
  route <- readGPX(files[i])
  location <- route$tracks[[1]][[1]]
  
  index <- c(index, rep(i, dim(location)[1]))
  latitude <- c(latitude, location$lat)
  longitude <- c(longitude, location$lon)
}
setwd("..")
routes <- data.frame(cbind(index, latitude, longitude))
routes <- with(routes, routes[latitude<48,]) #dont want the runs up in skagit valley


# Map the routes with a simple line graph
ids <- unique(index)
plot(routes$longitude, routes$latitude, type="n", axes=FALSE, xlab="", ylab="", main="", asp=1)
for (i in 1:length(ids)) {
  currRoute <- subset(routes, index==ids[i])
  lines(currRoute$longitude, currRoute$latitude, col="#00000020")
}






 zoom <- min(MaxZoom(range(routes$latitude), range(routes$longitude)));


gmap <- ggmap(get_map(location = c(-122.31, 47.595),
                      zoom = 12, maptype = "toner", 
                      source="stamen")) 
gmap


g <- gmap  + geom_path(data = routes, 
                       aes(x=longitude, y=latitude, group =factor(index)), 
                       col="purple", 
                       alpha = .5, 
                       size = 1) +
  scale_x_continuous("", breaks = NA) + 
  scale_y_continuous("", breaks = NA) 

g
