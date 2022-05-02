surv <- open_survey()
fish <- open_fish()
length_conv <- open_length_conv()

test_that("lengths are converted correctly", {
    surv_s <- surv %>% 
        dplyr::filter(SampleID == "Suisun {AECF75CB-5BD4-11D4-B974-006008C01BCF}")
    fish_s <- fish %>% 
        dplyr::filter(Taxa == "Alosa sapidissima")
    
    df_converted <- dplyr::inner_join(fish_s, surv_s) %>%
        convert_lengths()
        
    df_unconverted <- dplyr::inner_join(fish_s, surv_s) %>% 
        collect()
    
    l <- length_conv %>% 
        collect() %>% 
        filter(Species == "Alosa sapidissima")
    
    expect_equal(df_converted$Length, df_unconverted$Length*l$Slope + l$Intercept)

    
})


test_that("Converting lengths does not change the number of rows or columns or the total catch", {
    
    surv_s <- surv %>% 
        dplyr::filter(Source == "Suisun")
    
    fish_s <- fish %>% 
        dplyr::filter(Taxa == "Alosa sapidissima")
    
    df_converted <- dplyr::inner_join(fish_s, surv_s) %>%
        convert_lengths()
    
    df_unconverted <- dplyr::inner_join(fish_s, surv_s) %>% 
        collect()
    
    expect_equal(nrow(df_converted), nrow(df_unconverted))
    expect_setequal(colnames(df_converted), colnames(df_unconverted))
    expect_equal(sum(df_converted$Count, na.rm=T), sum(df_unconverted$Count, na.rm=T))
})
