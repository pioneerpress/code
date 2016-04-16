## Based off code by Ari Lamsteim: http://www.arilamstein.com/blog/2015/11/16/search-census-data-r/

library(choroplethr)
library(choroplethrMaps)
library(acs)

acs.lookup(keyword = "Syrian", endyear = 2014) ## Look up Census tables with the word Syrian
s = get_acs_data("B04006", "county", column_idx=13) ## Pull the "Syrian" column from the Census table for "People Reporting Ancestry"
dfs = s[[1]]
data(county.regions)
dfs2 = merge(dfs, county.regions)
p = get_acs_data("B03002", "county", column_idx=1) ## Download county population data
dfp = p[[1]]
dfs3 = merge(dfs, dfp, by = "region") ## Merge county population data with the Syrian ancestry count
dfs3$value = dfs3$value.x/dfs3$value.y*100000 ## Convert raw population estimates into per capita estimates by dividing by population.
dfs3 = dfs3[,c(1,4)]

jpeg("syrian_norm.jpg", width=1000, height=600)
county_choropleth(dfs, title = "2014 County 5-year Estimates:\nNumber of Syrians per county", num_colors=1) ## Absolute count
dev.off()

jpeg("syrian_pc.jpg", width=1000, height=600)
county_choropleth(dfs3, title = "2014 County 5-year Estimates:\nNumber of Syrians per county (per 100,000 residents)", num_colors=1) ## Per capita map
dev.off()

dfs4 = dfs
dfs4$value = log10(dfs4$value+1) ## Convert per-capita count to a log scale.
jpeg("syrian_log.jpg", width=1000, height=600)
county_choropleth(dfs4, title = "2014 County 5-year Estimates:\nNumber of Syrians per County (log scale)", num_colors=1) ##Log scale map
dev.off()
