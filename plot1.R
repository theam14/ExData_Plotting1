# Script used to plot into a png file, named 'plot1.png' the Plot 1
# described at the project 1 assignment, for Exploratory Data Analysis Course.

source('run_plot.R');

# Load Data
data <- loadData();

# Perform a plot at the PNG file 'plot1.png'
png("plot1.png");
runPlot1(data); 
dev.off();