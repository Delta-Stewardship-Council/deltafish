test_that("create_fish_db works correctly when a revision file is not present", {
    skip_os_ci(c("darwin", "windows", "linux"), logical="and", ci="ci")
    # Remove revision file
    expect_true(file.remove(file.path(rappdirs::user_cache_dir("deltafish"), "revision.txt")))
    
    expect_message(create_fish_db(), 
                   "Unknown version installed. If you wish to re-install the cache with a known version, run clear_cache() then create_fish_db().",
                   fixed=TRUE)
    
})

