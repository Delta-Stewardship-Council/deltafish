# Remove unknown fish lengths

Removes unknown fish lengths. Returns a DBI table.

## Usage

``` r
remove_unknown_lengths(data, univariate)
```

## Arguments

- data:

  A DBI table that can be treated like a data.frame, with fish data. See
  [`open_fish()`](https://delta-stewardship-council.github.io/deltafish/reference/open_fish.md)

- univariate:

  (logical) Will these data be used for univariate analyses
  (`univariate=TRUE`)? Or multi-species analyses (`univariate=FALSE`)?
  If univariate, when a `Length_NA_flag=="Unknown length"` record is
  found, all records of that taxa from that sample are removed. In
  effect, this is transforming those records into missing data. If
  `univariate=FALSE`, when a `Length_NA_flag=="Unknown length"` record
  is found, the entire sample is removed and no 0s are filled in, since
  accurate community data cannot be confirmed for that sample.

## Value

data_known A DBI table with only known lengths
