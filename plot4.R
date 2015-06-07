# Script used to plot into a png file, named 'plot4.png' the Plot 4
# described at the project 1 assignment, for Exploratory Data Analysis Course.

source('run_plot.R');

# Load Data
data <- loadData();

# Perform a plot at the PNG file 'plot4.png'
png("plot4.png");
runPlot4(data); 
dev.off();