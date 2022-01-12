#' Open survey data
#' 
#' Open the survey data stored in the package
#'
#' @return survey An arrow object that can be treated like a data.frame, with survey data
#' @export

open_survey <- function(){
    if (!(dir.exists(rappdirs::user_cache_dir("deltaFish")))){
        stop("Cache directory does not exist. Try running `create_fish_db().")
    }
    survey  <- arrow::open_dataset(file.path(rappdirs::user_cache_dir("deltaFish"), "survey"))
}

#' Open fish data
#' 
#' Open the survey data stored in the package
#'
#' @return fish An arrow object that can be treated like a data.frame, with fish data
#' @export
#' 
open_fish <- function(){
    if (!(dir.exists(rappdirs::user_cache_dir("deltaFish")))){
        stop("Cache directory does not exist. Try running `create_fish_db().")
    }
    fish  <- arrow::open_dataset(file.path(rappdirs::user_cache_dir("deltaFish"), "fish"))
}

#' Connect length conversion data
#' 
#' Connect to the length conversion data stored in the package
#'
#' @return fish An arrow object that can be treated like a data.frame, with length conversion data
#' @export

open_length_conv <- function(){
    if (!(dir.exists(rappdirs::user_cache_dir("deltaFish")))){
        stop("Cache directory does not exist. Try running `create_fish_db().")
    }
    survey  <- arrow::open_dataset(file.path(rappdirs::user_cache_dir("deltaFish"), "length_conversion"))
}