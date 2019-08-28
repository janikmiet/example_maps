# Interactive map of population in Kuopio
# Leaflet map with postcoded areas, population size and average age
## TODO to make this interactivly work, map need to be in Shiny app!!

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

## agegroup data
pxweb_query_list <- list("Postinumeroalue" = zipcodes_kuopio$posti_alue,
                         "Tiedot" = c("He_0_2",
                                      "He_3_6",
                                      "He_7_12",
                                      "He_13_15",
                                      "He_16_17",
                                      "He_18_19",
                                      "He_20_24",
                                      "He_25_29",
                                      "He_30_34",
                                      "He_35_39",
                                      "He_40_44",
                                      "He_45_49",
                                      "He_50_54",
                                      "He_55_59",
                                      "He_60_64",
                                      "He_65_69",
                                      "He_70_74",
                                      "He_75_79",
                                      "He_80_84",
                                      "He_85_"))
px_data1 <- pxweb_get(url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi/Postinumeroalueittainen_avoin_tieto/2019/paavo_1_he_2019.px",
                     query = pxweb_query_list)
tk_data1 <- as.data.frame(px_data1, column.name.type = "text", variable.value.type = "text")
tk_data1 <- tk_data1 %>% 
  rename(ikaluokka=Tiedot,
         lkm = `Paavo - Postinumeroalueittainen avoin tieto 2019`) %>% 
  mutate(posti_alue = substr(Postinumeroalue, 1,5)) %>% 
  select(-Postinumeroalue) %>% 
  janitor::clean_names() %>% 
  as_tibble()

## basic data
pxweb_query_list <- list("Postinumeroalue" = zipcodes_kuopio$posti_alue,
                         "Tiedot" = c("He_vakiy", 
                                      "He_kika"))
px_data2 <- pxweb_get(url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi/Postinumeroalueittainen_avoin_tieto/2019/paavo_1_he_2019.px",
                      query = pxweb_query_list)
# wrangle to data frame
tk_data2 <- as.data.frame(px_data2, column.name.type = "text", variable.value.type = "text")
tk_data2 <- tk_data2 %>% 
  rename(avointieto = `Paavo - Postinumeroalueittainen avoin tieto 2019`) %>% 
  mutate(posti_alue = substr(Postinumeroalue, 1,5)) %>% 
  spread(Tiedot, avointieto) %>% 
  janitor::clean_names() %>% 
  as_tibble()

## join datasets together
for (rw in 1:nrow(tk_data2)) {
  print(tk_data2$posti_alue[rw])
  tk_data2$ikarakenne <- list(tk_data1[tk_data1$posti_alue == tk_data2$posti_alue[rw],])
  # as.data.frame(tk_data1[tk_data1$posti_alue == tk_data2$posti_alue[1],])
}

## Join datasets and transform to leaflet data ----
dat <- left_join(zipcodes_kuopio, tk_data2)
zipcodes_lonlat <- sf::st_transform(x = dat, crs = "+proj=longlat +datum=WGS84")


## plot of agegroups
ggplot(data = as.data.frame(tk_data2$ikarakenne[tk_data2$posti_alue == "73810"])) +
  geom_bar(aes(x=ikaluokka, y=lkm), stat = "identity") +
  coord_flip()


## Plot leaflet map ----
leaflet(zipcodes_lonlat) %>% 
  addTiles() %>% 
  addPolygons(color = "coral", 
              weight = 1,
              smoothFactor = .5,
              opacity = .9,
              fillColor = ~colorBin(palette = "plasma", asukkaat_yhteensa_2017_he)(asukkaat_yhteensa_2017_he),
              fillOpacity = 0.5,
              label = ~paste0(nimi, " (", posti_alue ,") ", asukkaat_yhteensa_2017_he, " asukasta, keski-ikä ",asukkaiden_keski_ika_2017_he," vuotta"),
              highlightOptions = highlightOptions(color = "white", 
                                                  weight = 2,
                                                  bringToFront = TRUE))
