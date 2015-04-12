download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', destfile='temp.zip')
unzip('temp.zip', exdir='household_power_consumption.txt')

file <- 'household_power_consumption.txt'
myData <- read.csv.sql(file, sql='select * from file where Date="1/2/2007" or Date="2/2/2007"', sep=';') #Query loads only data from the selected dates into the myData df
closeAllConnections() #close connection from sqldf

myData$Time <- paste(myData$Date, myData$Time) # the next 2 lines of code converts the class of the Time variable from 'character 
myData$Time <- strptime(myData$Time, '%d/%m/%Y %H:%M:%S')

#code to construct the actual plot is below

with(myData, plot(Time, Sub_metering_1, type='l', ylab='Energy sub metering'))
points(myData$Time, myData$Sub_metering_2, type='l', col='red')
points(myData$Time, myData$Sub_metering_3, type='l', col='blue')
legend('topright', pch='____', col=c('black','red','blue'), legend=c('sub-metering 1','sub-metering 2', 'sub-metering 3'))

dev.copy(png, file='plot3.png')
dev.off()