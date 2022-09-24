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


## merge data
NEI <- left_join(NEI, SCC, by="SCC")


## Create data frame of total coal combustion PM2.5  emissions by year
NEI <- NEI %>%
  filter(grepl("coal", EI.Sector, ignore.case = T))%>%
  select(Emissions, EI.Sector, year)%>%
  group_by(year)%>%
  summarise(sum(Emissions))


png("Plot4.png")
qplot(x=year, y=`sum(Emissions)`, data=NEI) + geom_smooth()
dev.off()
