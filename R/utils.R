#' Show revision number of cached files
#'
#' This function returns the EDI revision number of the cached data.
#'
#' @param cache_dir (char) The cache directory, by default set to deltafish for most use cases.
#' @return (char) The revision number in the cache
#' @export
#'
show_cached_revision <- function(cache_dir = "deltafish") {
  rev <- scan(file.path(rappdirs::user_cache_dir(cache_dir), "revision.txt"),
    what = "char",
    quiet = TRUE
  )
  return(rev)
}


#' Show list of cached deltafish files
#'
#' This function returns a list of files cached for the package.
#'
#'
#' @return (list) A list of files
#' @export
#'
show_cache <- function() {
  dir(rappdirs::user_cache_dir("deltafish"), full.names = TRUE, recursive = TRUE)
}


#' Clear cached deltafish files (internal)
#'
#' This function removes all cached files associated with the package
#' and allows you to set the cache_dir
#'
#' @return (NULL)
#' @noRd
#'
clear_cache_f <- function(cache_dir) {
  files <- dir(rappdirs::user_cache_dir(cache_dir), full.names = TRUE, recursive = TRUE)
  if (length(files) > 0) {
    message("Removing existing cache.")
    lapply(files, file_remove_tryer)
    return(invisible(NULL))
  } else {
    message("No cache to remove.")
  }
}


#' Clear cached deltafish files
#'
#' This function removes all cached files associated with the package
#'
#'
#' @return (NULL)
#' @export
#'
clear_cache <- function() {
  clear_cache_f(cache_dir = "deltafish")
}


#' Is cached data up to date with latest EDI data
#'
#' Returns TRUE for up to date, FALSE if a newer version exists
#'
#' @param cache_dir (char) The cache directory, by default set to deltafish for most use cases.
#' @return (logical) Whether cache is up to date
#' @export
#'
is_cache_updated <- function(cache_dir = "deltafish") {
  # if revision file doesn't exist, return FALSE triggering an update
  if (!file.exists(file.path(rappdirs::user_cache_dir(cache_dir), "revision.txt"))) {
    return(FALSE)
  }

  rev <- scan(file.path(rappdirs::user_cache_dir(cache_dir), "revision.txt"),
    what = "char",
    quiet = TRUE
  )

  t <- EDIutils::list_data_package_revisions("edi", "1075")
  edi_rev <- t[length(t)]

  cache_rev <- strsplit(rev, ".", fixed = T)[[1]][3]

  if (edi_rev > cache_rev) {
    return(FALSE)
  } else if (edi_rev <= cache_rev) {
    return(TRUE)
  }
}

file_remove_tryer <- function(x) {
  tryCatch(
    {
      file.remove(x)
    },
    error = function(y) {
      print(y)
      message("If you get a permissions error, try running close_database(con), then trying again. Otherwise, try restarting R and then clearing your cache.")
      return(invisible(NULL))
    },
    warning = function(y) {
      print(y)
      message("If you get a permissions error, try running close_database(con), then trying again. Otherwise, try restarting R and then clearing your cache.")
      return(invisible(NULL))
    }
  )
}

#' Skip tests helper
#'
#' This function skips tests not using the given operating system and on a CI platform
#'
#' @noRd
#'

check_os_ci <- function() {
  ci <- isTRUE(as.logical(Sys.getenv("CI", "false")))

  os <- tolower(Sys.info()[["sysname"]])

  out <- list(ci = ci, os = os)

  return(out)
}

#' Skip tests helper
#'
#' This function skips tests not using the given operating system and depending on the CI preference
#'
#' @noRd
#'
skip_os_ci <- function(os, logical = "or", ci = "either") {
  if (any(!os %in% c("windows", "darwin", "linux"))) {
    stop("os can only include 'windows', 'darwin', or 'linux'.")
  }

  if (!ci %in% c("ci", "local", "either")) {
    stop("ci should be one of 'ci', 'local', or 'either'.")
  }

  if (!logical %in% c("or", "and")) {
    stop("logical should be one of 'run' or 'ignore'.")
  }

  os_ci <- check_os_ci()

  if (!os_ci$os %in% c("windows", "darwin", "linux")) {
    stop("This function is only designed to work on 'windows', 'darwin', or 'linux' operating systems.")
  }

  if (logical == "or") {
    log_fun <- `|`
  } else {
    log_fun <- `&`
  }

  if (log_fun(os_ci$os %in% os, (ci == "either" | (os_ci$ci & ci == "ci") | (!os_ci$ci & ci == "local")))) {
    return(invisible(TRUE)) # don't skip
  }

  # Otherwise skip
  msg <- paste0("Test only run when os is one of: ", paste(os, collapse = ", "), ifelse(ci != "either", paste0(" ", toupper(logical), " platform is ", ci), ""))
  testthat::skip(msg)
}

#' get EDI pids helper
#'
#' Get EDI pids needed for the package from a package ID
#'
#' @noRd
#'
get_edi_pids <- function(package_id) {
  res <- EDIutils::read_data_entity_names(packageId = package_id)

  len <- grep("[L|l]ength.conversion", res$entityName)
  com <- grep("[C|c]ompress", res$entityName)

  pids <- list(
    length = res$entityId[len],
    compressed = res$entityId[com]
  )
  return(pids)
}


#' get EDI latest version
#'
#' Get EDI latest version helper
#'
#' @noRd
#'
get_latest_EDI_revision <- function() {
  t <- EDIutils::list_data_package_revisions("edi", "1075")
  t_final <- t[length(t)]

  return(paste0("edi.1075.", as.character(t_final)))
}
