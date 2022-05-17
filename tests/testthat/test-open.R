create_fish_db()
surv <- open_survey()
fish <- open_fish()
length_conv <- open_length_conv()

test_that("open_survey opens the survey data, and it contains expected variables", {
    expect_true("FileSystemDataset" %in% class(surv))
    expect_true(all(c("SampleID", "Date", "Longitude") %in% names(surv)))
})

test_that("open_fish opens the fish data, and it contains expected variables", {
    expect_true("FileSystemDataset" %in% class(fish))
    expect_true(all(c("SampleID", "Length", "Count") %in% names(fish)))
})

test_that("open_length_conv opens the survey data, and it contains expected variables", {
    expect_true("FileSystemDataset" %in% class(length_conv))
    expect_true(all(c("Species", "Intercept", "Slope") %in% names(length_conv)))
})