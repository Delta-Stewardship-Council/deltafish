library(withr)

cat("testing utility functions")
test_that("cached directories can be shown", {
  files <- show_cache()

  expect_true(length(files) > 0)
  expect_true(all(grepl("deltafish", files)))
})

test_that("cached revision can be found", {
  rev <- show_cached_revision()
  expect_true(grepl("^edi\\.1075\\.[0-9]+$", rev))
})

test_that("cache update status can be checked", {
  rev <- is_cache_updated()
  expect_true(rev)
})

test_that("check_EDI_cred is working correctly", {
    expect_error(with_envvar(new=c("EDI_API_KEY"="", "EDI_TOKEN"=""), check_EDI_cred()), 
                 regexp="^An EDI API key is now required by EDI.*")
    expect_no_error(with_envvar(new=c("EDI_API_KEY"="x"), check_EDI_cred()))
    expect_no_error(with_envvar(new=c("EDI_TOKEN"="x"), check_EDI_cred()))
})

cat("finished testing utility functions")
