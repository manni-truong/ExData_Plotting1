
# Manni Truong, 2015
# Exploratory Data

library(data.table)
library(dplyr)

# set current working dir to where script lives
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
subset_dt$time_tmp <- paste(subset_dt$Date, subset_dt$Time)
subset_dt <- as.data.frame(subset_dt)
subset_dt$Time <- strptime(subset_dt$time_tmp, format = "%Y-%m-%d %H:%M:%S")

# plotting
png("plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))

# top left
plot(subset_dt$Time, subset_dt$Global_active_power, type = "n", xlab = "", ylab = "Global Active Power")
lines(subset_dt$Time, subset_dt$Global_active_power)

# top right
plot(subset_dt$Time, subset_dt$Voltage, type = "n", xlab = "datetime", ylab = "Voltage")
lines(subset_dt$Time, subset_dt$Voltage)

# bottom left
plot(subset_dt$Time, subset_dt$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
lines(subset_dt$Time, subset_dt$Sub_metering_1, col = "black")
lines(subset_dt$Time, subset_dt$Sub_metering_2, col = "red")
lines(subset_dt$Time, subset_dt$Sub_metering_3, col = "blue")
legend("topright", lty = 1, col = c("black","red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")

# bottom right
plot(subset_dt$Time, subset_dt$Global_reactive_power, type = "n", xlab = "datetime", ylab = "Global_reactive_power")
lines(subset_dt$Time, subset_dt$Global_reactive_power)

dev.off()
