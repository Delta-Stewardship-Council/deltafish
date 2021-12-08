
# deltaFish


The goal of deltaFish is to provide easy access to the integrated fish dataset.

## Installation

``` r
devtools::install_github("jeanetteclark/deltaFish")
```

## Example


``` r
library(deltaFish)
library(dplyr)

# connect to fish database stored in the package
con <- connect_fish_db()

# grab the two tables we need
surv <- tbl(con, "survey")
fish <- tbl(con, "fish")

# do some special filtering
# syntax is a bit different because are using parquet files
# see: https://www.richpauloo.com/post/parquet/
surv_FMWT <- surv %>% 
    filter(Source == "Source=FMWT") %>% 
    select(SampleID, Date)

fish_smelt <- fish %>% 
    filter(Taxa == "Taxa=Spirinchus thaleichthys")

# do a join and collect the resulting data frame
# collect executes the sql query and gives you a table
df <- left_join(surv_FMWT, fish_smelt) %>% 
    collect() 

```

