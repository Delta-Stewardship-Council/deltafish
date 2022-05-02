surv <- open_survey()
fish <- open_fish()
length_conv <- open_length_conv()

test_that("remove_unknown_lengths removes rows as expected", {
    
    surv_s <- surv %>% 
        dplyr::select(Source, SampleID) %>% 
        dplyr::group_by(Source) %>% 
        dplyr::slice_min(SampleId, n = 5)
    
    df_removed_nu <- dplyr::inner_join(fish, surv_s) %>%
        remove_unknown_lengths(univariate = FALSE) %>% 
        collect()
    
    df_removed_u <- dplyr::inner_join(fish, surv_s) %>%
        remove_unknown_lengths(univariate = TRUE) %>% 
        collect()
    
    df_full <- dplyr::inner_join(fish, surv_s) %>% 
        collect()
    
    expect_true(nrow(df_full) > nrow(df_removed_u) & nrow(df_removed_u) > nrow(df_removed_nu))
    expect_true(length(which(is.na(df_removed$Length))) == 0 & length(which(is.na(df_removed_u$Length))) == 0)

})
