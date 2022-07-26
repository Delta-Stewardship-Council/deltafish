cat("testing convert_lengths")
require(dplyr)
# lengths are converted correctly

surv <- open_survey()
fish <- open_fish() %>%
    mutate(Row = paste(SampleID, Taxa, Notes_catch, Length))
length_conv <- open_length_conv()

df_converted_s <- fish %>%
    dplyr::inner_join(surv %>%
                          filter(Source=="Suisun")) %>%
    convert_lengths()

df_unconverted_s <- fish %>%
    dplyr::inner_join(surv %>%
                          filter(Source=="Suisun")) 

df_converted_compare_s <- df_unconverted_s %>%
    select(Taxa, Length, Source, Row) %>%
    compute() %>% 
    dplyr::left_join(length_conv, by=c("Taxa"="Species")) %>%
    dplyr::mutate(Length_un=ifelse(is.na(Slope), Length, Length*Slope+Intercept)) %>%
    dplyr::left_join(df_converted_s %>% 
                         dplyr::select(Row, Length_con=Length) %>%
                         compute(), 
                     by=c("Row")) %>%
    dplyr::select(Length_con, Length_un) %>%
    mutate(missmatch=Length_con - Length_un) %>%
    filter(!(missmatch==0 | (is.na(Length_con) & is.na(Length_un)))) %>%
    compute()

gc()

test_that("convert_lengths errors if taxa not in data", {
    expect_error(convert_lengths(df_unconverted_s %>% 
                                     select(-Taxa)))
})

test_that("input data without Suisun is returned with a warning", {
    expect_warning(df_converted_fmwt <- fish %>%
        dplyr::inner_join(surv %>%
                              filter(Source=="FMWT")) %>%
        convert_lengths())
})

test_that("lengths are converted correctly", {
    
    expect_equal(nrow(df_converted_compare_s), 0)
})

# Converting lengths does not change the number of rows or columns or the total catch

df_converted_col<-df_converted_s %>%
    select(Count) %>%
    compute() %>%
    dplyr::summarise(N=n(), Count_sum=sum(Count, na.rm=T)) %>%
    collect()

df_unconverted_col<-df_unconverted_s %>% 
    select(Count) %>%
    compute() %>%
    dplyr::summarise(N=n(), Count_sum=sum(Count, na.rm=T)) %>%
    collect()

test_that("Converting lengths does not change the number of rows or columns or the total catch", {
    expect_equal(df_converted_col$N, df_unconverted_col$N)
    expect_setequal(names(df_converted_s), names(df_unconverted_s))
    expect_equal(df_converted_col$Count_sum, df_unconverted_col$Count_sum)
})

# Converting lengths does not induce lengths <= 0

df_less_0 <- df_converted_s %>% 
    dplyr::filter(Length <= 0)%>%
    select(Count)%>%
    collect()

test_that("Converting lengths does not induce lengths <= 0", {
    
    expect_equal(nrow(df_less_0), 0)
    
})

# Converting lengths does not affect non-Suisun data

df_converted_compare <- fish %>%
    select(SampleID, Taxa, Length) %>%
    mutate(Length_o=Length) %>%
    dplyr::inner_join(surv %>%
                          select(Source, SampleID)%>%
                          compute()) %>%
    convert_lengths() %>%
    filter(Source!="Suisun")%>% 
    dplyr::select(Length_con=Length, Length=Length_o )%>%
    mutate(missmatch=Length_con - Length) %>%
    filter(!(missmatch==0 | (is.na(Length_con) & is.na(Length)))) %>%
    compute()

test_that("Converting lengths does not affect non-Suisun data", {
    
    expect_equal(nrow(df_converted_compare), 0)
    
})

test_that("convert_lengths fails when the required column names are not included", {
    expect_error(convert_lengths(data.frame(Taxa="a", length=1)), "Input data must have Taxa and Length column names", fixed=TRUE)
    
})

test_that("convert_lengths works without 'Source' column", {
    df_converted_nosource <- open_fish() %>%
        filter(Taxa%in%"Alosa sapidissima")%>%
        compute()%>%
        convert_lengths()%>%
        head()%>%
        collect()
    
    expect_true(!"Source"%in%names(df_converted_nosource))
    expect_gt(nrow(df_converted_nosource), 0)
    
})

rm(list = ls())
gc()
cat("finished testing convert_lengths")