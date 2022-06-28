cat("starting to create database")
create_fish_db()
cat("finished creating database")

cat("testing the outcome of create_fish_db")
datetimes<-open_survey()%>%
    distinct(Date, Datetime)%>%
    collect()

test_that("Date and Datetime columns are formatted correctly", {
    expect_equal(class(datetimes$Date), "Date")
    expect_setequal(class(datetimes$Datetime), c("POSIXct", "POSIXt"))
})

test_that("Timezone is correct", {
    expect_equal(attr(datetimes$Datetime, "tzone"), "America/Los_Angeles")    
})

test_that("up-to-date dataset with update=TRUE produces expected message", {
    expect_message(create_fish_db(update=TRUE), "Dataset already up to date")
})

test_that("bad data directory produces expected warnings", {
    expect_error(create_fish_db_f(data_dir = tempdir(), cache_dir="test", update=F, edi_pid="edi.1075.1"), 
                 "Data directory must contain both length_conv.csv and fishsurvey_compressed.rda.")
})

cat("finished testing the outcome of create_fish_db")