#' Show list of cached deltafish files
#'
#' This function returns a list of files cached for the package.
#'
#'
#' @return (list) A list of files
#' @export
#'
show_cache <- function() dir(rappdirs::user_cache_dir("deltafish"), full.names = TRUE)



file_remove_tryer <- function(x){
    tryCatch({file.remove(x)},
         error = function(y){print(y); message("If you get a permissions error, try restarting R and then clearing your cache."); return(invisible(NULL))},
         warning = function(y){print(y); message("If you get a permissions error, try restarting R and then clearing your cache."); return(invisible(NULL))}
    )
}

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
        lapply(files, file_remove_tryer)
        return(invisible(NULL))
    } else {
        message("No cache to remove.")
    }

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

#' Skip tests helper
#'
#' This function skips tests not using the given operating system and on a CI platform
#' 
#' @noRd
#'

check_os_ci<-function(){
    ci<-isTRUE(as.logical(Sys.getenv("CI")))
    
    os<-tolower(Sys.info()[["sysname"]])
    
    out<-list(ci=ci, os=os)
    
    return(out)
}

#' Skip tests helper
#'
#' This function skips tests not using the given operating system and on a CI platform
#' 
#' @noRd
#'
skip_os_ci<-function(os, check_ci=TRUE){
    if(!os%in%c("windows", "darwin", "linux")){
        stop("os can only include 'windows', 'darwin', or 'linux'.")
    }
    
    os_ci<-check_os_ci()
    
    if(!os_ci$os%in%c("windows", "darwin", "linux")){
        stop("This function is only designed to work on 'windows', 'darwin', or 'linux' operating systems.")
    }
    
    if(os_ci$os%in%os){ # If we are running the chosen os, don't skip
        return(invisible(TRUE))
    }else{
        if(check_ci & !os_ci$ci){ # If we want to check ci and we're not on ci, don't skip
            return(invisible(TRUE))
        }
    }
    
    # Otherwise (not running chosen os and either A) not checking ci or B) checking ci and on ci) skip
    msg<-paste0("Test skipped, ", ifelse(check_ci, "when using CI, ", ""), "only run on ", os)
    testthat::skip(msg)
}