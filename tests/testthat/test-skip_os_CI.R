cat("testing skip_os_ci")
test_that("skip_os_ci runs without error on windows", {
    skip_os_ci("windows", ci="either")
    expect_condition(skip_os_ci("windows"), NA, class = "skip") 
})

test_that("skip_os_ci runs without error on linux", {
    skip_os_ci("linux", ci="either")
    expect_condition(skip_os_ci("linux"), NA, class = "skip") 
})

test_that("skip_os_ci runs without error on mac", {
    skip_os_ci("darwin", ci="either")
    expect_condition(skip_os_ci("darwin"), NA, class = "skip") 
})

test_that("skip_os_ci fails on wrong os", {
    expect_error(skip_os_ci("wallace"), "os can only include 'windows', 'darwin', or 'linux'.", fixed=TRUE)
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=FALSE, os="wallace"))
    expect_error(skip_os_ci("darwin"), "This function is only designed to work on 'windows', 'darwin', or 'linux' operating systems.", fixed=TRUE)
})

test_that("skip_os_ci fails on wrong logical argument", {
    expect_error(skip_os_ci("darwin", logical="xor"), "logical should be one of 'run' or 'ignore'.", fixed=TRUE)
})

test_that("skip_os_ci fails on wrong ci argument", {
    expect_error(skip_os_ci("darwin", ci="yes"), "ci should be one of 'ci', 'local', or 'either'.", fixed=TRUE)
})

test_that("skip_os_ci works", {
    # Windows, no CI
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=FALSE, os="windows"))
    expect_condition(skip_os_ci("darwin", logical="or", ci="local"), NA, class = "skip") # Not skip
    expect_condition(skip_os_ci("darwin", logical="and", ci="local"), class = "skip")  # skip
    expect_condition(skip_os_ci("darwin", logical="and", ci="ci"), class = "skip") # skip
    expect_condition(skip_os_ci("darwin", logical="or", ci="ci"), class = "skip")  # skip
    
    # Mac, no CI
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=FALSE, os="darwin"))
    expect_condition(skip_os_ci("darwin", logical="or", ci="local"), NA, class = "skip") # Not skip
    expect_condition(skip_os_ci("darwin", logical="and", ci="local"), NA, class = "skip")  # Not skip
    expect_condition(skip_os_ci("darwin", logical="and", ci="ci"), class = "skip") # skip
    expect_condition(skip_os_ci("darwin", logical="or", ci="ci"), NA, class = "skip")  # Not skip
    
    # Linux, no CI
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=FALSE, os="linux"))
    expect_condition(skip_os_ci("darwin", logical="or", ci="local"), NA, class = "skip") # Not skip
    expect_condition(skip_os_ci("darwin", logical="and", ci="local"), class = "skip")  # skip
    expect_condition(skip_os_ci("darwin", logical="and", ci="ci"), class = "skip") # skip
    expect_condition(skip_os_ci("darwin", logical="or", ci="ci"), class = "skip")  # skip
    
    # Windows, CI
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=TRUE, os="windows"))
    expect_condition(skip_os_ci("darwin", logical="or", ci="local"), class = "skip") # skip
    expect_condition(skip_os_ci("darwin", logical="and", ci="local"), class = "skip")  # skip
    expect_condition(skip_os_ci("darwin", logical="and", ci="ci"), class = "skip") # skip
    expect_condition(skip_os_ci("darwin", logical="or", ci="ci"), NA, class = "skip")  # not skip
    
    # Mac, no CI
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=TRUE, os="darwin"))
    expect_condition(skip_os_ci("darwin", logical="or", ci="local"), NA, class = "skip") # not skip
    expect_condition(skip_os_ci("darwin", logical="and", ci="local"), class = "skip")  # skip
    expect_condition(skip_os_ci("darwin", logical="and", ci="ci"), NA, class = "skip") # not skip
    expect_condition(skip_os_ci("darwin", logical="or", ci="ci"), NA, class = "skip")  # not skip
    
    # Linux, no CI
    mockery::stub(skip_os_ci, "check_os_ci", function() list(ci=TRUE, os="linux"))
    expect_condition(skip_os_ci("darwin", logical="or", ci="local"), class = "skip") # skip
    expect_condition(skip_os_ci("darwin", logical="and", ci="local"), class = "skip")  # skip
    expect_condition(skip_os_ci("darwin", logical="and", ci="ci"), class = "skip") # skip
    expect_condition(skip_os_ci("darwin", logical="or", ci="ci"), NA, class = "skip")  # not skip
    stop("forcing failure")
    
})
cat("finished testing skip_os_ci")