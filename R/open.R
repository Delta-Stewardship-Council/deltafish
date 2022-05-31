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
    
    survey <- arrow::open_dataset(file.path(rappdirs::user_cache_dir(cache_dir), "survey"))
    
    return(survey)
}

#' Connect fish data (internal)
#'
#' @param cache_dir A cache directory name
#' @param quiet silence message about fish length units.  
#' @return fish An arrow object that can be treated like a data.frame, with fish data
#' @importFrom magrittr %>%
#' @importFrom dplyr tbl
#' @noRd

open_fish_f <- function(cache_dir, quiet=FALSE){
    if (!(dir.exists(rappdirs::user_cache_dir(cache_dir)))){
        stop("Cache directory does not exist. Try running `create_fish_db().")
    }
    fish  <- arrow::open_dataset(file.path(rappdirs::user_cache_dir(cache_dir), "fish"))
    if(!quiet){
        message("Note: fish length units are not all compatible across surveys. The Suisun study uses standard length while the other surveys use fork/total length. Use deltafish::convert_lengths to convert the length units of the 20 taxa for which we have conversion equations from standard length to fork/total length. ")
    }
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
    
    lconv  <- arrow::open_dataset(file.path(rappdirs::user_cache_dir(cache_dir), "length_conversion"))
    
    return(lconv)
}


#' Connect fish data
#' 
#' Connect to the fish data stored in the package
#' @param quiet silence message about fish length units.  
#'
#' @return An arrow object that can be treated like a data.frame, with fish data
#' @export

open_fish <- function(quiet=FALSE){
    
    lconv <- open_fish_f(cache_dir = "deltafish", quiet=quiet)
    
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