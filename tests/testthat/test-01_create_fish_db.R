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

cat("finished testing the outcome of create_fish_db")