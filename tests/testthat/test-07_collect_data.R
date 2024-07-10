library(dplyr)

con <- open_database()
raw<-open_survey(con)%>%
    summarise(N=n(),
              N_NA_Date=sum(as.integer(is.na(Date)), na.rm=T),
              N_NA_Datetime=sum(as.integer(is.na(Datetime)), na.rm=T))%>%
    collect()

raw_no_dates<-open_survey(con)%>%
    select(-Date, -Datetime)%>%
    collect()

col<-open_survey(con)%>%
    collect_data()%>%
    summarise(N=n(),
              N_NA_Date=sum(as.integer(is.na(Date))),
              N_NA_Datetime=sum(as.integer(is.na(Datetime))))

col_no_dates<-open_survey(con)%>%
    select(-Date, -Datetime)%>%
    collect_data()

test_that("collect_data does not change number of rows of survey dataset", {
    expect_equal(raw$N, col$N)
})

test_that("collect_data does not change the dataset when the date and datetime columns are missing", {
    expect_equal(raw_no_dates, col_no_dates)
})

test_that("collect_data does not change number of rows with NA dates", {
    expect_equal(raw$N_NA_Date, col$N_NA_Date)
})

test_that("collect_data does not change number of rows with NA datetimes", {
    expect_equal(raw$N_NA_Datetime, col$N_NA_Datetime)
})


close_database(con)
rm(list = ls())
gc()
cat("\nfinished testing collect_data")