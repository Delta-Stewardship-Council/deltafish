surv <- open_survey()
fish <- open_fish()%>%
    mutate(Row=row_number())
length_conv <- open_length_conv()

# lengths are converted correctly

df_converted_s <- fish%>%
    dplyr::inner_join(surv%>%
                          filter(Source=="Suisun")) %>%
    convert_lengths()

df_unconverted_s <- fish%>%
    dplyr::inner_join(surv%>%
                          filter(Source=="Suisun")) 

df_converted_compare_s<-df_unconverted_s%>% 
    dplyr::left_join(length_conv, by=c("Taxa"="Species"))%>%
    dplyr::mutate(Length_un=ifelse(is.na(Slope), Length, Length*Slope+Intercept))%>%
    dplyr::left_join(df_converted_s%>% 
                         dplyr::select(SampleID, Taxa, Row, Length_con=Length), 
                     by=c("SampleID", "Taxa", "Row"))%>%
    dplyr::select(SampleID, Taxa, Row, Length_con, Length_un)%>%
    mutate(missmatch=Length_con - Length_un)%>%
    filter(!(missmatch==0 | (is.na(Length_con) & is.na(Length_un))))%>%
    collect()

gc()

test_that("lengths are converted correctly", {
    
    expect_equal(nrow(df_converted_compare_s), 0)
})

# Converting lengths does not change the number of rows or columns or the total catch

df_converted_col<-df_converted_s%>%
    dplyr::summarise(N=dplyr::n(), Count_sum=sum(Count, na.rm=T))%>%
    collect()

df_unconverted_col<-df_unconverted_s%>% 
    dplyr::summarise(N=dplyr::n(), Count_sum=sum(Count, na.rm=T))%>%
    collect()

test_that("Converting lengths does not change the number of rows or columns or the total catch", {
    
    expect_equal(df_converted_col$N, df_unconverted_col$N)
    expect_setequal(colnames(df_converted_s), colnames(df_unconverted_s))
    expect_equal(df_converted_col$Count_sum, df_unconverted_col$Count_sum)
})

# Converting lengths does not induce lengths <= 0

df_less_0 <- df_converted_s %>% 
    dplyr::filter(Length <= 0)%>%
    collect()

test_that("Converting lengths does not induce lengths <= 0", {
    
    expect_equal(nrow(df_less_0), 0)
    
})

df_converted <- suppressWarnings(
    fish%>%
        dplyr::inner_join(surv%>%
                              filter(Source!="Suisun")) %>%
        convert_lengths()
)

# Converting lengths does not affect non-Suisun data
df_unconverted <- fish%>%
    dplyr::inner_join(surv%>%
                          filter(Source!="Suisun")) 

df_converted_compare<-df_unconverted%>%
    dplyr::left_join(df_converted%>% 
                         dplyr::select(SampleID, Taxa, Row, Length_con=Length), 
                     by=c("SampleID", "Taxa", "Row"))%>%
    dplyr::select(SampleID, Taxa, Row, Length_con, Length)%>%
    mutate(missmatch=Length_con - Length)%>%
    filter(!(missmatch==0 | (is.na(Length_con) & is.na(Length))))%>%
    collect()

test_that("Converting lengths does not affect non-Suisun data", {
    
    expect_equal(nrow(df_converted_compare), 0)
    
})

rm(list = ls())
gc()