cat("testing remove_unknown_lengths")

con <- open_database()
fish <- open_fish(con, quiet = TRUE)

df_removed_nu <- fish %>%
  select(SampleID, Taxa, Count, Length) %>%
  remove_unknown_lengths(univariate = FALSE) %>%
  select(Length, Count) %>%
  summarise(
    N = n(),
    Length_NA = sum(as.integer(is.na(Length) &
      Count != 0), na.rm = T),
    N_0 = sum(as.integer(Count == 0), na.rm = T)
  ) %>%
  collect_data()

df_removed_u <- fish %>%
  select(SampleID, Taxa, Count, Length) %>%
  remove_unknown_lengths(univariate = TRUE) %>%
  select(Length, Count) %>%
  summarise(
    N = n(),
    Length_NA = sum(as.integer(is.na(Length) &
      Count != 0), na.rm = T),
    N_0 = sum(as.integer(Count == 0), na.rm = T)
  ) %>%
  collect_data()

df_full <- fish %>%
  select(Length, Count) %>%
  summarise(
    N = n(),
    Length_NA = sum(as.integer(is.na(Length) &
      Count != 0), na.rm = T),
    N_0 = sum(as.integer(Count == 0), na.rm = T)
  ) %>%
  collect_data()


test_that("remove_unknown_lengths removes rows as expected", {
  expect_true(df_full$N > df_removed_u$N &
    df_removed_u$N > df_removed_nu$N)
  expect_true(df_removed_nu$Length_NA == 0 &
    df_removed_u$Length_NA == 0)
})

test_that("Zero counts are retained by remove_unknown_lengths", {
  expect_gt(df_removed_nu$N_0, 0)
  expect_gt(df_removed_u$N_0, 0)
  expect_gt(df_full$N_0, 0)
  expect_true(df_full$N_0 == df_removed_u$N_0 &
    df_removed_u$N_0 > df_removed_nu$N_0)
})
close_database(con)
rm(list = ls())
gc()
cat("finished testing remove_unknown_lengths\n")
