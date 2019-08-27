---
title: "Untitled"
output: 
  html_document:
    keep_md: true
---





```r
## Basic map ----
library(geofi)
```

```
## Loading ISO 19139 XML schemas...
```

```
## Loading ISO 19115 codelists...
```

```
## 
## geofi R package: tools for open GIS data for Finland.
## Part of rOpenGov <ropengov.github.io>.
```

```r
library(ggplot2)
municipalities <- get_municipalities(year = 2019, scale = 4500)
```

```
## [ows4R][INFO] OWSGetCapabilities - Fetching http://geo.stat.fi/geoserver/wfs?service=WFS&version=1.0.0&request=GetCapabilities 
## [ows4R][INFO] WFSGetFeature - Fetching http://geo.stat.fi/geoserver/wfs?service=WFS&version=1.0.0&typeName=tilastointialueet:kunta4500k_2019&logger=INFO&request=GetFeature 
## [ows4R][INFO] WFSDescribeFeatureType - Fetching http://geo.stat.fi/geoserver/wfs?service=WFS&version=1.0.0&typeName=tilastointialueet:kunta4500k_2019&request=DescribeFeatureType
```

```r
ggplot(municipalities) + 
  geom_sf(aes(fill = as.integer(kunta)))
```

![](README_files/figure-html/unnamed-chunk-1-1.png)<!-- -->



## Useful links

geofi R Package <https://github.com/rOpenGov/geofi>
Leaflet for R <https://rstudio.github.io/leaflet/>
PXWeb API interface for R <https://cran.r-project.org/web/packages/pxweb/vignettes/pxweb.html>
PXWeb API HELP <https://www.stat.fi/static/media/uploads/org_en/avoindata/px-web_api-help.pdf>
