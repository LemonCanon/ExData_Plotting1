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
#png(filename = "filename.png", width = 480, height = 480, units = "px") ##open png device
#produce the plots

#dev.off() ## close png device