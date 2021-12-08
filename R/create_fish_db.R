#' Create fish database
#'
#' Function to create fish database. Currently hard coded
#' to look at raw data stored locally. Eventually will look for data
#' on EDI.
#'
#' @return NULL
#'

create_fish_db <- function(){
    
    surv <- read.csv("data_raw/survey_info.csv") %>% 
        dplyr::mutate(Date = as.Date(.data$Date))
    
    arrow::write_dataset(surv, "data_raw/survey", partitioning = "Source")
    arrow::write_dataset(read_csv("data_raw/fish_info.csv"), "data_raw/fish", partitioning = "Taxa")
    arrow::write_dataset(read_csv("data_raw/length_conversions.csv"), "data_raw/length_conversion")
}

