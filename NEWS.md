# deltafish 1.0.0

## Major changes

* Changed the backend from `arrow` to `RSQLight` to increase reliability and improve performance. Some changes to the interface were necessary to implement this and users should read the readme for updated instructions. 

## Minor Changes

* Fixed bug where `create_fish_db` failed when a prior cache was present without a revision file. 
* Adding `download_method` parameter to `create_fish_db` to help users download files given their specific limitations

# deltafish 0.2.0

* Add `pkgdown` website
* Implement EDI data package version checking and specification withn `create_fish_db`
* Remove dependency on `duckdb` and add dependency to `arrow` >= v8.0.0
* Fix `remove_unknown_lengths` to ignore 0-counts when finding samples to remove
* Change `convert_lengths` function so it no longer collects the full dataset
* Add tests to mirror what was previously tested in package `LTMRdata`
* Reconfigure internals so internal functions can now read/write database from a specificed cache folder
* Added a `NEWS.md` file to track changes to the package.

# deltafish 0.1.0

* Initialize package and database from EDI data publication
