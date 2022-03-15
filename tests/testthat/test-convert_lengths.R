test_that("lengths are converted correctly", {
    surv <- open_survey() %>% 
        dplyr::filter(SampleID == "Suisun {AECF75CB-5BD4-11D4-B974-006008C01BCF}")
    fish <- open_fish() %>% 
        dplyr::filter(Taxa == "Alosa sapidissima")
    
    df_converted <- dplyr::inner_join(fish, surv) %>%
        convert_lengths()
        
    df_unconverted <- dplyr::inner_join(fish, surv) %>% 
        collect()
    
    l <- open_length_conv() %>% 
        collect() %>% 
        filter(Species == "Alosa sapidissima")
    
    expect_equal(df_converted$Length, df_unconverted$Length*l$Slope + l$Intercept)

    
})


test_that("Converting lengths does not change the number of rows or columns or the total catch", {
    
    surv <- open_survey() %>% 
        dplyr::filter(Source == "Suisun")
    
    fish <- open_fish() %>% 
        dplyr::filter(Taxa == "Alosa sapidissima")
    
    df_converted <- dplyr::inner_join(fish, surv) %>%
        convert_lengths()
    
    df_unconverted <- dplyr::inner_join(fish, surv) %>% 
        collect()
    
    expect_equal(nrow(df_converted), nrow(df_unconverted))
    expect_setequal(colnames(df_converted), colnames(df_unconverted))
    expect_equal(sum(df_converted$Count, na.rm=T), sum(df_unconverted$Count, na.rm=T))
})
