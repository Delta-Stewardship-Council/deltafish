#' Open survey data
#' 
#' Open the survey data stored in the package
#'
#' @return survey An arrow object that can be treated like a data.frame, with survey data
#' @export

open_survey <- function(){
    survey  <- arrow::open_dataset(system.file(package = "deltaFish", "extdata", "survey"))
}

#' Open fish data
#' 
#' Open the survey data stored in the package
#'
#' @return fish An arrow object that can be treated like a data.frame, with fish data
#' @export
#' 
open_fish <- function(){
    fish  <- arrow::open_dataset(system.file(package = "deltaFish", "extdata", "fish"))
}

#' Connect length conversion data
#' 
#' Connect to the length conversion data stored in the package
#'
#' @return fish An arrow object that can be treated like a data.frame, with length conversion data
#' @export

open_length_conv <- function(){
    length_conv  <- arrow::open_dataset(system.file(package = "deltaFish", "extdata", "length_conversion"))
}