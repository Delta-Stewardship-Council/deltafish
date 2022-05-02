#' Show list of cached deltafish files
#'
#' This function returns a list of files cached for the package.
#'
#'
#' @return (list) A list of files
#' @export
#'
show_cache <- function() dir(rappdirs::user_cache_dir("deltafish"), full.names = TRUE)

#' Clear cached deltafish files (internal)
#'
#' This function removes all cached files associated with the package
#' and allows you to set the cache_dir
#'
#' @return (NULL) 
#' @noRd
#' 
clear_cache_f <- function(cache_dir){
    files <- dir(rappdirs::user_cache_dir(cache_dir), full.names = TRUE, recursive = TRUE)
    if (length(files) > 0){
        message("Removing existing cache.")
        tryCatch({lapply(files, file.remove)},
                 error = function(x){print(x); message("If you get a permissions error, try restarting R and then clearing your cache.")
                     }
                 )
        return(NULL)
    } else message("No cache to remove.")

} 


#' Clear cached deltafish files
#'
#' This function removes all cached files associated with the package
#'
#'
#' @return (NULL) 
#' @export
#'
clear_cache <- function(){
    clear_cache_f(cache_dir = "deltafish")
}

