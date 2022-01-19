create_fish_db()

test_that("open_survey opens the survey data, and it contains expected variables", {
  surv <- open_survey()
  expect_true("tbl_sql" %in% class(surv))
  expect_true(all(c("SampleID", "Date", "Longitude") %in% colnames(surv)))
})

test_that("open_fish opens the fish data, and it contains expected variables", {
    fish <- open_fish()
    expect_true("tbl_sql" %in% class(fish))
    expect_true(all(c("SampleID", "Length", "Count") %in% colnames(fish)))
})

test_that("open_length_conv opens the survey data, and it contains expected variables", {
    length_conv <- open_length_conv()
    expect_true("tbl_sql" %in% class(length_conv))
    expect_true(all(c("Taxa", "Intercept", "Slope") %in% colnames(length_conv)))
})