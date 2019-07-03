context("leftright")

test_that("works as expected", {
  expect_equal(left("leftright", 4) , "left")
  expect_equal(left("four", 5), "four")

  expect_equal(right("leftright", 5), "right")
  expect_equal(right("four", 5), "four")
})
