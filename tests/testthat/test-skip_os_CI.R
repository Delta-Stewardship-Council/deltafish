test_that("skip_os_CI works", {
    # Windows, no CI
    withr::local_envvar(CI = "")
    mockery::stub(skip_os_CI, "Sys.info", function() list(sysname="windows"))
    expect_condition(skip_os_CI("darwin"), NA, class = "skip") 
    
    # Mac, no CI
    withr::local_envvar(CI = "")
    mockery::stub(skip_os_CI, "Sys.info", function() list(sysname="darwin"))
    expect_condition(skip_os_CI("darwin"), NA, class = "skip") 
   
    # Linux, no CI
    withr::local_envvar(CI = "")
    mockery::stub(skip_os_CI, "Sys.info", function() list(sysname="linux"))
    expect_condition(skip_os_CI("darwin"), NA, class = "skip") 
    
    # Windows, CI SHOULD SKIP
    withr::local_envvar(CI = "true")
    mockery::stub(skip_os_CI, "Sys.info", function() list(sysname="windows"))
    expect_condition(skip_os_CI("darwin"), class = "skip") 
    
    # Mac, no CI
    withr::local_envvar(CI = "true")
    mockery::stub(skip_os_CI, "Sys.info", function() list(sysname="darwin"))
    expect_condition(skip_os_CI("darwin"), NA, class = "skip") 
    
    # Linux, no CI SHOULD SKIP
    withr::local_envvar(CI = "true")
    mockery::stub(skip_os_CI, "Sys.info", function() list(sysname="linux"))
    expect_condition(skip_os_CI("darwin"), class = "skip") 
    
})
