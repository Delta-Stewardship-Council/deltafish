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
    
    if (!any(c("Length", "Count", "SampleID", "Taxa") %in% names(data))){
        stop("Input data must have 'Length', 'Count', 'SampleID', and 'Taxa' column names")
    }
    
    if (!univariate){
        remove <- data %>%
            dplyr::filter(is.na(.data$Length) & .data$Count!=0) %>%
            dplyr::pull("SampleID") %>%
            unique()
        
        data_f <- data %>%
            dplyr::filter(!.data$SampleID %in% remove)
    }
    
    if (univariate){
        remove <- data %>%
            dplyr::filter(is.na(.data$Length) & .data$Count!=0) %>%
            dplyr::select("Taxa", "SampleID") %>%
            dplyr::distinct()
        
        data_f <- data %>%
            dplyr::anti_join(remove, by=c("Taxa", "SampleID"))
        
    }
    
    
    return(data_f)
    
}
