# Collect data into R

Collect data into R and convert dates/datetimes into the correct data
types with the correct time zone. It is recommended to use this function
instead of `collect` because the database RSQLite does not support date
and time data types, so they are stored as character vectors. Although
some date and time operations are still possible, when you `collect` the
dataset, the Date and Datetime columns will be character vectors. This
function will convert those columns (if they exist in your collected
dataset) into the correct date and datetime format. RSQLite also does
not have a logical data type and logical values are stored as integers.
Thus, the Secchi_estimated column is converted to logical by this
function as well.

## Usage

``` r
collect_data(data)
```

## Arguments

- data:

  A DBI table that can be treated like a data.frame. See
  [`open_fish()`](https://delta-stewardship-council.github.io/deltafish/reference/open_fish.md)
  and
  [`open_survey()`](https://delta-stewardship-council.github.io/deltafish/reference/open_survey.md)
