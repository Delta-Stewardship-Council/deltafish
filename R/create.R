#' Create fish database with file option
#'
#' Main function code to create the arrow dataset. Can look for data
#' locally or on EDI. Only used to generate the datasets in a local cache.
#' 
#' @param data_dir Directory to read data from
#' @param cache_dir Directory to cache data into
#' @import arrow
#' @return NULL
#' @noRd

create_fish_db_f <- function(data_dir, cache_dir){
    
    # set timeout to something high
    timeout <- getOption('timeout')
    options(timeout = 3600)
    
    #Fixing R CMD check issue with global variable binding:
    res_fish <- NULL
    
    
    # set up cache
    if (!(dir.exists(rappdirs::user_cache_dir(cache_dir)))){
        dir.create(rappdirs::user_cache_dir(cache_dir), recursive = TRUE)
    } else if (dir.exists(rappdirs::user_cache_dir(cache_dir)) &
               length(dir(rappdirs::user_cache_dir(cache_dir), recursive = TRUE) > 0)){
        message("Fish db already exists in cache directory")
        return(rappdirs::user_cache_dir(cache_dir))
    }
    
    # download dataif no data_dir is set
    if (is.null(data_dir)){ 
        #TODO: set up version checking for these URIs
        
        binary_loc <- "https://portal.edirepository.org/nis/dataviewer?packageid=edi.1075.1&entityid=926f4aa8484f185b69bc1827fa67d40c"
        
        # fish
        message("Downloading and writing fish data (~5 GB)")
        # download
        fish_dest <- file.path(tempdir(), "fishsurvey_compressed.rda")
        t <- utils::download.file(binary_loc, mode="wb", method="curl", destfile = fish_dest)
        # read
        load(fish_dest)
        
        
        length_loc <- "https://portal.edirepository.org/nis/dataviewer?packageid=edi.1075.1&entityid=2933237df1902243b4307f082bdc7d18"
        # download
        utils::download.file(length_loc, mode="wb", method="curl", destfile=file.path(tempdir(), "legth_conv.csv"))
        # read
        lconv <- readr::read_csv(file.path(tempdir(), "legth_conv.csv"), progress = FALSE, show_col_types = FALSE)
        
    } else if (!is.null(data_dir)){
        
        if (!all(c("length_conv.csv", "fishsurvey_compressed.rda") %in% dir(data_dir))){
            stop("Data directory must contain both length_conv.csv and fishsurvey_compressed.rda.")
        }
        
        load(file.path(data_dir, "fishsurvey_compressed.rda"))
        lconv <- readr::read_csv(file.path(data_dir, "length_conv.csv"), progress = FALSE, show_col_types = FALSE)
        
    }
    # write
    arrow::write_dataset(res_fish, file.path(rappdirs::user_cache_dir(cache_dir), "fish"), partitioning = "Taxa")
    
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
    arrow::write_dataset(surv, file.path(rappdirs::user_cache_dir(cache_dir), "survey"), partitioning = "Source", existing_data_behavior = "overwrite")
    
    # length conversion
    
   
    # write
    arrow::write_dataset(lconv, file.path(rappdirs::user_cache_dir(cache_dir), "length_conversion"))
    
    # reset timeout
    options(timeout = timeout)
    gc()
    
    return(rappdirs::user_cache_dir(cache_dir))
}






#' Create fish database
#'
#' Function to create the arrow dataset. Reads in raw data from the
#' published [EDI dataset](https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier=1075&revision=1).
#' 
#' @import arrow
#' @return NULL
#' @export
#'

create_fish_db <- function(){
   
    create_fish_db_f(data_dir = NULL, cache_dir = "deltafish") 
   
}



