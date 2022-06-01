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