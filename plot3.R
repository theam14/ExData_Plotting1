# Script used to plot into a png file, named 'plot3.png' the Plot 2
# described at the project 1 assignment, for Exploratory Data Analysis Course.

source('run_plot.R');

# Load Data
data <- loadData();

# Perform a plot at the PNG file 'plot3.png'
png("plot3.png");
runPlot3(data); 
dev.off();