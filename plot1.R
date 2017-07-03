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

png("plot1.png", width=480, height=480)

with(electric, hist(Global_active_power, col = "red",
                    xlab = "Global Active Power (kilowatts)",
                    main = "Global Active Power")
)

dev.off()