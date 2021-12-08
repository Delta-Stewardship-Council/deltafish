#' Create fish database
#'
#' Function to create the arrow dataset. Currently hard coded
#' to look at raw data stored locally. Eventually will look for data
#' on EDI. Only used to generate the datasets in inst/extdata.
#'
#' @return NULL
#'

create_fish_db <- function(){
    
    surv <- read.csv("data-raw/survey_info.csv")
    
    
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
    
    arrow::write_dataset(surv, "inst/extdata/survey", partitioning = "Source", existing_data_behavior = "overwrite")
    arrow::write_dataset(read_csv("data-raw/fish_info.csv"), "inst/extdata/fish", partitioning = "Taxa")
    arrow::write_dataset(read_csv("data-raw/length_conversions.csv"), "inst/extdata/length_conversion")
}

