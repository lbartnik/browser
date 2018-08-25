library(repository)
library(jsonlite)

r <- sample_repository()
x <- as_artifacts(r) %>% read_artifacts()

jsonlite::write_json(strip_class(x), 'work/data.json', pretty = TRUE)

browser_addin(x)
