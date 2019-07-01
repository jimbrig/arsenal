context("Files")

library(arsenal)

test_that("list_files works", {

  notnamed <- list_files(getwd())
  named <- list_files(getwd(), named = TRUE)

  expect_true(!is.null(notnamed))
  expect_true(!is.null(named))

  expect_gt(length(notnamed), 0)
  expect_gt(length(named), 0)

  expect_named(named)


})

