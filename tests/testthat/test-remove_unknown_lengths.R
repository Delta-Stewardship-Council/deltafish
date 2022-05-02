surv <- open_survey()
fish <- open_fish()
length_conv <- open_length_conv()

test_that("remove_unknown_lengths removes rows", {
    surv_s <- surv %>% 
        filter(Source == "Suisun")
    
    fish_s <- fish %>% 
        dplyr::filter(Taxa == "Alosa sapidissima")
    
    df_removed <- dplyr::inner_join(fish_s, surv_s) %>%
        remove_unknown_lengths(univariate = FALSE) %>% 
        collect()
    
    df_full <- dplyr::inner_join(fish_s, surv_s) %>% 
        collect()
    
    expect_true(nrow(df_full) > nrow(df_removed))
    expect_true(length(which(is.na(df_removed$Length))) == 0)

})
