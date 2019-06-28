context("Dates")

library(arsenal)

test_that("end of month is correct (i.e. 30 versus 31 and 28 for February)", {
  expect_equal(end_of_month(as.Date("2019-02-05")), as.Date("2019-02-28"))
})
