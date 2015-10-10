
# Manni Truong, 2015
# Exploratory Data

library(data.table)
library(dplyr)

current_dir <- dirname(parent.frame(2)$ofile)
setwd(current_dir)

# get data
if (!file.exists("household_power_consumption.txt")) {
    tmp <- tempfile()
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, tmp, mode = "wb")
    unzip(tmp, "household_power_consumption.txt")
}


# load, process and filter dataset
dt <- fread("household_power_consumption.txt", header = TRUE, stringsAsFactors = TRUE, sep = ";", na.strings = c("?", ""))
dt$Date <- as.Date(dt$Date, format = "%d/%m/%Y")
subset_dt <- filter(dt, Date >= "2007-02-01" & Date <= "2007-02-02")
subset_dt <- as.data.frame(subset_dt)
subset_dt$time_tmp <- paste(subset_dt$Date, subset_dt$Time)
subset_dt$Time <- strptime(subset_dt$time_tmp, format = "%Y-%m-%d %H:%M:%S")

# make plot
png("plot1.png", width = 480, height = 480)
hist(subset_dt$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()


