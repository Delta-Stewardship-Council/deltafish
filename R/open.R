#' Connect survey data (internal)
#'
#' @param cache_dir name of cache directory
#' @return survey An arrow object that can be treated like a data.frame, with survey data
#' @importFrom magrittr %>%
#' @importFrom dplyr tbl
#' @noRd

open_survey_f <- function(cache_dir){
    
    if (!(dir.exists(rappdirs::user_cache_dir(cache_dir)))){
        stop("Cache directory does not exist. Try running `create_fish_db().")
    }
    
    if (!requireNamespace("dplyr", quietly = TRUE)) {
        stop("please install dplyr first")
    }
    
    survey <- arrow::open_dataset(file.path(rappdirs::user_cache_dir(cache_dir), "survey")) %>% 
        arrow::to_duckdb(auto_disconnect = FALSE)
    
    #if (length(survey$files) == 0) stop("No survey dataset found. Run create_fish_db() first.")
    
    return(survey)
}

#' Connect fish data (internal)
#'
#' @param cache_dir A cache directory name
#' @return fish An arrow object that can be treated like a data.frame, with fish data
#' @importFrom magrittr %>%
#' @importFrom dplyr tbl
#' @noRd

open_fish_f <- function(cache_dir){
    if (!(dir.exists(rappdirs::user_cache_dir(cache_dir)))){
        stop("Cache directory does not exist. Try running `create_fish_db().")
    }
    
    if (!requireNamespace("dplyr", quietly = TRUE)) {
        stop("please install dplyr first")
    }
    
    fish  <- arrow::open_dataset(file.path(rappdirs::user_cache_dir(cache_dir), "fish")) %>% 
        arrow::to_duckdb(auto_disconnect = FALSE)
    
    return(fish)
}

#' Connect length conversion data (internal)
#'
#' @param cache_dir A cache directory name
#' @return An arrow object that can be treated like a data.frame, with length conversion data
#' @importFrom magrittr %>%
#' @importFrom dplyr tbl
#' @noRd

open_length_conv_f <- function(cache_dir){
    if (!(dir.exists(rappdirs::user_cache_dir(cache_dir)))){
        stop("Cache directory does not exist. Try running `create_fish_db().")
    }
    
    if (!requireNamespace("dplyr", quietly = TRUE)) {
        stop("please install dplyr first")
    }
    
    lconv  <- arrow::open_dataset(file.path(rappdirs::user_cache_dir(cache_dir), "length_conversion")) %>% 
        arrow::to_duckdb(auto_disconnect = FALSE)
    
    #if (length(lconv$files) == 0) stop("No length conversion dataset found. Run create_fish_db() first.")
    
    return(lconv)
}


#' Connect fish data
#' 
#' Connect to the fish data stored in the package
#'
#' @return An arrow object that can be treated like a data.frame, with fish data
#' @export

open_fish <- function(){
    
    lconv <- open_fish_f(cache_dir = "deltafish")
    
    return(lconv)
}

#' Connect survey data
#' 
#' Connect to the survey data stored in the package
#'
#' @return An arrow object that can be treated like a data.frame, with survey data
#' @export

open_survey <- function(){
    
    survey <- open_survey_f(cache_dir = "deltafish")
    return(survey)
}

#' Connect length conversion data
#' 
#' Connect to the length conversion data stored in the package
#'
#' @return An arrow object that can be treated like a data.frame, with length conversion data
#' @export

open_length_conv <- function(){
    
    lconv <- open_length_conv_f(cache_dir = "deltafish")
    
    return(lconv)
}