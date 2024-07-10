#' Connect to database (internal)
#'
#' @param cache_dir name of cache directory
#' @return con A DBI connection object
#' @noRd

open_database_f <- function(cache_dir){
    
    if (!(dir.exists(rappdirs::user_cache_dir(cache_dir)))){
        stop("Cache directory does not exist. Try running `create_fish_db().")
    }
    
    con <- DBI::dbConnect(RSQLite::SQLite(), dbname = file.path(rappdirs::user_cache_dir(cache_dir), "deltafish.sqlite"), extended_types = TRUE)
    
    return(con)
}

#' Connect to database
#' 
#' Connect to the fish database stored in local cache directory.
#'
#' @return con A DBI connection object

open_database <- function(){
    cache_dir <- 'deltafish'
    
    if (!(dir.exists(rappdirs::user_cache_dir(cache_dir)))){
        stop("Cache directory does not exist. Try running `create_fish_db().")
    }

    con <- open_database_f(cache_dir)
    
    return(con)
}


#' Connect fish data
#' 
#' Connect to the fish table stored in the database
#' 
#' @param con A DBI connection object from open_database()
#' @param quiet silence message about fish length units.  
#'
#' @return A DBI table that can be treated like a data.frame, with fish data
#' @export

open_fish <- function(con, quiet=FALSE){
    
    if (!quiet){
        message("Note: fish length units are not all compatible across surveys. The Suisun study uses standard length while the other surveys use fork/total length. Use deltafish::convert_lengths to convert the length units of the 20 taxa for which we have conversion equations from standard length to fork/total length. ")
    }
    
    fish <- dplyr::tbl(con, "fish")
    return(fish)
}

#' Connect survey data
#' 
#' Connect to the survey table stored in the database
#' 
#' @param con A DBI connection object from open_database()
#'
#' @return A DBI table that can be treated like a data.frame, with survey data
#' @export

open_survey <- function(con){
    
    survey <- dplyr::tbl(con, "survey")
    return(survey)
}

#' Connect length conversion data
#' 
#' Connect to the length conversion table stored in the database
#' 
#' @param con A DBI connection object from open_database()
#' 
#' @return A DBI table that can be treated like a data.frame, with length conversion data
#' @export

open_length_conv <- function(con){
    
    lconv <- dplyr::tbl(con, "length_conversion")
    return(lconv)
}


#' Close connection to database
#' 
#' Close connection to SQLite database. Recommended at the end of every session.
#'
#' @param con A DBI connection object from open_database()
#' 
#' @export
close_database <- function(con){
    DBI::dbDisconnect(con)
}