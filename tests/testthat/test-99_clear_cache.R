test_that("cache can be cleared", {
    skip_os_ci(c("darwin", "windows", "linux"), logical="and", ci="ci")
    clear_cache()
    files <- show_cache()
    
    expect_true(length(files) == 0)
    
})

test_that("cleared cache induces the expected message in clear_cache()", {
    skip_os_ci(c("darwin", "windows", "linux"), logical="and", ci="ci")
    clear_cache()
    
    expect_message(clear_cache(), "No cache to remove.", fixed=TRUE)
    
})

cat("finished testing cache clearing")