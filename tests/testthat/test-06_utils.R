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

cat("finished testing utility functions")
