SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")
## fips: A five-digit number (represented as a string) indicating the U.S. county
## SCC: The name of the source as indicated by a digit string (see source code classification table)
## Pollutant: A string indicating the pollutant
## Emissions: Amount of PM2.5 emitted, in tons
## type: The type of source (point, non-point, on-road, or non-road)
## year: The year of emissions recorded

years <- unique(NEI$year)

total <- vector(mode = "numeric", length = length(years))

for(y in seq_along(years)){
  total[y] <- sum(NEI$Emissions[NEI$year==years[y]])
}

png('plot1.png')
plot(years, total, type="p", main="Total PM2.5 Emissions from 1999 to 2008", xlab="Year", ylab="Total PM2.5 Emissions (tons)", pch=16, col="red")
lines(years, total)
dev.off()