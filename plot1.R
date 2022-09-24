## load libraries
library(tidyverse)


## If data is not present, download from URL and unzip
if(!file.exists("pm25_emissions.zip")){
  dlMethod <- "wininet"
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(url,destfile='pm25_emissions.zip',method=dlMethod,mode="wb")
  unzip(zipfile = "pm25_emissions.zip")    
}

## read in data
NEI <- read_rds("summarySCC_PM25.rds")
SCC <- read_rds("Source_Classification_Code.rds")


## Create data frame of total PM2.5  emissions by year 
NEI <- NEI %>%
  select(Emissions, year)%>%
  group_by(year)%>%
  summarise(sum(Emissions))



## scatterplot the data
png("Plot1.png")
plot(NEI, ylab = "Total PM 2.5 Emissions", pch=18, col = 'red', cex = 2)
dev.off()

## PM2.5 has decreased over the years 