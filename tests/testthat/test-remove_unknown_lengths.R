fish <- open_fish()%>%
    select(SampleID, Taxa, Count, Length)%>%
    compute()

df_removed_nu <- fish  %>%
    remove_unknown_lengths(univariate = FALSE) %>%  
    select(Length, Count)%>%
    compute()%>%
    summarise(N=n(), Length_NA=sum(as.integer(is.na(Length) & Count!=0), na.rm=T))%>%
    collect()

gc()

df_removed_u <- fish%>%
    remove_unknown_lengths(univariate = TRUE)  %>% 
    select(Length, Count)%>%
    compute()%>%
    summarise(N=n(), Length_NA=sum(as.integer(is.na(Length) & Count!=0), na.rm=T))%>% 
    collect()

gc()

df_full <- fish  %>% 
    select(Length, Count)%>%
    compute()%>%
    summarise(N=n(), Length_NA=sum(as.integer(is.na(Length) & Count!=0), na.rm=T))%>% 
    collect()

gc()

test_that("remove_unknown_lengths removes rows as expected", {
    
    expect_true(all(df_full$N > df_removed_u$N & df_removed_u$N > df_removed_nu$N))
    expect_true(all(df_removed_nu$Length_NA == 0 & df_removed_u$Length_NA == 0))

})

rm(list = ls())
gc()
