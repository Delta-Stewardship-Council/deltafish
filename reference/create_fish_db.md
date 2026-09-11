# Create fish database

Function to create the fish database. Reads in raw data from the
published [EDI
dataset](https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier=1075&revision=1).

## Usage

``` r
create_fish_db(edi_pid = NULL, update = FALSE)
```

## Arguments

- edi_pid:

  (char) Optionally, a way to specify a specific revision of the
  dataset, in the format "edi.1075.1" Leave parameter unset to get the
  latest revision.

- update:

  (logical) If set to TRUE, will update to latest version from EDI if a
  newer version is available
