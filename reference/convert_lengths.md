# Convert fish length

Converts fish length data using the length conversion table. Returns an
arrow dataset. This function is only needed to convert Suisun survey
data.

## Usage

``` r
convert_lengths(data)
```

## Arguments

- data:

  A DBI table that can be treated like a data.frame, with fish data. See
  [`open_fish()`](https://delta-stewardship-council.github.io/deltafish/reference/open_fish.md)

## Value

data_conv A DBI table with converted lengths

## Examples

``` r
if (FALSE) { # \dontrun{
library(dplyr)
con <- open_database()
fish <- open_fish(con) %>%
  filter(Taxa %in% c("Dorosoma petenense", "Morone saxatilis", "Spirinchus thaleichthys"))

fish_conv <- convert_lengths(fish) %>%
  collect()
close_database(con)
} # }
```
