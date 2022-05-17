# Skip these test if on CI, and not using mac
skip_os_ci("darwin")

surv <- open_survey()
fish <- open_fish()
length_conv <- open_length_conv()

df_removed_nu <- dplyr::inner_join(fish, surv) %>%
    remove_unknown_lengths(univariate = FALSE) %>% 
    summarise(N=n(), Length_NA=sum(as.integer(is.na(Length) & Count!=0), na.rm=T))%>%
    collect()

df_removed_u <- dplyr::inner_join(fish, surv) %>%
    remove_unknown_lengths(univariate = TRUE)  %>% 
    summarise(N=n(), Length_NA=sum(as.integer(is.na(Length) & Count!=0), na.rm=T))%>% 
    collect()

df_full <- dplyr::inner_join(fish, surv)  %>% 
    summarise(N=n(), Length_NA=sum(as.integer(is.na(Length) & Count!=0), na.rm=T))%>% 
    collect()

test_that("remove_unknown_lengths removes rows as expected", {
    
    expect_true(df_full$N > df_removed_u$N & df_removed_u$N > df_removed_nu$N)
    expect_true(df_removed_nu$Length_NA == 0 & df_removed_u$Length_NA == 0)

})

rm(list = ls())
gc()
