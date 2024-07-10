#' Convert fish length
#' 
#' Converts fish length data using the length conversion table. Returns an arrow dataset.
#' This function is only needed to convert Suisun survey data.
#'
#' @param data A DBI table that can be treated like a data.frame, with fish data. See `open_fish()`
#' 
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' 
#' @return data_conv A DBI table with converted lengths
#' @export
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' con <- open_database()
#' fish <- open_fish(con) %>% 
#'     filter(Taxa %in% c("Dorosoma petenense", "Morone saxatilis", "Spirinchus thaleichthys"))
#' 
#' fish_conv <- convert_lengths(fish) %>% 
#'     collect()
#' close_database(con)
#' }
#' 
convert_lengths <- function(data){
    
    if (any(!c("Taxa", "Length") %in% colnames(data))){
        stop("Input data must have Taxa and Length column names")
    }
    if (!("Source" %in% colnames(data))){
        con <- data[["src"]][["con"]]
        surv <- open_survey(con) %>% 
            dplyr::select("SampleID", "Source")
        
        data_prep <- dplyr::left_join(data, surv)
    } else data_prep <- data
    
    sources <- data_prep %>%
        dplyr::distinct(.data$Source) %>%
        dplyr::collect() %>%
        dplyr::pull("Source")
    
    if (!("Suisun" %in% sources)){
        warning("No Suisun data found in input data. This function only operates on Suisun data.")
        return(data)
    }
    
    con <- data[["src"]][["con"]]
    l <- open_length_conv(con)
    
    sp <- l %>%
        dplyr::distinct(.data$Species) %>%
        dplyr::collect() %>%
        dplyr::pull("Species")
    
    data_f <- data_prep %>%
        dplyr::left_join(l, by = c("Taxa" = "Species")) %>%
        dplyr::mutate(Length = ifelse(.data$Source == "Suisun" & .data$Taxa %in% sp,
                                            .data$Intercept + .data$Slope * .data$Length,
                                            .data$Length)) %>%
        dplyr::select(-"Intercept", -"Slope")
    
    # if source wasn't in input data drop it
    if (!("Source" %in% colnames(data))){
        data_f <- data_f %>%
            dplyr::select(-"Source")
    }
    
    return(data_f)

}
