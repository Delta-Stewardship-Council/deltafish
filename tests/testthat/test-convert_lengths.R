surv <- open_survey()
fish <- open_fish()
length_conv <- open_length_conv()

test_that("lengths are converted correctly", {
    surv_s <- surv %>% 
        dplyr::select(Source, SampleID) %>% 
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
        dplyr::select(Source, SampleID) %>% 
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

test_that("Converting lengths does not induce lengths <= 0", {
    
    surv_s <- surv %>% 
        dplyr::select(Source, SampleID) %>% 
        dplyr::filter(Source == "Suisun") %>% 
        dplyr::slice_min(SampleId, n = 5)
    
    df_less_0 <- dplyr::inner_join(fish, surv_s) %>%
        convert_lengths() %>% 
        dplyr::filter(Length <= 0)
    
    expect_equal(nrow(df_less_0), 0)

})

test_that("Converting lengths does not affect non-Suisun data", {
    
    surv_s <- surv %>% 
        dplyr::select(Source, SampleID) %>% 
        dplyr::group_by(Source) %>% 
        dplyr::slice_min(SampleId, n = 5)
    
    df_converted <- dplyr::inner_join(fish, surv_s) %>%
        convert_lengths() %>% 
        dplyr::filter(Source != "Suisun" & !is.na(Length)) %>% 
        dplyr::arrange(SampleID)
    
    df_unconverted <- dplyr::inner_join(fish, surv_s) %>%
        collect() %>% 
        filter(Source != "Suisun" & !is.na(Length)) %>% 
        dplyr::arrange(SampleID)

    
    expect_true(all(df_converted$Length == df_unconverted$Length))
    
})

rm(list = ls())
gc()