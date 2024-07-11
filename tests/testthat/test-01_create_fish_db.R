library(testthat)
library(deltafish)
library(dplyr)
cat("starting to create database\n")
create_fish_db()
cat("finished creating database\n")

cat("testing the outcome of create_fish_db\n")
con <- open_database()
datetimes <- open_survey(con) %>%
    distinct(Date, Datetime) %>%
    collect_data()

surv_coltypes<-open_survey(con)%>%head()%>%collect()%>%sapply(typeof)
fish_coltypes<-open_fish(con)%>%head()%>%collect()%>%sapply(typeof)

fish_coltypes_expected<-c(
    "SampleID" = "character",
    "Taxa" = "character",
    "Length" = "double",
    "Count" = "double",
    "Notes_catch" = "character"
)
if(deltafish:::show_cached_revision()=="edi.1075.1"){
    surv_coltypes_expected<-c(
        "Source" = "character",
        "Station" = "character",
        "Latitude" = "double",
        "Longitude" = "double",
        "Date" = "character",
        "Datetime" = "character",
        "Survey" = "double",
        "Depth" = "double",
        "SampleID" = "character",
        "Method" = "character",
        "Tide" = "character",
        "Sal_surf" = "double",
        "Sal_bot" = "double",
        "Temp_surf" = "double",
        "Secchi" = "double",
        "Secchi_estimated" = "integer",
        "Tow_duration" = "double",
        "Tow_area" = "double",
        "Tow_volume" = "double",
        "Cable_length" = "double",
        "Tow_direction" = "character",
        "Notes_tow" = "character",
        "Notes_flowmeter" = "character"
    )
}else{
    surv_coltypes_expected<-c(
        "Source" = "character",
        "Station" = "character",
        "Latitude" = "double",
        "Longitude" = "double",
        "Date" = "character",
        "Datetime" = "character",
        "Survey" = "double",
        "Depth" = "double",
        "SampleID" = "character",
        "Method" = "character",
        "Tide" = "character",
        "Sal_surf" = "double",
        "Sal_bot" = "double",
        "Temp_surf" = "double",
        "TurbidityNTU" = "double",
        "TurbidityFNU" = "double",
        "Secchi" = "double",
        "Secchi_estimated" = "integer",
        "Tow_duration" = "double",
        "Tow_area" = "double",
        "Tow_volume" = "double",
        "Cable_length" = "double",
        "Tow_direction" = "character",
        "Notes_tow" = "character",
        "Notes_flowmeter" = "character"
    )
}



test_that("Date and Datetime columns are formatted correctly", {
    expect_equal(class(datetimes$Date), "Date")
    expect_setequal(class(datetimes$Datetime), c("POSIXct", "POSIXt"))
})

test_that("Timezone is correct", {
    expect_equal(attr(datetimes$Datetime, "tzone"), "America/Los_Angeles")
})

test_that("up-to-date dataset with update=TRUE produces expected message",
          {
              expect_message(create_fish_db(update = TRUE), "Dataset already up to date")
          })

test_that("bad data directory produces expected error", {
    expect_error(
        create_fish_db_f(
            data_dir = "test-dir",
            cache_dir = "test",
            update = F,
            edi_pid = "edi.1075.1"
        ),
        regexp = NULL
    )
})

test_that("column types are correct", {
    expect_equal(surv_coltypes, surv_coltypes_expected)
    expect_equal(fish_coltypes, fish_coltypes_expected)
})

close_database(con)

cat("finished testing the outcome of create_fish_db\n")
