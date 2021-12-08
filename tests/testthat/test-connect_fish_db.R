test_that("connect_fish_db generates valid connection object", {
  con <- connect_fish_db()
  expect_equal(class(con), "duckdb_connection", ignore_attr = TRUE)
})

test_that("connect_fish_db connection can access all tables, and tables contain expected variables", {
    con <- connect_fish_db()
    
    fish <- tbl(con, "fish")
    expect_true(all(c("SampleID", "Length", "Count") %in% tbl_vars(fish)))
    
    surv <- tbl(con, "survey")
    expect_true(all(c("SampleID", "Date", "Longitude") %in% tbl_vars(surv)))
    
    length_conv <- tbl(con, "length_conversion")
    expect_true(all(c("Taxa", "Intercept", "Slope") %in% tbl_vars(length_conv)))
})