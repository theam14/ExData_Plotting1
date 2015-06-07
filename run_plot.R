# Script that presents the functions which are responsible to accomplish the 
# project 1 assignment, for Exploratory Data Analysis course.

# Main function, responsible by load data and generate the four image file, each
# one containing the corresponding plot, according to the project 1 assignment,
# presented in Exploratory Data Analysis course.
# defined by [initial_date final_date].
# @param[in] src_file Path to input data file - default: 'household_power_consumption.txt'
# @param[in] initial_date Initial date used to filter data - default: "2007-02-01"
# @param[in] initial_date Final date used to filter data - default: "2007-02-02"

runPlot <- function(src_file = "household_power_consumption.txt",
                    initial_date = as.Date('2007-02-01', tz = "UTC"),
                    final_date = as.Date('2007-02-02', tz = "UTC"))
{
    hh_power_cons_data <- loadData(src_file, initial_date, final_date);

    png("plot1.png");
    runPlot1(hh_power_cons_data); 
    dev.off();
    
    png("plot2.png");
    runPlot2(hh_power_cons_data); 
    dev.off();
    
    png("plot3.png");
    runPlot3(hh_power_cons_data); 
    dev.off();
    
    png("plot4.png");
    runPlot4(hh_power_cons_data); 
    dev.off();
    
    hh_power_cons_data    
}

# Perform the plot of image 'plot1.png'
# @param[in] data Data table containing the information used to perform the plot.
runPlot1 <- function(data)
{
    par(mar = c(4.5, 5, 1.5, 1));
    hist(data$Global_active_power, col = "red", 
         xlab = "Global Active Power (kilowatts)", 
         main = "Global Active Power");
}

# Perform the plot of image 'plot2.png'
# @param[in] data Data table containing the information used to perform the plot.
runPlot2 <- function(data)
{
    par(mar = c(4.5, 5, 1.5, 1));
    plot(data$DateTime, data$Global_active_power,
         type = "l", xlab = "", col = "black",
         ylab = "Global Active Power (kilowatts)");
}

# Perform the plot of image 'plot3.png'
# @param[in] data Data table containing the information used to perform the plot.
runPlot3 <- function(data)
{
    dataNames <- names(data);
    numNames <- length(dataNames);
    par(mar = c(4.5, 5, 1.5, 1));
    plot(data$DateTime, data$Sub_metering_1, col = "black", type = "l", 
         xlab = "", ylab = "Energy sub metering");
    points(data$DateTime, data$Sub_metering_2, col = "red", type = "l");
    points(data$DateTime, data$Sub_metering_3, col = "blue", type = "l");
    legend("topright", 
           legend = dataNames[ (numNames-3):(numNames-1) ], 
           col = c("black", "red", "blue"), lty = 1); 
}

# Perform the plot of image 'plot4.png'
# @param[in] data Data table containing the information used to perform the plot.
runPlot4 <- function(data)
{
    par(mar = c(5.5, 5, 1.5, 1), mfcol = c(2, 2));
    
    # Plot item 1-1
    plot(data$DateTime, data$Global_active_power,
         type = "l", xlab = "", col = "black",
         ylab = "Global Active Power");
    
    # Plot item 2-1
    dataNames <- names(data);
    numNames <- length(dataNames);
    plot(data$DateTime, data$Sub_metering_1, col = "black", type = "l", 
         xlab = "", ylab = "Energy sub metering");
    points(data$DateTime, data$Sub_metering_2, col = "red", type = "l");
    points(data$DateTime, data$Sub_metering_3, col = "blue", type = "l");
    legend("topright", 
           legend = dataNames[ (numNames-3):(numNames-1) ], 
           col = c("black", "red", "blue"), lty = 1, bty = "n");
    
    # Plot item 1-2
    plot(data$DateTime, data$Voltage,
         type = "l", xlab = "datetime", col = "black",
         ylab = "Voltage");
    
    # Plot item 2-2
    plot(data$DateTime, data$Global_reactive_power,
         type = "l", xlab = "datetime", col = "black",
         ylab = "Global_reactive_power");
}

# Load the data used to perform the plots. Only register with complete information
# (without NA's) are considered. The returned data is filtered in a period
# defined by [initial_date final_date].
# @param[in] src_file Path to input data file - default: 'household_power_consumption.txt'
# @param[in] initial_date Initial date used to filter data - default: "2007-02-01"
# @param[in] initial_date Final date used to filter data - default: "2007-02-02"
loadData <- function(src_file = "household_power_consumption.txt",
                    initial_date = as.Date("2007-02-01", tz = "UTC"),
                    final_date = as.Date("2007-02-02", tz = "UTC"))
{
    suppressPackageStartupMessages(library(data.table));    
    
    # Import data
    hh_power_cons <- fread(src_file, header = T, sep = ";", 
                           colClasses = "character", na.strings = c("?"));
    
    # Filter data between a given period that contains valid vlaues 
    # (different from NA)
    sub_set <- hh_power_cons[ 
                    ( is.na(Date) | as.Date(Date, "%d/%m/%Y", tz = "UTC") >= initial_date ) & 
                    ( is.na(Date) | as.Date(Date, "%d/%m/%Y", tz = "UTC") <= final_date ) & 
                    !is.na(Voltage) & !is.na(Global_active_power) & 
                    !is.na(Global_reactive_power) & !is.na(Sub_metering_1) & 
                    !is.na(Sub_metering_2) & !is.na(Sub_metering_3), ];
    
    # Transform the columns with values to numeric values 
    sub_set[, 3:ncol(sub_set)] <- sub_set[, lapply(.SD, as.numeric), 
                                          .SDcols = 3:ncol(sub_set)];
    
    # Create a new column containing the object date of each row, information
    # obtained through columns Date and Time
    sub_set[, DateTime := as.POSIXct(strptime(paste(Date, Time), 
                                              "%d/%m/%Y %H:%M:%S", tz = "UTC"))];
    
    sub_set
}