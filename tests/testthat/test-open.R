test_that("open_survey opens the survey data, and it contains expected variables", {
  surv <- open_survey()
  expect_true("FileSystemDataset" %in% class(surv))
  expect_true(all(c("SampleID", "Date", "Longitude") %in% names(surv)))
})

test_that("open_fish opens the fish data, and it contains expected variables", {
    fish <- open_fish()
    expect_true("FileSystemDataset" %in% class(fish))
    expect_true(all(c("SampleID", "Length", "Count") %in% names(fish)))
})

test_that("open_length_conv opens the survey data, and it contains expected variables", {
    length_conv <- open_length_conv()
    expect_true("FileSystemDataset" %in% class(length_conv))
    expect_true(all(c("Taxa", "Intercept", "Slope") %in% names(length_conv)))
})