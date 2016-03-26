# RP March 23 2016 for 
#base script for plots 1-4

this.dir <- dirname(parent.frame(2)$ofile) ##Gabor Grothendieck answered the following to a related question on r-help today:
setwd(this.dir)

library(dplyr)

#read data file from with the dates 2007-02-01 to 2007-02-02 into the script.
#if the data does not exist in the global environment it will read the data from
#the online source.
if(!exists("HouseholdPower", .GlobalEnv)){
	if(!file.exists("household_power_consumption.txt")){
		#download and unzip data into the wd
		dbdir <- paste0(getwd(),"database.zip")
		download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", dbdir)
		unzip(dbdir, exdir = paste0(getwd()))
	}
    #read file into global environment
    HouseholdPower <- read.table("household_power_consumption.txt", 
                       sep = ";", 
                       na.strings = "?", 
                       skip = 66637, ##obtained manually from testing the database
                       nrows = 2880
                       )
    titles <- read.table("household_power_consumption.txt", nrows = 1, sep = ";", header = TRUE)
    names(HouseholdPower) <- tolower(names(titles)) 
    datetime <- paste(HouseholdPower[,"date"],HouseholdPower[,"time"])
    HouseholdPower[,"date"] <- as.POSIXct(strptime(datetime, "%d/%m/%Y %H:%M:%S"))
    HouseholdPower <- select(HouseholdPower, -(time))
    rm(titles)
}

png(filename = "plot4.png", width = 480, height = 480, units = "px") ##open png device

#produce the plots


par(mfrow = c(2,2), mar = c(4,4,1,2))

#plot 1,1
{
with(
    HouseholdPower, 
    plot(
        date,
        global_active_power,
        type = "l",
        ylab = "Global Active Power (kilowatts)",
        xlab = ""
    )
)
}
#plot 1,2
{
with(HouseholdPower, 
     plot(
         date,
         voltage,
         type = "l",
         ylab = "Voltage",
         xlab = "datetime"
        )
    )
}
#plot 2,1
{
with(
    HouseholdPower, 
    plot(
        date,
        sub_metering_1,
        type = "l",
        ylab = "Energy sub metering",
        xlab = ""
        )
    )
with(
    HouseholdPower,
    lines(
        date,
        sub_metering_2,
        col = "red"
        )
    )
with(
    HouseholdPower,
    lines(
        date,
        sub_metering_3,
        col = "blue"
    )
)
legend("topright",
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = c(1,1,1),
       col = c("black","red","blue"),
       bty = "n",
       cex = .65
       )
}
#plot 2,2
{
 with(
     HouseholdPower,
     plot(
         date,
         global_reactive_power,
         type = "l",
         xlab = "datetime",
         ylab = "Global_reactive_power"
         
        )
    )
}

dev.off() ## close png device


