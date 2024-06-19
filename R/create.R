#' Create fish database with file option
#'
#' Main function code to create the arrow dataset. Can look for data
#' locally or on EDI. Only used to generate the datasets in a local cache.
#' 
#' @param data_dir Directory to read data from
#' @param cache_dir Directory to cache data into
#' @param edi_pid Identifier of dataset to use from EDI
#' @param update
#' 
#' @import arrow
#' @return NULL
#' @noRd

create_fish_db_f <- function(data_dir, cache_dir, edi_pid, update, download_method="curl"){
    
    # set timeout to something high
    timeout <- getOption('timeout')
    options(timeout = 3600)
    
    # Fix issue with Arrow 11 in Mac and (some) linux
    if(check_os_ci()$os%in%c("darwin", "linux")){
        arrow_threads <- getOption('arrow.use_threads')
        options(arrow.use_threads = FALSE)
    }
    
    #Fixing R CMD check issue with global variable binding:
    res_fish <- NULL
    res_survey <- NULL
    
    # if the dataset is up to date, but user wants to update, 
    # print a message and set update to FALSE
    if(update){
        up_to_date <- is_cache_updated()
        
        if (up_to_date){
            update <- FALSE
            message("Dataset already up to date")
        }
    }
    
    # set up cache
    if (!(dir.exists(rappdirs::user_cache_dir(cache_dir)))){
        dir.create(rappdirs::user_cache_dir(cache_dir), recursive = TRUE)
    } else if (dir.exists(rappdirs::user_cache_dir(cache_dir)) &
               length(dir(rappdirs::user_cache_dir(cache_dir), recursive = TRUE)) > 0 &
               !update){
        if(!file.exists(file.path(rappdirs::user_cache_dir(cache_dir), "revision.txt"))){
            message("Unknown version installed. If you wish to re-install the cache with a known version, run clear_cache() then create_fish_db().")
            return(rappdirs::user_cache_dir(cache_dir))
        }else{
            rev <- show_cached_revision(cache_dir)
            message(paste("Reading data from cache directory, revision", rev))
            return(rappdirs::user_cache_dir(cache_dir))
        }
    }
    
    # download dataif no data_dir is set
    if (is.null(data_dir)){ 
        
        
        edi_entity_pids <- get_edi_pids(edi_pid)
        revision <- strsplit(edi_pid, ".", fixed=T)[[1]][3]
        
        message(paste("Getting data from EDI identifier", edi_pid))
        
        binary_loc <- paste0("https://pasta.lternet.edu/package/data/eml/edi/1075/", revision, "/", edi_entity_pids$compressed)
        
        # fish
        message("Downloading and writing fish data (~18 MB)")
        # download
        fish_dest <- file.path(tempdir(), "fishsurvey_compressed.rda")
        t <- utils::download.file(binary_loc, mode="wb", method=download_method, destfile = fish_dest)
        # read
        load(fish_dest)
        
        
        length_loc <-  paste0("https://pasta.lternet.edu/package/data/eml/edi/1075/", revision, "/", edi_entity_pids$length)
        # download
        utils::download.file(length_loc, mode="wb", method=download_method, destfile=file.path(tempdir(), "Length_conversions.csv"))
        # read
        lconv <- utils::read.csv(file.path(tempdir(), "Length_conversions.csv"))
        
    } else if (!is.null(data_dir)){
        
        if (!all(c("Length_conversions.csv", "fishsurvey_compressed.rda") %in% dir(data_dir))){
            stop("Data directory must contain both Length_conversions.csv and fishsurvey_compressed.rda.")
        }
        
        load(file.path(data_dir, "fishsurvey_compressed.rda"))
        lconv <- utils::read.csv(file.path(data_dir, "Length_conversions.csv"))
        
    }
    # write
    
    if(edi_pid=="edi.1075.1"){
        s_fish<-arrow::schema(SampleID  = arrow::large_utf8(),
                              Taxa = arrow::string(),
                              Length = arrow::float(),
                              Count = arrow::float(),
                              Notes_catch = arrow::string())
        
        arrow::write_dataset(arrow::arrow_table(res_fish, schema = s_fish), file.path(rappdirs::user_cache_dir(cache_dir), "fish"), partitioning = "Taxa")
        
    }else{
        s_fish<-arrow::schema(Source = arrow::string(),
                              SampleID  = arrow::large_utf8(),
                              Taxa = arrow::string(),
                              Length = arrow::float(),
                              Count = arrow::float(),
                              Notes_catch = arrow::string())
        
        arrow::write_dataset(arrow::arrow_table(res_fish, schema = s_fish), file.path(rappdirs::user_cache_dir(cache_dir), "fish"), partitioning = c("Source", "Taxa"))
    }
    
    # clean up environment to save memory
    rm(res_fish)
    gc()
    
    timezone<-attr(res_survey$Datetime, "tzone")
    
    s_surv <- arrow::schema(Source = arrow::string(),
                            Station = arrow::string(),
                            Latitude = arrow::float(),     
                            Longitude = arrow::float(),
                            Date = arrow::date64(),
                            Datetime = arrow::timestamp(timezone=timezone),
                            Survey  = arrow::int64(),
                            Depth  = arrow::float(),
                            SampleID  = arrow::large_utf8(),
                            Method  = arrow::string(),
                            Tide   = arrow::string(),
                            Sal_surf   = arrow::float(),
                            Sal_bot   = arrow::float(),
                            Temp_surf = arrow::float(),
                            Secchi = arrow::float(),
                            Secchi_estimated = arrow::boolean(),
                            Tow_duration = arrow::float(),
                            Tow_area  = arrow::float(),
                            Tow_volume =arrow::float(),
                            Cable_length = arrow::float(),
                            Tow_direction = arrow::string(),
                            Notes_tow = arrow::string(),
                            Notes_flowmeter = arrow::string())
    
    
    surv <- arrow::arrow_table(res_survey, schema = s_surv)
    arrow::write_dataset(surv, file.path(rappdirs::user_cache_dir(cache_dir), "survey"), partitioning = "Source", existing_data_behavior = "overwrite")
    
    # length conversion
    
    
    # write
    arrow::write_dataset(lconv, file.path(rappdirs::user_cache_dir(cache_dir), "length_conversion"))
    
    writeLines(edi_pid, file.path(rappdirs::user_cache_dir(cache_dir), "revision.txt"))
    
    # reset options
    options(timeout = timeout)
    gc()
    
    if(check_os_ci()$os%in%c("darwin", "linux")){
        options(arrow.use_threads = arrow_threads)
    }
    
    return(rappdirs::user_cache_dir(cache_dir))
}






#' Create fish database
#'
#' Function to create the arrow dataset. Reads in raw data from the
#' published [EDI dataset](https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier=1075&revision=1).
#' 
#' @param edi_pid (char) Optionally, a way to specify a specific revision of the dataset, in the format "edi.1075.1"
#' Leave parameter unset to get the latest revision.
#' @param update (logical) If set to TRUE, will update to latest version from EDI if a newer version is available
#' @param download_method value for the \code{method} parameter of the \code{\link[utils]{download.file}} function. 
#' 
#' @import arrow
#' @return NULL
#' @export
#'

create_fish_db <- function(edi_pid = NULL, update = FALSE, download_method="curl"){
    
    if (is.null(edi_pid)){
        edi_pid <- get_latest_EDI_revision()
    }
    
    create_fish_db_f(data_dir = NULL, cache_dir = "deltafish", edi_pid = edi_pid, update = update, download_method=download_method) 
    
}



