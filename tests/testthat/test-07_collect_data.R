library(dplyr)
library(lubridate)

con <- open_database()
raw <- open_survey(con) %>%
  summarise(
    N = n(),
    N_NA_Date = sum(as.integer(is.na(Date)), na.rm = T),
    N_NA_Datetime = sum(as.integer(is.na(Datetime)), na.rm = T),
    N_SE_1 = sum(Secchi_estimated, na.rm = T)
  ) %>%
  collect()

raw_no_dates_SE <- open_survey(con) %>%
  select(-Date, -Datetime, -Secchi_estimated) %>%
  collect()

col <- open_survey(con) %>%
  collect_data() %>%
  summarise(
    N = n(),
    N_NA_Date = sum(as.integer(is.na(Date))),
    N_NA_Datetime = sum(as.integer(is.na(Datetime))),
    N_SE_T = sum(Secchi_estimated, na.rm = T)
  )

col_no_dates_SE <- open_survey(con) %>%
  select(-Date, -Datetime, -Secchi_estimated) %>%
  collect_data()

post_filt_date <- open_survey(con) %>%
  select(Date, SampleID) %>%
  collect_data() %>%
  filter(Date > ymd("1999-12-31"))

post_filt_datetime <- open_survey(con) %>%
  select(Datetime, SampleID) %>%
  collect_data() %>%
  filter(hour(Datetime) > 12)

pre_filt_date <- open_survey(con) %>%
  select(Date, SampleID) %>%
  filter(Date > "1999-12-31") %>%
  collect_data()

pre_filt_date2 <- open_survey(con) %>%
  select(Date, SampleID) %>%
  filter(year(Date) > 1999) %>%
  collect_data()

pre_filt_datetime <- open_survey(con) %>%
  select(Datetime, SampleID) %>%
  filter(hour(Datetime) > 12) %>%
  collect_data()

test_that("collect_data does not change number of rows of survey dataset", {
  expect_equal(raw$N, col$N)
})

test_that("collect_data does not change the dataset when the date and datetime columns are missing", {
  expect_equal(raw_no_dates_SE, col_no_dates_SE)
})

test_that("collect_data does not change number of rows with NA dates", {
  expect_equal(raw$N_NA_Date, col$N_NA_Date)
})

test_that("collect_data does not change number of rows with NA datetimes", {
  expect_equal(raw$N_NA_Datetime, col$N_NA_Datetime)
})

test_that("collect_data does not change number of TRUE values for Secchi_estimated", {
  expect_equal(raw$N_SE_1, col$N_SE_T)
})

test_that("Filtering by date works correctly", {
  expect_equal(pre_filt_date, post_filt_date)
  expect_equal(pre_filt_date2, post_filt_date)
})

test_that("Filtering by datetime works correctly", {
  expect_equal(pre_filt_datetime, post_filt_datetime)
})


close_database(con)
rm(list = ls())
gc()
cat("\nfinished testing collect_data\n")
