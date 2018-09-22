library(repository)
library(jsonlite)
library(browser)

r <- london_meters()
x <- as_artifacts(r) %>% read_artifacts()

jsonlite::write_json(prepareJSON(x), 'work/data.json', pretty = TRUE)

browser_addin(x)
