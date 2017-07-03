library(tidyverse)
library(tidyquant)
library(modelr)
library(gridExtra)
library(grid)

inputFolder <- paste(getwd(), "R/Input", sep = "/")
inputFile <- file.path(inputFolder, "household_power_consumption.txt")

electric <- read_delim(inputFile, delim = ";",
                       col_types = cols(
                         Date = col_date("%d/%m/%Y"),
                         Time = col_time("%H:%M:%S"),
                         Global_active_power = col_double(),
                         Global_reactive_power = col_double(),
                         Voltage = col_double(),
                         Global_intensity = col_double(),
                         Sub_metering_1 = col_double(),
                         Sub_metering_2 = col_double(),
                         Sub_metering_3 = col_double()
                       )
) %>% 
  mutate(day = parse_date(format(Date, "%Y/%m/%d")),
         day_of_week = wday(day, label = TRUE),
         month = format(Date, "%m"),
         year = format(Date, "%Ylink"),
         date_with_time = paste(day, Time, sep = " "),
         date_with_time = col_datetime("%Y-%m-%d %H:%M:%S")) %>% 
  filter(Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))

png("plot4.png", width=480, height=480)

par(mfrow = c(2,2))

with(electric, plot(date_with_time, Global_active_power,
                    type = "l", xlab = "",
                    ylab = "Global Active Power",
                    cex = 0.2))

with(electric, plot(date_with_time, Voltage, 
                    type = "l", xlab = "datetime",
                    ylab = "Voltage"))

with(electric, plot(date_with_time, as.numeric(Sub_metering_1),
                    type = "l", ylab = "Energy Submetering", xlab = ""))
with(electric, lines(date_with_time, as.numeric(Sub_metering_2),
                     type = "l", col = "red"))
with(electric, lines(date_with_time, as.numeric(Sub_metering_3),
                     type = "l", col = "blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty =, cex = 0.7, lwd = 2.5, col = c("black", "red", "blue"), bty = "n")

with(electric, plot(date_with_time, Global_reactive_power, type = "l",
                    xlab = "datetime", ylab = "Global_reactive_power"))

dev.off()