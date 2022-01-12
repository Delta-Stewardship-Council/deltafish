
# deltaFish


The goal of deltaFish is to provide easy access to the integrated fish dataset.

## Installation

``` r
devtools::install_github("jeanetteclark/deltaFish")
```

## Example

First build the database. This takes a bit to run since the source data is large.

``` r
library(deltaFish)
create_fish_db()
```

Then open and query data.

```r

# open our two data files
surv <- open_survey()
fish <- open_fish()

# filter for sources and taxa of interest
surv_FMWT <- surv %>% 
    filter(Source == "FMWT") %>% 
    select(SampleID, Date)

fish_smelt <- fish %>% 
    filter(Taxa %in% c("Dorosoma petenense", "Morone saxatilis", "Spirinchus thaleichthys"))


# do a join and collect the resulting data frame
# collect executes the sql query and gives you a table
df <- left_join(surv_FMWT, fish_smelt) %>% 
    collect() 

```

