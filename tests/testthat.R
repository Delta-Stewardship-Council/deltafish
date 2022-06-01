library(testthat)
library(deltafish)

cat("starting to create database")
create_fish_db()
cat("finished creating database")

test_check("deltafish")
