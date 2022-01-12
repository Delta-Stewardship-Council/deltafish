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
    
    # set up cache
    if (!(dir.exists(rappdirs::user_cache_dir("deltaFish")))){
        dir.create(rappdirs::user_cache_dir("deltaFish"))
    } else if (dir.exists(rappdirs::user_cache_dir("deltaFish")) &
                          length(dir(rappdirs::user_cache_dir("deltaFish"), recursive = TRUE) > 0)){
        message("Fish db already exists in cache.")
        return(rappdirs::user_cache_dir("deltaFish"))
    }
    
    fish_pid <- "urn%3Auuid%3A0b5697ac-ee44-42c6-90f3-799eb9e5970e"
    survey_pid <- "urn%3Auuid%3Ade32988a-99e9-4887-bb1f-1bd099314ada"
    l_pid <- "urn%3Auuid%3A0b0f4e85-23b4-423c-83d1-a9005c587b9f"
    base_url <- "https://knb.ecoinformatics.org/knb/d1/mn/v2/object/"
    
    surv <- utils::read.csv(paste0(base_url, survey_pid))
    fish <- readr::read_csv(paste0(base_url, fish_pid), progress = FALSE, show_col_types = FALSE)
    lconv <- readr::read_csv(paste0(base_url, l_pid), progress = FALSE, show_col_types = FALSE)
    
    
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
                       Temp_surf = arrow::float(),
                       Secchi = arrow::float(),
                       Tow_duration = arrow::float(),
                       Tow_area  =arrow::float(),
                       Tow_volume =arrow::float(),
                       Tow_direction = arrow::string())
    
    surv <- arrow::arrow_table(surv, schema = s)
    
    

    
    
    arrow::write_dataset(surv, file.path(rappdirs::user_cache_dir("deltaFish"), "survey"), partitioning = "Source", existing_data_behavior = "overwrite")
    arrow::write_dataset(fish, file.path(rappdirs::user_cache_dir("deltaFish"), "fish"), partitioning = "Taxa")
    arrow::write_dataset(lconv, file.path(rappdirs::user_cache_dir("deltaFish"), "length_conversion"))
    
    return(rappdirs::user_cache_dir("deltaFish"))
}



