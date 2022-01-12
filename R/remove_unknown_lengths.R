#' Remove unknown fish lengths
#' 
#' Removes unknown fish lengths. Returns an arrow dataset.
#'
#' @param data An arrow dataset of fish data. See `open_fish()`
#' @param univariate (logical) Will these data be used for univariate analyses 
#' (\code{univariate=TRUE})? Or multi-species analyses (\code{univariate=FALSE})?
#' If univariate, when a \code{Length_NA_flag=="Unknown length"} record is found, 
#' all records of that taxa from that sample are removed. In effect, this is 
#' transforming those records into missing data. If \code{univariate=FALSE}, when 
#' a \code{Length_NA_flag=="Unknown length"} record is found, the entire sample 
#' is removed and no 0s are filled in, since accurate community data cannot be 
#' confirmed for that sample.
#'
#' 
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' 
#' @return data_known An arrow dataset with only known lenghts
#' @export
#'

remove_unknown_lengths <- function(data, univariate){
    
    if (!any(c("Length") %in% names(data))){
        stop("Input data must have Length column name")
    }
    
    if(!univariate){
        remove <- data %>%
            dplyr::filter(is.na(.data$Length) & .data$Length_NA_flag == "Unknown length") %>%
            dplyr::pull(.data$SampleID) %>%
            unique()
        
        data_f <- data %>%
            dplyr::filter(!.data$SampleID %in% remove)
    }
    
    if (univariate){
        remove <- data %>%
            dplyr::filter(is.na(.data$Length) & .data$Length_NA_flag=="Unknown length") %>%
            dplyr::select(.data$Taxa, .data$SampleID) %>%
            dplyr::distinct()
        
        data_f <- data_prep %>%
            dplyr::anti_join(remove, by=c("Taxa", "SampleID"))
        
    }
    
    
    return(data_f)
    
}
