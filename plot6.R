SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")
## fips: A five-digit number (represented as a string) indicating the U.S. county
## SCC: The name of the source as indicated by a digit string (see source code classification table)
## Pollutant: A string indicating the pollutant
## Emissions: Amount of PM2.5 emitted, in tons
## type: The type of source (point, non-point, on-road, or non-road)
## year: The year of emissions recorded

library(ggplot2)

mobile <- SCC$SCC[grep("*Vehicles", SCC$EI.Sector)]
years <- unique(NEI$year)
MD <- "24510" # FIPS code for Baltimore City, MD
LA <- "06037" # FIPS code for Los Angeles County, CA

n <- length(years)*2
df <- data.frame(year=integer(n), location=character(n), Emissions=numeric(n), stringsAsFactors=FALSE)
i <- 1

for(y in seq_along(years)){
  df[i,] <- list(years[y], "Baltimore City, MD", sum(NEI$Emissions[NEI$fips==MD & NEI$year==years[y] & (NEI$SCC %in% mobile)]))
  df[i+1,] <- list(years[y], "Los Angeles County, CA", sum(NEI$Emissions[NEI$fips==LA & NEI$year==years[y] & (NEI$SCC %in% mobile)]))
  i <- i + 2
}

g <- ggplot(df, aes(year, Emissions))
p <- g + geom_point(color="red", size=4, shape=21, fill="white") + geom_line() + facet_grid(. ~ location)
p <- p + labs(title="PM2.5 Emissions from Motor Vehicles", x="Year", y="PM2.5 Emissions (tons)")
p <- p + theme(plot.title = element_text(face="bold", vjust=1)) 
print(p)
ggsave("plot6.png")