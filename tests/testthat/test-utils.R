test_that("cached directories can be shown", {
  files <- show_cache()
  
  expect_true(length(files) > 0)
  expect_true(all(grepl("deltafish", files)))
})

test_that("cached revision can be found", {
    rev<-show_cached_revision()
    expect_true(grepl("^edi\\.1075\\.[0-9]+$", rev))
})

test_that("cache update status can be checked", {
    rev<-is_cache_updated()
    expect_true(rev)
})

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