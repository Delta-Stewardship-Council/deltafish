#' Open survey data
#' 
#' Open the survey data stored in the package
#'
#' @return survey An arrow object that can be treated like a data.frame, with survey data
#' @importFrom magrittr %>%
#' @importFrom dplyr tbl
#' @export

open_survey <- function(){
    
    if (!(dir.exists(rappdirs::user_cache_dir("deltafish")))){
        stop("Cache directory does not exist. Try running `create_fish_db().")
    }
    
    survey <- arrow::open_dataset(file.path(rappdirs::user_cache_dir("deltafish"), "survey"))
    
    #if (length(survey$files) == 0) stop("No survey dataset found. Run create_fish_db() first.")
    
    return(survey)
}

#' Open fish data
#' 
#' Open the survey data stored in the package
#'
#' @return fish An arrow object that can be treated like a data.frame, with fish data
#' @importFrom magrittr %>%
#' @importFrom dplyr tbl
#' @export
#' 
open_fish <- function(){
    if (!(dir.exists(rappdirs::user_cache_dir("deltafish")))){
        stop("Cache directory does not exist. Try running `create_fish_db().")
    }
    
    fish  <- arrow::open_dataset(file.path(rappdirs::user_cache_dir("deltafish"), "fish"))
    
    #if (length(fish$files) == 0) stop("No fish dataset found. Run create_fish_db() first.")
    
    return(fish)
}

#' Connect length conversion data
#' 
#' Connect to the length conversion data stored in the package
#'
#' @return fish An arrow object that can be treated like a data.frame, with length conversion data
#' @importFrom magrittr %>%
#' @importFrom dplyr tbl
#' @export

open_length_conv <- function(){
    if (!(dir.exists(rappdirs::user_cache_dir("deltafish")))){
        stop("Cache directory does not exist. Try running `create_fish_db().")
    }
    
    lconv  <- arrow::open_dataset(file.path(rappdirs::user_cache_dir("deltafish"), "length_conversion"))
    
    #if (length(lconv$files) == 0) stop("No length conversion dataset found. Run create_fish_db() first.")
    
    return(lconv)
}