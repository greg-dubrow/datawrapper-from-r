# Download and install (once only):
# Load the package into library (needed in every R session):
library(rdwd)

# select a dataset (e.g. last year's daily climate data from Potsdam city):
link <- selectDWD("Potsdam", res="daily", var="kl", per="recent")

# Actually download that dataset, returning the local storage file name:
file <- dataDWD(link, read=FALSE)
# Read the file from the zip folder:
clim <- readDWD(file, varnames=TRUE) # can happen directly in dataDWD

# Inspect the data.frame:
str(clim)
# Quick time series graphic:
plotDWD(clim, "FM.Windgeschwindigkeit")


## code from function script
cities_data <- selectDWD(name, res='daily', var='kl', per='recent')

selectDWD()
freiburg <- selectDWD("Freiburg", res="daily", var="kl", per="recent")
frfile <- dataDWD(freiburg, read = FALSE)
# dir = "~/Data/r/datawrapper from r/data",
climfr <- readDWD(frfile, varnames = TRUE)
plotDWD(climfr, "FM.Windgeschwindigkeit")

link <- selectDWD("Potsdam", res="daily", var="kl", per="recent")

# Actually download that dataset, returning the local storage file name:
file <- dataDWD(link, read=FALSE)
# Read the file from the zip folder:
clim <- readDWD(file, varnames=TRUE) # can happen directly in dataDWD
glimpse(clim)

subset_clim <- clim[, c("MESS_DATUM", "TXK.Lufttemperatur_Max", "TNK.Lufttemperatur_Min")]
names(subset_clim)[names(subset_clim) == "TXK.Lufttemperatur_Max"] <- "Max"
names(subset_clim)[names(subset_clim) == "TNK.Lufttemperatur_Min"] <- "Min"
