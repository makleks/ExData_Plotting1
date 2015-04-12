options(gsubfn.engine = "R") #required for proper functioning of sqldf library
library(sqldf) #load sqldf library 

download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', destfile='temp.zip')
unzip('temp.zip', exdir='household_power_consumption.txt')

file <- 'household_power_consumption.txt'
myData <- read.csv.sql(file, sql='select * from file where Date="1/2/2007" or Date="2/2/2007"', sep=';') #Query loads only data from the selected dates into the myData df
closeAllConnections() #close connection from sqldf

myData$Time <- paste(myData$Date, myData$Time) # the next 2 lines of code converts the class of the Time variable from 'character 
myData$Time <- strptime(myData$Time, '%d/%m/%Y %H:%M:%S')

#code to construct the actual plot is below

with(myData, plot(Time, Global_active_power, type='l', ylab='Globa Active Power(kilowatts)'))

dev.copy(png, file='plot2.png')
dev.off()