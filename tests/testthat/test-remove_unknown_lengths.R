test_that("remove_unknown_lengths removes rows", {
    surv <- open_survey() 
    
    fish <- open_fish() %>% 
        dplyr::filter(Taxa == "Alosa sapidissima")
    
    df_removed <- dplyr::inner_join(fish, surv) %>%
        remove_unknown_lengths(univariate = FALSE) %>% 
        collect()
    
    df_full <- dplyr::inner_join(fish, surv) %>% 
        collect()
    
    expect_true(nrow(df_full) > nrow(df_removed))
    

})
