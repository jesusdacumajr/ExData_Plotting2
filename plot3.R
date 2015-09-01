SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")
## fips: A five-digit number (represented as a string) indicating the U.S. county
## SCC: The name of the source as indicated by a digit string (see source code classification table)
## Pollutant: A string indicating the pollutant
## Emissions: Amount of PM2.5 emitted, in tons
## type: The type of source (point, non-point, on-road, or non-road)
## year: The year of emissions recorded

library(ggplot2)

years <- unique(NEI$year)
types <- unique(NEI$type)
MD <- 24510 # FIPS code for Baltimore City, MD

n <- length(years)*length(types)
df <- data.frame(year=integer(n), type=character(n), Emissions=numeric(n), stringsAsFactors=FALSE)
i <- 1

for(y in seq_along(years)){
  for(t in seq_along(types)){
    df[i,] <- list(years[y], types[t], sum(NEI$Emissions[NEI$fips==MD & NEI$year==years[y] & NEI$type==types[t]]))
    i <- i + 1
  }
}

g <- ggplot(df, aes(year, Emissions))
p <- g + geom_point(color="purple", size=4, shape=21, fill="white") + geom_line() + facet_grid(. ~ type)
p <- p + labs(title="PM2.5 Emissions in Baltimore City, MD by Type", x="Year", y="PM2.5 Emissions (tons)")
p <- p + theme(plot.title = element_text(face="bold", vjust=1)) 
print(p)
ggsave("plot3.png")