library(rvest)
library(dplyr)
library(stringr)
library(ggplot2)
library(tidyverse)

# Q1
## Scriping from wiki
url = "https://en.wikipedia.org/wiki/List_of_natural_disasters_by_death_toll"
page = read_html(url)
tables = page %>% html_nodes("table")
twenty_centry = tables[[3]] %>% html_table(fill = TRUE)
twenty_first_centry = tables[[4]] %>% html_table(fill = TRUE)
## Data cleaning
twenty_centry$`Death toll` = sapply(twenty_centry$`Death toll`, function(x){
  x = gsub(",", "", x)
  x = gsub("\\+", "", x)
  if(grepl("–", x)){
    a = as.numeric(str_split(x, "–")[[1]][1])
    b = as.numeric(str_split(x, "–")[[1]][2])
    x = (a+b)/2
  }else if(grepl("-", x)){
    a = as.numeric(str_split(x, "-")[[1]][1])
    b = as.numeric(str_split(x, "-")[[1]][2])
    x = (a+b)/2
  }else if(grepl("\\[", x)){
    x = gsub("\\[.*\\]", "", x)
  }
  return(as.numeric(x))
}, USE.NAMES = FALSE)

twenty_first_centry$`Death toll` = sapply(twenty_first_centry$`Death toll`, function(x){
  x = gsub(",", "", x)
  x = gsub("\\+", "", x)
  x = gsub("\\(.*\\)", "", x)
  if(grepl("–", x)){
    a = as.numeric(str_split(x, "–")[[1]][1])
    b = as.numeric(str_split(x, "–")[[1]][2])
    x = (a+b)/2
  }else if(grepl("-", x)){
    a = as.numeric(str_split(x, "-")[[1]][1])
    b = as.numeric(str_split(x, "-")[[1]][2])
    x = (a+b)/2
  }else if(grepl("\\[", x)){
    x = gsub("\\[.*\\]", "", x)
  }
  return(as.numeric(x))
}, USE.NAMES = FALSE)

combined_df = rbind(twenty_centry, twenty_first_centry)
combined_df$Type = sapply(combined_df$Type, function(x){
  if(x == "Heat Wave"){return("Heat wave")}else if(x == "Earthquake, Tsunami"){
    return("Earthquake")}else if(x == "Tropical cyclone, Flood"){return("Tropical cyclone")}else{return(x)}
}, USE.NAMES = FALSE)

## Visualization
ggplot(combined_df, aes(x = Year, y = `Death toll`, fill = Type)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "20th and 21th Century Deadliest Natural Disasters By Year") +
  scale_x_continuous(breaks = seq(min(combined_df$Year), max(combined_df$Year), by = 5)) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),  
    axis.text.x = element_text(angle = 45, hjust = 1), 
    axis.title.x = element_text(size = 12),  
    axis.title.y = element_text(size = 12)   
  )

# Q2
## Create the gradient descent function
gradient_descent = function(x, y, e = 0.01, iter = 1000, tol = 1e-6) {
  b = 0
  for (i in 1:iter) {
    gradient = -2 * sum(x * (y - b * x))
    b_new = b - e * gradient
    if (abs(b_new - b) < tol) {
      break
    }
    b = b_new
  }
  return(b)
}

## Test the function
test_run = function(n, e, s = 123){
  set.seed(s)
  x = rnorm(n)
  y = rnorm(n)
  true_b = sum(x*y)/sum(x^2)
  estimated_b = gradient_descent(x, y, e)
  return(list("true" = true_b, "estimated" = estimated_b))
}

### One test example
test_illustration = test_run(n = 100, e = 0.01)
true_b = test_illustration$true
estimated_b = test_illustration$estimated
cat("True b:", true_b, "\nEstimated b:", estimated_b, "\n")

### Test performance based on different e
es = seq(0.001, 0.011, by = 0.0001)
test_list = lapply(1:length(es), function(i) test_run(n = 100, e = es[i], s = 123))
true_bs = lapply(1:length(test_list), function(i) test_list[[i]]$true) %>% unlist()
estimated_bs = lapply(1:length(test_list), function(i) test_list[[i]]$estimated) %>% unlist()
test_df = data.frame(cbind(es, true_bs, estimated_bs))
test_df = test_df %>% pivot_longer(cols = c(2:3), names_to = "type", values_to = "b") %>% mutate(type = case_when(type == "estimated_bs" ~ "estimated value",
                                                                                                                  type == "true_bs" ~ "true value"))
ggplot(test_df, aes(x = es, y = b, color = type)) +
  geom_point() +
  labs(x = "learng rate", y = "b", color = "b type")

