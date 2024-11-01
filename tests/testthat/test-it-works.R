test_that("C++ code works", {
  expect_equal(two(), 2L)
})

test_that("compiler version", {
  out <- compiler()
  message(out)
  expect_equal(substr(out, 1, 16), "using C compiler")
})
