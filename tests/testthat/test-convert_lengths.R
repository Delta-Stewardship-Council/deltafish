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
        convert_lengths()%>% 
        dplyr::select(Length)%>%
        collect()
    
    df_unconverted <- dplyr::inner_join(fish_s, surv_s) %>% 
        dplyr::select(Length)%>%
        collect()
    
    l <- length_conv %>% 
        collect() %>% 
        dplyr::filter(Species == "Alosa sapidissima")
    
    expect_equal(df_converted$Length, df_unconverted$Length*l$Slope + l$Intercept)
    
    
})


test_that("Converting lengths does not change the number of rows or columns or the total catch", {
    
    surv_s <- surv %>% 
        dplyr::select(Source, SampleID) %>% 
        dplyr::filter(Source == "Suisun")
    
    fish_s <- fish %>% 
        dplyr::filter(Taxa == "Alosa sapidissima")
    
    df_converted <- dplyr::inner_join(fish_s, surv_s) 
    
    df_converted_col<-df_converted%>%
        convert_lengths()%>% 
        dplyr::summarise(N=dplyr::n(), Count_sum=sum(Count, na.rm=T))%>%
        collect()
    
    df_unconverted <- dplyr::inner_join(fish_s, surv_s) 
    
    df_unconverted_col<-df_unconverted%>% 
        dplyr::summarise(N=dplyr::n(), Count_sum=sum(Count, na.rm=T))%>%
        collect()
    
    expect_equal(df_converted_col$N, df_unconverted_col$N)
    expect_setequal(colnames(df_converted), colnames(df_unconverted))
    expect_equal(df_converted_col$Count_sum, df_unconverted_col$Count_sum)
})

test_that("Converting lengths does not induce lengths <= 0", {
    
    surv_s <- surv %>% 
        dplyr::select(Source, SampleID) %>% 
        dplyr::filter(Source == "Suisun") %>% 
        dplyr::slice_min(SampleId, n = 5)
    
    df_less_0 <- dplyr::inner_join(fish, surv_s) %>%
        convert_lengths() %>% 
        dplyr::filter(Length <= 0)%>%
        collect()
    
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
        dplyr::select(SampleID, Taxa, Length)%>%
        collect()%>%
        dplyr::arrange(SampleID, Taxa, Length)
    
    df_unconverted <- dplyr::inner_join(fish, surv_s)%>% 
        dplyr::filter(Source != "Suisun" & !is.na(Length)) %>% 
        dplyr::select(SampleID, Taxa, Length)%>%
        collect()%>%
        dplyr::arrange(SampleID, Taxa, Length)
    
    
    expect_true(all(near(df_converted$Length, df_unconverted$Length)))
    
})

rm(list = ls())
gc()