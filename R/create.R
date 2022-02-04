#' Create fish database
#'
#' Function to create the arrow dataset. Currently hard coded
#' to look at data stored on the KNB. Eventually will look for data
#' on EDI. Only used to generate the datasets in a local cache.
#' 
#' @import arrow
#' @return NULL
#' @export
#'

create_fish_db <- function(){
    
    # set timeout to something high
    timeout <- getOption('timeout')
    options(timeout = 3600)
    
    #Fixing R CMD check issue with global variable binding:
    res_fish<-NULL

    
    # set up cache
    if (!(dir.exists(rappdirs::user_cache_dir("deltafish")))){
        dir.create(rappdirs::user_cache_dir("deltafish"), recursive = TRUE)
    } else if (dir.exists(rappdirs::user_cache_dir("deltafish")) &
                          length(dir(rappdirs::user_cache_dir("deltafish"), recursive = TRUE) > 0)){
        message("Fish db already exists in cache.")
        return(rappdirs::user_cache_dir("deltafish"))
    }
    
    #TODO: set up version checking for these URIs
    
    binary_url <- "https://portal-s.edirepository.org/nis/dataviewer?packageid=edi.746.1&entityid=926f4aa8484f185b69bc1827fa67d40c"
    length_url <- "https://portal-s.edirepository.org/nis/dataviewer?packageid=edi.746.1&entityid=2933237df1902243b4307f082bdc7d18"
    
    # fish
    message("Downloading and writing fish data (~5 GB)")
    # download
    utils::download.file(binary_url, mode="wb", method="curl", destfile=file.path(tempdir(), "fishsurvey_compressed.rds"))
    # read
    load(file.path(tempdir(), "fishsurvey_compressed.rds"))
    # write
    arrow::write_dataset(res_fish, file.path(rappdirs::user_cache_dir("deltafish"), "fish"), partitioning = "Taxa")
    
    # clean up environment to save memory
    rm(res_fish)
    gc()
    
    res_survey$Date <- as.character(res_survey$Date)
    res_survey$Datetime <- as.character(res_survey$Datetime)
    
    s <- arrow::schema(Source = arrow::string(),
                       Station = arrow::string(),
                       Latitude = arrow::float(),     
                       Longitude = arrow::float(),
                       Date = arrow::string(),
                       Datetime = arrow::string(),
                       Survey  = arrow::int64(),
                       Depth  = arrow::float(),
                       SampleID  = arrow::large_utf8(),
                       Method  = arrow::string(),
                       Tide   = arrow::string(),
                       Sal_surf   = arrow::float(),
                       Sal_bot   = arrow::float(),
                       Temp_surf = arrow::float(),
                       Secchi = arrow::float(),
                       Secchi_estimated = arrow::boolean(),
                       Tow_duration = arrow::float(),
                       Tow_area  = arrow::float(),
                       Tow_volume =arrow::float(),
                       Cable_length = arrow::float(),
                       Tow_direction = arrow::string(),
                       Notes_tow = arrow::string(),
                       Notes_flowmeter = arrow::string())
    
    
    surv <- arrow::arrow_table(res_survey, schema = s)
    arrow::write_dataset(surv, file.path(rappdirs::user_cache_dir("deltafish"), "survey"), partitioning = "Source", existing_data_behavior = "overwrite")
    
    # length conversion
    
    # download
    utils::download.file(length_url, mode="wb", method="curl", destfile=file.path(tempdir(), "legth_conv.csv"))
    
    # read
    lconv <- readr::read_csv(file.path(tempdir(), "legth_conv.csv"), progress = FALSE, show_col_types = FALSE)
    
    # write
    arrow::write_dataset(lconv, file.path(rappdirs::user_cache_dir("deltafish"), "length_conversion"))

    # reset timeout
    options(timeout = timeout)
    gc()
    
    return(rappdirs::user_cache_dir("deltafish"))
}



