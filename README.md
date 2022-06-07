
# deltafish <a href="https://delta-stewardship-council.github.io/deltafish/"><img src="man/figures/logo.png" align="right" height="139" /></a>

Credit to [Brian Mahardja](https://github.com/bmahardja) for the Delta Smelt drawing in the logo. 

<!-- badges: start -->
[![R-CMD-check](https://github.com/Delta-Stewardship-Council/deltafish/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Delta-Stewardship-Council/deltafish/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/Delta-Stewardship-Council/deltafish/branch/main/graph/badge.svg)](https://app.codecov.io/gh/Delta-Stewardship-Council/deltafish?branch=main)
  [![r-universe](https://sbashevkin.r-universe.dev/badges/deltafish)](https://sbashevkin.r-universe.dev/ui#package:deltafish)
  [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6484439.svg)](https://doi.org/10.5281/zenodo.6484439)
  [![Data DOI](https://img.shields.io/badge/Data%20publication%20DOI-10.6073/pasta/0cdf7e5e954be1798ab9bf4f23816e83-blue.svg)](https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier=1075)
<!-- badges: end -->

The goal of `deltafish` is to provide easy access to the [integrated San Fransisco estuary Delta fish dataset](https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier=1075&revision=1). This dataset is published, citeable, and documented on [EDI](https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier=1075&revision=1). The dataset contains around 45 million rows, which are not easily queryable with normal R techniques. `deltafish` utilizes the R implementation of [Apache Arrow](https://arrow.apache.org/docs/r/) and the [parquet](https://parquet.apache.org/documentation/latest/) data format, along with `dbplyr` to make the process of working with this large dataset much easier on a standard computer. 

You can use `dplyr` verbs to query the arrow dataset in much the same way as you would a `data.frame`. Instead of computing your function return value every time you execute a `dplyr` function call, however, `arrow` builds a query on the backend which is only run when you `collect()` the data. This means you execute far fewer queries and are able to work with the data much more efficiently.

To begin, install the package as below and run `create_fish_db()`. This will download the data and create the arrow dataset.

## Installation

You can install the package via github:
``` r
devtools::install_github("Delta-Stewardship-Council/deltafish")
```

Or via r-universe:

``` r
# Enable this universe
options(repos = c(
    sbashevkin = 'https://sbashevkin.r-universe.dev',
    CRAN = 'https://cloud.r-project.org'))

# Install the package
install.packages('deltafish')
```

## Example

First build the database. This takes a bit to run since the source data are large.

``` r
library(deltafish)
create_fish_db()
```

Then open and query data.

```r
# dplyr required for queries below
library(dplyr)

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

## Data updating and versioning

When the integrated dataset is updated, you do not need to update your installation of the `deltafish` package. Instead, you can access the latest data by re-building the cached database via 

``` r
library(deltafish)
create_fish_db(update=TRUE)
```

Or, you can specify the exact version of the data package you wish to use. This enables reproducibility by ensuring the correct data package version is used. 

``` r
library(deltafish)
create_fish_db(edi_pid="edi.1075.1")
```

To create a fully reproducible workflow, you should also note the `deltafish` package version used, which could always be installed later with e.g.,

``` r
devtools::install_github("Delta-Stewardship-Council/deltafish", ref="v0.2.0")
```
