SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")
## fips: A five-digit number (represented as a string) indicating the U.S. county
## SCC: The name of the source as indicated by a digit string (see source code classification table)
## Pollutant: A string indicating the pollutant
## Emissions: Amount of PM2.5 emitted, in tons
## type: The type of source (point, non-point, on-road, or non-road)
## year: The year of emissions recorded

## Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

library(ggplot2)
library(reshape2)

coal <- SCC$SCC[grep("*Coal", SCC$EI.Sector)]
sectors <- unique(SCC$EI.Sector[grep("*Coal", SCC$EI.Sector)])
years <- unique(NEI$year)

NEI_SCC <- merge(NEI[NEI$SCC %in% coal,c("SCC","Emissions","year")],SCC[,c("SCC","EI.Sector")],by="SCC")

n <- length(years)*length(sectors)
df <- data.frame(year=integer(n), sector=character(n), Emissions=numeric(n), stringsAsFactors=FALSE)
i <- 1

for(y in seq_along(years)){
  for(s in seq_along(sectors)){
    df[i,] <- list(years[y], as.character(sectors[s]), sum(NEI_SCC$Emissions[NEI_SCC$year==years[y] & NEI_SCC$EI.Sector==sectors[s]]))
    i <- i + 1
  }
}

df.m <- melt(df, id.vars = c("year", "sector"))
names(df.m)[2] <- "EI.Sector"

g <- ggplot(df.m, aes(year, value, fill=EI.Sector)) + geom_area(position="stack")
g <- g + labs(title="PM2.5 Emissions from Coal Combustion", x="Year", y="PM2.5 Emissions (tons)")
g <- g + theme(plot.title = element_text(face="bold", vjust=1)) 
print(g)
ggsave("plot4.png")
