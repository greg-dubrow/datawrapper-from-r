# from datawrapper webinar on r package to API
   # https://streamyard.com/watch/pSFPmcuypfXK

# API developer guide https://developer.datawrapper.de/docs/chart-types
#install.packages("rdwd")

#API token
# JStvQJdZuDDdkSWAtyPxzTNjkCajhXS5Ev2XTFNUoyAC0mTTR5Km5UVbJOI04M6g
#Sys.setenv(DW_KEY = "JStvQJdZuDDdkSWAtyPxzTNjkCajhXS5Ev2XTFNUoyAC0mTTR5Km5UVbJOI04M6g")

library(DatawRappr)
library(rdwd)
library(tidyverse)

datawrapper_auth(api_key = Sys.getenv("DW_KEY"), overwrite = TRUE)

dw_test_key()
dw_list_folders()

# create folder ONLY DO THIS IF A NEW FOLDER NEEDED USE 27618 in API calls for now
folder <- dw_create_folder(name = "API charts from r")
# save folder ID  271618
folder_id <- folder[["id"]]


## create function for weather line chart
create_line_chart <- function(city) {

  # set folder id
  folder_id = 271618

  # load clean & prep data
  # recent is data for the last year
  cities_data <- selectDWD(city, res='daily', var='kl', per='recent')

  # download dataet
  file <- dataDWD(cities_data, read = FALSE)

  # read file from zip folder
  clim <- readDWD(file, varnames = TRUE)

  # clean data
  subset_clim <- clim[, c("MESS_DATUM", "TXK.Lufttemperatur_Max", "TNK.Lufttemperatur_Min")]
  names(subset_clim)[names(subset_clim) == "TXK.Lufttemperatur_Max"] <- "Max"
  names(subset_clim)[names(subset_clim) == "TNK.Lufttemperatur_Min"] <- "Min"

  # create chart folder id = 271618
  # see https://developer.datawrapper.de/docs/chart-types for chart codes
  line <- dw_create_chart(
    folderId = 271618,
    type = "d3-lines"
  )

  line_id <- line[["content"]][["publicId"]]

  # pass data to chart
  dw_data_to_chart(
    subset_clim,
    chart_id = line_id
  )

  dw_edit_chart(
    chart_id = line_id,
    folder_id = folder_id,

    title = sprintf('Daily temperatures in %s', city),
    intro = "Daily temps in Celsius",
    byline = "GKD",

    annotate = sprintf('Chart updated on %s', format(Sys.time(), '%a %b %d %X %Y')),

    describe = list(
      'source-name' = 'German Weather Service (DWD)',
      'source-url' = 'https://bookdown.org/brry/rdwd/'),

    visualize = list(
      'custom-colors' = list(
        'Max' = 'gold', 'Min' = 'blue'),

      'line-widths' = list(
        'Max' = 3, 'Min' = 3),

      'labeling' = 'top',

      'custom-area-fills' = list(
        list(
          'from' = 'Max', 'to' = 'Min',
          'color' = "#ddd", 'opacity' = 0.3)))
  )

  dw_publish_chart(
    chart_id = line_id,
    return_urls = TRUE)
}

create_line_chart("Freiburg")


## do multiple charts

city_list <- list('Potsdam', "Berlin Brandenburg", "Frankfurt/Main")

for (i in city_list) {
  create_line_chart(i)
}
