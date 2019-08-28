
# Different layouts for maps ----
library(stringr)
names(providers)
names(providers)[str_detect(names(providers), "CartoDB")]
leaflet() %>% 
  addProviderTiles(provider = "CartoDB")
