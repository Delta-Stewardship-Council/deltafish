cat("testing the open functions")
con <- open_database()
surv <- open_survey(con)
fish <- open_fish(con, quiet = TRUE)
length_conv <- open_length_conv(con)

test_that("open_survey opens the survey data, and it contains expected variables", {
  expect_true("tbl_dbi" %in% class(surv))
  expect_true(all(c("SampleID", "Date", "Longitude") %in% colnames(surv)))
})

test_that("open_fish opens the fish data, and it contains expected variables", {
  expect_true("tbl_dbi" %in% class(fish))
  expect_true(all(c("SampleID", "Length", "Count") %in% colnames(fish)))
})

test_that("open_length_conv opens the survey data, and it contains expected variables", {
  expect_true("tbl_dbi" %in% class(length_conv))
  expect_true(all(c("Species", "Intercept", "Slope") %in% colnames(length_conv)))
})

test_that("opening from a cache that doesn't exist returns an error", {
  expect_error(deltafish:::open_survey_f("foo"))
  expect_error(deltafish:::open_fish_f("foo", quiet = TRUE))
  expect_error(deltafish:::open_length_conv_f("foo"))
})

close_database(con)
cat("finished testing the open functions\n")
