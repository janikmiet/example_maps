library(geofi)
library(ggplot2)
library(dplyr)
library(janitor)
library(tidyr)

## Basic map ----
municipalities <- get_municipalities(year = 2019, scale = 4500)
ggplot(municipalities) + 
  geom_sf(aes(fill = as.integer(kunta)))

## Post code map ----
zipcodes <- get_zipcodes(year = 2019) 
ggplot(zipcodes) + 
  geom_sf(aes(fill = as.integer(posti_alue)))

## Interactive map ----
library(leaflet)
library(geofi)
library(dplyr)

municipalities <- get_municipalities(year = 2019, scale = 4500)
municipalities_lonlat <- sf::st_transform(x = municipalities, crs = "+proj=longlat +datum=WGS84")

leaflet(municipalities_lonlat) %>% 
  addTiles() %>% 
  addPolygons(color = "coral", 
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.5,
              label = ~nimi,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE))

