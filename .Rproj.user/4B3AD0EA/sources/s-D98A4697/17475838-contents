# Interactive map of Kuopio population and average age by postcoded areas

library(geofi)
library(ggplot2)
library(leaflet)
library(dplyr)
library(janitor)
library(pxweb)
library(tidyr)

## Get post code map data ----
zipcodes <- get_zipcodes(year = 2019) 
zipcodes_kuopio <- zipcodes %>% 
  filter(kunta == 297)
# test zipcodes map
ggplot(zipcodes_kuopio) +
  geom_sf(aes(fill = as.integer(posti_alue)))

# zipcodes_kuopio$posti_alue # kuopion postinumerot


## Get stat.fi data ----
pxweb_query_list <- list("Postinumeroalue" = zipcodes_kuopio$posti_alue,
                         "Tiedot" = c("He_vakiy", "He_kika"))
px_data <- pxweb_get(url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi/Postinumeroalueittainen_avoin_tieto/2019/paavo_1_he_2019.px",
                     query = pxweb_query_list)
tk_data <- as.data.frame(px_data, column.name.type = "text", variable.value.type = "text")
tk_data <- tk_data %>% 
  rename(avointieto = `Paavo - Postinumeroalueittainen avoin tieto 2019`) %>% 
  mutate(posti_alue = substr(Postinumeroalue, 1,5)) %>% 
  spread(Tiedot, avointieto) %>% 
  janitor::clean_names() %>% 
  as_tibble()

## Join datasets and transform to leaflet data ----
dat <- left_join(zipcodes_kuopio, tk_data)
zipcodes_lonlat <- sf::st_transform(x = dat, crs = "+proj=longlat +datum=WGS84")


## Plot leaflet map ----
leaflet(zipcodes_lonlat) %>% 
  addTiles() %>% 
  addPolygons(color = "#ebc034", 
              weight = 1,
              smoothFactor = .5,
              opacity = .9,
              fillColor = ~colorQuantile(palette = "YlOrRd", asukkaat_yhteensa_2017_he)(asukkaat_yhteensa_2017_he),
              fillOpacity = 0.5,
              label = ~paste0(nimi, " (", posti_alue ,") ", asukkaat_yhteensa_2017_he, " asukasta (keski-ikä ",asukkaiden_keski_ika_2017_he," vuotta)"),
              highlightOptions = highlightOptions(color = "white", 
                                                  weight = 2,
                                                  bringToFront = TRUE))


# sum(dat$vakiluku_2017)
