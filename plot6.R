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


## Create data frame of total motor vehicle PM2.5  emissions by year in Baltimore
NEI <- NEI %>%
  filter(fips %in% c("24510","06037") &
           grepl("vehicle", SCC.Level.Two, ignore.case = T))%>%
  select(Emissions, SCC.Level.Two, fips, year)%>%
  group_by(year, fips)%>%
  summarise(sum(Emissions))

png("Plot6.png")

p<-ggplot(data=NEI, aes(year, `sum(Emissions)`)) + geom_point()
p<-p+facet_grid(rows=vars(fips))+geom_smooth()
p<-p+ylab("Log of Motor Vehicle Emissions")
p+scale_y_continuous(trans='log2')

dev.off()

##Baltimore emissions changed more