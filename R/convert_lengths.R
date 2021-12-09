#' Convert fish length
#' 
#' Converts fish length data using the length conversion table. Returns an arrow dataset.
#'
#' @param data An arrow dataset of fish data. See `open_fish()`
#' 
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' 
#' @return data_conv An arrow dataset with converted lengths
#' @export
#'
#' @examples
#' library(dplyr)
#' 
#' fish <- open_fish() %>% 
#'     filter(Taxa %in% c("Dorosoma petenense", "Morone saxatilis", "Spirinchus thaleichthys"))
#' 
#' fish_conv <- convert_lengths(fish) %>% 
#'     collect()
#' 
convert_lengths <- function(data){
    
    if (!any(c("Taxa", "Length") %in% names(data))){
        stop("Input data must have Taxa and Length column names")
    }
    if (!("Source" %in% names(data))){
        surv <- open_survey() %>% 
            dplyr::select(.data$SampleID, .data$Source)
        
        data_prep <- dplyr::left_join(data, surv)
    } else data_prep <- data
    
    length_conv <- open_length_conv() 
    
    l <- length_conv %>% 
        dplyr::collect()
    sp <- unique(l$Taxa)
    
    data_f <- data_prep %>%
        dplyr::left_join(length_conv) %>%
        dplyr::mutate(Length = ifelse(.data$Source=="Suisun" & .data$Taxa %in% sp,
                                            .data$Intercept + .data$Slope * .data$Length,
                                            .data$Length)) %>%
        dplyr::select(-.data$Intercept, -.data$Slope)
    
    # if source wasn't in input data drop it
    if (!("Source" %in% names(data))){
        data_f <- data_f %>%
            dplyr::select(-.data$Source)
    }
    
    return(data_f)

}
