
### The Agricultural Model Intercomparison and Improvement Project ####
### AgMIP Regional Integrated Assessments: CTWN Sensitivity Analysis ##

# This routine is structured to produce line plots and boxplots related to a linear factor analysis, intended to explore crop, crop model, and site-specific sensitivities to chnages in carbon dioxide concentration, temperature, water/precipitation, and nitrogen applications. The routine should and can be used by all RRTs in their sensitivity investigations, particularly related to Phase 2 of the DFID-funded regional integrated assessments

# Created: May 19, 2015
# Author: Sonali McDermid, sps246@nyu.edu
# Routines are not gauranteed, and any help questions should be directed to the author

#----------------------Start Routine-------------------------#

# Definitions
ctwn<-function(fileDir,whichplot,pdfoutput) {
years <-c(1980:2009) # Assume 30 years (1980-2009) for all sensitivity tests
co2 <- c(360,450,540,630,720)
Tmaxmin <- c(-2,0,2,4,6,8)
Rainfall <- c(25,50,75,100,125,150,175,200)
Fertilizer <- c(0,30,60,90,120,150,180,210)
DSSATsens <- matrix(0, 30, 32) # Create placeholder matrix, to speed things up. 
APSIMsens <- matrix(0, 30, 32) # Create placeholder matrix, to speed things up.
Infosens <- matrix(0, 30, 32) # Create placeholder matrix, to speed things up.

# List all ACMO files
files <- list.files(path=fileDir,pattern=".csv", full.names=T, recursive=FALSE)

# Find the models associated with each ACMO file (only considering 3 for now, but more can be added)

	# Find APSIM
for(d in 1:length(files)) {
if(grepl("APSIM", files[d])) {
print("found")
APSIM <- read.csv(file=files[d],skip = 2, head=TRUE,sep=",")
	# If APSIM ACMO exists, then extract the 30 years x 32 Linear Factor Analysis Sensitivity Tests for yield, or other variable of interest. Here is where we can change the dependent variable (see "HWAH" below)
    
#Extract Meta data
Exname<-APSIM$EXNAME[1]
#Exname<-unlist(strsplit(APSIM$EXNAME[1],"_"))
Cropname<-APSIM$CRID_text[1]
#****************************

for (i in 1:32) {
APSIMsens[,i] <- APSIM$HWAH_S[(1+30*(i-1)):(30+30*(i-1))] 
}}
	# Finish looping, and print done. If "done" is reached without a "found", then model doesn't exist.
else {print("done")}
}

	# Find DSSAT
for(d in 1:length(files)) {
if(grepl("DSSAT", files[d])) {
print("found")
DSSAT <- read.csv(file=files[d],skip = 2, head=TRUE,sep=",")
	# If DSSAT ACMO exists, then extract the 30 years x 32 Linear Factor Analysis Sensitivity Tests for yield, or other variable of interest. Here is where we can change the dependent variable (see "HWAH" below)
for (i in 1:32) {
DSSATsens[,i] <- DSSAT$HWAH_S[(1+30*(i-1)):(30+30*(i-1))] 
}}
	# Finish looping, and print done. If "done" is reached without a "found", then model doesn't exist.
else {print("done")}
}

	# Find Infocrop
for(d in 1:length(files)) {
if(grepl("Info", files[d])) {
print("found")
Info <- read.csv(file=files[d],skip = 2, head=TRUE,sep=",")
	# If Infocrop ACMO exists, then extract the 30 years x 32 Linear Factor Analysis Sensitivity Tests for yield, or other variable of interest. Here is where we can change the dependent variable (see "HWAH" below)
for (i in 1:32) {
Infosens[,i] <- Info$HWAH_S[(1+30*(i-1)):(30+30*(i-1))] 
}}
	# Finish looping, and print done. If "done" is reached without a "found", then model doesn't exist.
else {print("done")}
}

if (whichplot=="l"){
#___________________________________________#
###### Lineplots of Linear Factor Analysis #######
pdf(pdfoutput,width=4,height=20)
attach(mtcars)
par(mfrow=c(5,1),oma=c(0,0,2,0))
#CO2 at 30 N________________________
model <- DSSATsens # Change the model of interest here

#pdf('CO2 Sensitivity at N=30kg-ha.pdf')
plot(0,xlim=c(1980,2009),ylim=c(min(model[,1:5]),max(model[,1:5])),type="n",xlab="Years",ylab="Yields")
matlines(years, model[,1:5], type = "l", lty = 1:5, lwd = 1, pch = NULL,
          col = 1:5, xlab="Years", ylab="Yield")
          
legend("topright", title="CO2 Sensitivity at N=30kg/ha", cex=0.75, pch=16, col=1:5, legend=c("360ppm", "450ppm","540ppm","630ppm","720ppm"), ncol=2)
#dev.off()

#CO2 at 180 N________________________
model <- DSSATsens # Change the model of interest here

#pdf('CO2 Sensitivity at N=180kg-ha.pdf')
plot(0,xlim=c(1980,2009),ylim=c(min(model[,6:10]),max(model[,6:10])),type="n",xlab="Years",ylab="Yields")
matlines(years, model[,6:10], type = "l", lty = 1:5, lwd = 1, pch = NULL,
          col = 1:5, xlab="Years", ylab="Yield")
          
legend("topright", title="CO2 Sensitivity at N=180kg/ha", cex=0.75, pch=16, col=1:5, legend=c("360ppm", "450ppm","540ppm","630ppm","720ppm"), ncol=2)
#dev.off()

#Tmax/Tmin________________________ 
model <- DSSATsens # Change the model of interest here


#pdf('TmaxTmin Sensitivity.pdf')
plot(0,xlim=c(1980,2009),ylim=c(min(model[,11:16]),max(model[,11:16])),type="n",xlab="Years",ylab="Yields")
matlines(years, model[,11:16], type = "l", lty = 1:6, lwd = 1, pch = NULL,
          col = 1:6, xlab="Years", ylab="Yield")
          
legend("topright", title="TmaxTmin Sensitivity", cex=0.75, pch=16, col=1:6, legend=c("-2˚C", "0","","+2˚C","+4˚C","+6˚C","+8˚C"), ncol=2)

#dev.off()

#Rainfall________________________ 
model <- DSSATsens # Change the model of interest here

#pdf('Rainfall Sensitivity.pdf')
plot(0,xlim=c(1980,2009),ylim=c(min(model[,17:24]),max(model[,17:24])),type="n",xlab="Years",ylab="Yields")
matlines(years, model[,17:24], type = "l", lty = 1:8, lwd = 1, pch = NULL,
          col = 1:8, xlab="Years", ylab="Yield")
          
legend("topright", title="Rainfall Sensitivity", cex=0.75, pch=16, col=1:8, legend=c("25%","50%","75%","100%","125%","150%","175%","200%"), ncol=2)
#dev.off()

#Fertilizer (N)________________________
model <- DSSATsens # Change the model of interest here

#pdf('Fertilizer Sensitivity.pdf')
plot(0,xlim=c(1980,2009),ylim=c(min(model[,25:32]),max(model[,25:32])),type="n",xlab="Years",ylab="Yields")
matlines(years, model[,25:32], type = "l", lty = 1:8, lwd = 1, pch = NULL,
          col = 1:8, xlab="Years", ylab="Yield")
          
legend("topright", title="Fertilizer Sensitivity (kg/ha)", cex=0.75, pch=16, col=1:8, legend=c("0","30","60","90","120","150","180","210"), ncol=2)

#Add the title of meta data
mtext(paste(Cropname," Yield Sensitivity in ",Exname,sep=""),outer=TRUE,cex=0.9)
#********************
dev.off()
}
#___________________________________________#
###### Boxplots of Linear Factor Analysis #######
if (whichplot=="b"){
# Create a matrix of alternating model results

# Two model matrix - "multimod" is our placeholder matrix here (will make routine run faster)
 multimod <- matrix(0,30,64)
 cols1 <- seq(1, by = 2, len = 32) # Want to list the same experiments from different models next to each other, e.g. DSSAT Test 1, APSIM Test 1, DSSAT Test 2, APSIM Test 2,. . .
 cols2 <- seq(2, by = 2, len = 32)
 multimod[,cols1] <- DSSATsens # Fill in models of interest here
 multimod[,cols2] <- APSIMsens # Fill in models of interest here

# Three model matrix
 # multimod <- matrix(0,30,96)
 # cols1 <- seq(1, by = 3, len = 96)
 # cols2 <- seq(2, by = 3, len = 96)
 # cols3 <- seq(3, by = 3, len = 96)
 # multimod[,cols1] <- DSSATsens # Fill in models of interest here
 # multimod[,cols2] <- APSIMsens # Fill in models of interest here
 # multimod[,cols3] <- INFOsens # Fill in models of interest here

#CO2 at 30 N________________________

pdf(pdfoutput,width=4,height=20)
attach(mtcars)
par(mfrow=c(5,1),oma=c(0,0,2,0))
#pdf('Boxplot CO2 Sensitivity at N=30kg-ha.pdf')
boxplot(multimod[,1:10], ylab = "Yield", xlab = "CO2 Level (ppm)", las = 2, col = c("red","sienna","red","sienna","red","sienna","red","sienna","red","sienna"), at=c(1,2, 4,5, 7,8, 10,11, 13,14), names=c("360"," ","450"," ","540"," ","630"," ","720"," "))
legend("topright", title="CO2 Sensitivity at N=30kg/ha", cex=0.75, pch=16, col=c("red","sienna"), legend=c("DSSAT", "APSIM"), ncol=2)
# Plot means on top of boxplots
points(c(1,2, 4,5, 7,8, 10,11, 13,14), colMeans(multimod[,1:10]), pch = 22, col = "darkgrey", lwd = 7)
#dev.off()

#CO2 at 180 N________________________

#pdf('Boxplot CO2 Sensitivity at N=180kg-ha.pdf')
boxplot(multimod[,11:20], ylab = "Yield", xlab = "CO2 Level (ppm)", las = 2, col = c("red","sienna","red","sienna","red","sienna","red","sienna","red","sienna"), at=c(1,2, 4,5, 7,8, 10,11, 13,14), names=c("360"," ","450"," ","540"," ","630"," ","720"," "))
legend("topright", title="CO2 Sensitivity at N=180kg/ha", cex=0.75, pch=16, col=c("red","sienna"), legend=c("DSSAT", "APSIM"), ncol=2)
# Plot means on top of boxplots
points(c(1,2, 4,5, 7,8, 10,11, 13,14), colMeans(multimod[,11:20]), pch = 22, col = "darkgrey", lwd = 7)
#dev.off()

#Tmax/Tmin________________________

#pdf('Boxplot TmaxTmin Sensitivity.pdf')
boxplot(multimod[,21:32], ylab = "Yield", xlab = expression(paste("TmaxTmin Change (", degree,"C)",sep="")), las = 2, col = c("red","sienna","red","sienna","red","sienna","red","sienna","red","sienna","red","sienna"), at=c(1,2, 4,5, 7,8, 10,11, 13,14, 16,17), names=c("-2"," ","0"," ","+2"," ","+4"," ","+6"," ","+8"," "))
legend("topright", title="TmaxTmin Sensitivity", cex=0.75, pch=16, col=c("red","sienna"), legend=c("DSSAT", "APSIM"), ncol=2)
# Plot means on top of boxplots
points(c(1,2, 4,5, 7,8, 10,11, 13,14, 16,17), colMeans(multimod[,21:32]), pch = 22, col = "darkgrey", lwd = 7)
#dev.off()

#Rainfall________________________ 

#pdf('Boxplot Rainfall Sensitivity.pdf')
boxplot(multimod[,33:48], ylab = "Yield", xlab = "Rainfall Change (%)", las = 2, col = c("red","sienna","red","sienna","red","sienna","red","sienna","red","sienna","red","sienna","red","sienna","red","sienna"), at=c(1,2, 4,5, 7,8, 10,11, 13,14, 16,17, 19,20, 22,23), names=c("25"," ","50"," ","75"," ","100"," ","125"," ","150"," ","175"," ","200"," "))
legend("topright", title="Rainfall Sensitivity", cex=0.75, pch=16, col=c("red","sienna"), legend=c("DSSAT", "APSIM"), ncol=2)
# Plot means on top of boxplots
points(c(1,2, 4,5, 7,8, 10,11, 13,14, 16,17, 19,20, 22,23), colMeans(multimod[,33:48]), pch = 22, col = "darkgrey", lwd = 7)
#dev.off()

#Fertilizer (N)________________________

#pdf('Boxplot Fertilizer Sensitivity.pdf')
boxplot(multimod[,49:64], ylab = "Yield", xlab = "Fertilizer Application (kg/ha)", las = 2, col = c("red","sienna","red","sienna","red","sienna","red","sienna","red","sienna","red","sienna","red","sienna","red","sienna"), at=c(1,2, 4,5, 7,8, 10,11, 13,14, 16,17, 19,20, 22,23), names=c("0"," ","30"," ","60"," ","90"," ","120"," ","150"," ","180"," ","210"," "))
legend("topright", title="N Sensitivity", cex=0.75, pch=16, col=c("red","sienna"), legend=c("DSSAT", "APSIM"), ncol=2)
# Plot means on top of boxplots
points(c(1,2, 4,5, 7,8, 10,11, 13,14, 16,17, 19,20, 22,23), colMeans(multimod[,49:64]), pch = 22, col = "darkgrey", lwd = 7)

#Add the title of meta data
mtext(paste(Cropname," Yield Sensitivity in ",Exname,sep=""),outer=TRUE,cex=0.9)
#********************

dev.off()
}
}

args<-commandArgs(trailingOnly=TRUE)
fileDir<-args[1]
whichplot<-args[2]
pdfoutput<-args[3]
ctwn(fileDir,whichplot,pdfoutput)
