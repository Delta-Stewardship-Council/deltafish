#' Connect to database (internal)
#'
#' @param cache_dir name of cache directory
#' @return con A DBI connection object
#' @noRd

open_database_f <- function(cache_dir) {
  if (!(dir.exists(rappdirs::user_cache_dir(cache_dir)))) {
    stop("Cache directory does not exist. Try running `create_fish_db().")
  }

  con <- DBI::dbConnect(RSQLite::SQLite(), dbname = file.path(rappdirs::user_cache_dir(cache_dir), "deltafish.sqlite"), extended_types = TRUE)

  return(con)
}

#' Connect to database
#'
#' Connect to the fish database stored in local cache directory.
#'
#' @return con A DBI connection object
#' @export

open_database <- function() {
  cache_dir <- "deltafish"

  if (!(dir.exists(rappdirs::user_cache_dir(cache_dir)))) {
    stop("Cache directory does not exist. Try running `create_fish_db().")
  }

  con <- open_database_f(cache_dir)

  return(con)
}


#' Connect fish data
#'
#' Connect to the fish table stored in the database
#'
#' @param con A DBI connection object from open_database()
#' @param quiet silence message about fish length units.
#' @import dbplyr
#' @return A DBI table that can be treated like a data.frame, with fish data
#' @export

open_fish <- function(con, quiet = FALSE) {
  if (any(lapply(show_cache(), tools::file_ext) == "parquet")) {
    stop("Parquet files detected in cache. This version of deltafish uses SQLite as the backend. Please run clear_cache(), then create_fish_db() to update your local copy.")
  }

  if (missing(con)) {
    stop("argument 'con' must be provided. This should be the object created by open_database()")
  }

  if (!quiet) {
    message("Note: fish length units are not all compatible across surveys. The Suisun study uses standard length while the other surveys use fork/total length. Use deltafish::convert_lengths to convert the length units of the 20 taxa for which we have conversion equations from standard length to fork/total length. ")
  }

  fish <- dplyr::tbl(con, "fish")
  return(fish)
}

#' Connect survey data
#'
#' Connect to the survey table stored in the database
#'
#' @param con A DBI connection object from open_database()
#' @import dbplyr
#' @return A DBI table that can be treated like a data.frame, with survey data
#' @export

open_survey <- function(con) {
  if (any(lapply(show_cache(), tools::file_ext) == "parquet")) {
    stop("Parquet files detected in cache. This version of deltafish uses SQLite as the backend. Please run clear_cache(), then create_fish_db() to update your local copy.")
  }

  if (missing(con)) {
    stop("argument 'con' must be provided. This should be the object created by open_database()")
  }

  survey <- dplyr::tbl(con, "survey")
  return(survey)
}

#' Connect length conversion data
#'
#' Connect to the length conversion table stored in the database
#'
#' @param con A DBI connection object from open_database()
#' @import dbplyr
#' @return A DBI table that can be treated like a data.frame, with length conversion data
#' @export

open_length_conv <- function(con) {
  if (any(lapply(show_cache(), tools::file_ext) == "parquet")) {
    stop("Parquet files detected in cache. This version of deltafish uses SQLite as the backend. Please run clear_cache(), then create_fish_db() to update your local copy.")
  }

  if (missing(con)) {
    stop("argument 'con' must be provided. This should be the object created by open_database()")
  }

  lconv <- dplyr::tbl(con, "length_conversion")
  return(lconv)
}

#' Collect data into R
#'
#' Collect data into R and convert dates/datetimes into the correct data types with the correct time zone.
#' It is recommended to use this function instead of \code{collect} because the database RSQLite does not
#' support date and time data types, so they are stored as character vectors.
#' Although some date and time operations are still possible, when you \code{collect} the dataset, the
#' Date and Datetime columns will be character vectors. This function will convert those columns
#' (if they exist in your collected dataset) into the correct date and datetime format.
#' RSQLite also does not have a logical data type and logical values are stored as integers.
#' Thus, the Secchi_estimated column is converted to logical by this function as well.
#'
#' @param data A DBI table that can be treated like a data.frame. See `open_fish()` and `open_survey()`
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @export
collect_data <- function(data) {
  data %>%
    dplyr::collect() %>%
    {
      if ("Date" %in% names(.)) {
        dplyr::mutate(., Date = lubridate::ymd(.data$Date))
      } else {
        .
      }
    } %>%
    {
      if ("Datetime" %in% names(.)) {
        dplyr::mutate(., Datetime = lubridate::parse_date_time(.data$Datetime, orders = c("%Y-%m-%d %H:%M:%S", "%Y-%m-%d"), tz = "America/Los_Angeles"))
      } else {
        .
      }
    } %>%
    {
      if ("Secchi_estimated" %in% names(.)) {
        dplyr::mutate(., Secchi_estimated = as.logical(.data$Secchi_estimated))
      } else {
        .
      }
    }
}

#' Close connection to database
#'
#' Close connection to SQLite database. Recommended at the end of every session.
#'
#' @param con A DBI connection object from open_database()
#'
#' @export
close_database <- function(con = NULL) {
  if (missing(con)) {
    stop("argument 'con' must be provided. This should be the object created by open_database()")
  }
  DBI::dbDisconnect(con)
}
