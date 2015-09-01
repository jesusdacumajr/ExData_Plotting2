SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")

mobile <- SCC$SCC[grep("*Vehicles", SCC$EI.Sector)]
sectors <- unique(SCC$EI.Sector[grep("*Vehicles", SCC$EI.Sector)])
years <- unique(NEI$year)
MD <- 24510 # FIPS code for Baltimore City, MD

NEI_SCC <- merge(NEI[NEI$fips==MD & NEI$SCC %in% mobile,c("SCC","Emissions","year")],SCC[,c("SCC","EI.Sector")],by="SCC")

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
g <- g + labs(title="PM2.5 Emissions from Motor Vehicles in Baltimore City, MD", x="Year", y="PM2.5 Emissions (tons)")
g <- g + theme(plot.title = element_text(face="bold", vjust=1)) 
print(g)
ggsave("plot5.png")