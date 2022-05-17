
test_that("skip_os_ci runs without error on windows", {
    skip_os_ci("windows", check_ci=FALSE)
    expect_condition(skip_os_ci("windows"), NA, class = "skip") 
})

test_that("skip_os_ci runs without error on linux", {
    skip_os_ci("linux", check_ci=FALSE)
    expect_condition(skip_os_ci("linux"), NA, class = "skip") 
})

test_that("skip_os_ci runs without error on mac", {
    skip_os_ci("darwin", check_ci=FALSE)
    expect_condition(skip_os_ci("darwin"), NA, class = "skip") 
})

test_that("skip_os_ci fails on wrong os", {
    expect_error(skip_os_ci("wallace"), "os can only include 'windows', 'darwin', or 'linux'.", fixed=TRUE)
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=FALSE, os="wallace"))
    expect_error(skip_os_ci("darwin"), "This function is only designed to work on 'windows', 'darwin', or 'linux' operating systems.", fixed=TRUE)
})

test_that("skip_os_ci works", {
    # Windows, no CI
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=FALSE, os="windows"))
    expect_condition(skip_os_ci("darwin"), NA, class = "skip") 
    
    # Mac, no CI
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=FALSE, os="darwin"))
    expect_condition(skip_os_ci("darwin"), NA, class = "skip") 
    
    # Linux, no CI
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=FALSE, os="linux"))
    expect_condition(skip_os_ci("darwin"), NA, class = "skip") 
    
    # Windows, CI SHOULD SKIP
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=TRUE, os="windows"))
    expect_condition(skip_os_ci("darwin"), class = "skip") 
    
    # Mac, no CI
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=TRUE, os="darwin"))
    expect_condition(skip_os_ci("darwin"), NA, class = "skip") 
    
    # Linux, no CI SHOULD SKIP
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=TRUE, os="linux"))
    expect_condition(skip_os_ci("darwin"), class = "skip") 
    
})
