#' Connect fish database
#' 
#' Connect to the fish database stored in the package
#'
#' @return conn A database connection object
#' @export
#'
#' @examples
#' 
#' con <- connect_fish_db()
#' 
connect_fish_db <- function(){
    # open dataset
    survey  <- arrow::open_dataset(system.file(package = "deltaFish", "extdata", "survey"), partitioning = "Source")
    fish  <- arrow::open_dataset(system.file(package = "deltaFish", "extdata", "fish"), partitioning = "Taxa")
    length_conv  <- arrow::open_dataset(system.file(package = "deltaFish", "extdata", "length_conversion"))
    
    # open connection to DuckDB
    con <- DBI::dbConnect(duckdb::duckdb())
    
    # register the dataset as a DuckDB table, and give it a name
    duckdb::duckdb_register_arrow(con, "survey", survey)
    duckdb::duckdb_register_arrow(con, "fish", fish)
    duckdb::duckdb_register_arrow(con, "length_conversion", length_conv)
    
    return(con)
}