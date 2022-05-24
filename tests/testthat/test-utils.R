test_that("cached directories can be shown", {
  files <- show_cache()
  
  expect_true(length(files) > 0)
  expect_true(all(grepl("deltafish", files)))
})


test_that("cache can be cleared", {
  
    clear_cache()
    files <- show_cache()
    
    expect_true(length(files) == 0)
      
})