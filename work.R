library(repository)

r <- sample_repository()
x <- as_artifacts(r) %>% read_artifacts()

browser_addin(x)
