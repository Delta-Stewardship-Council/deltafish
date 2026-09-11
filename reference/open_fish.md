# Connect fish data

Connect to the fish table stored in the database

## Usage

``` r
open_fish(con, quiet = FALSE)
```

## Arguments

- con:

  A DBI connection object from open_database()

- quiet:

  silence message about fish length units.

## Value

A DBI table that can be treated like a data.frame, with fish data
