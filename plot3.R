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


## Create data frame of total Baltimore City PM2.5  emissions by year and type
NEI <- NEI %>%
  filter(fips=="24510")%>%
  select(Emissions, type, year)%>%
  group_by(year, type)%>%
  summarise(sum(Emissions))

png("Plot3.png")
qplot(x= year, y=NEI$`sum(Emissions)`, data=NEI, color=type, size = I(3), shape = type)+geom_smooth()
dev.off()


## All types have decreased over time except point