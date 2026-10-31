# 檔案的小工具（原本 kitJoin、kitsUI 各一份）

test_that("kit_sav_safe_names(): legal SPSS names, reserved words, 64 bytes, case-insensitive duplicates", {
  out <- kit_sav_safe_names(c("1st wave", "AND", "id", "ID", "x.", "測驗"))
  expect_equal(out[1:5], c("v_1st_wave", "AND_", "id", "ID_2", "x"))
  expect_equal(out[6], "\u6e2c\u9a57")
  long <- kit_sav_safe_names(strrep("測", 40))
  expect_lte(nchar(long, "bytes"), 64)
  expect_true(validUTF8(long))
})

test_that("kit_truncate_bytes() never cuts a CJK character in half", {
  x <- kit_truncate_bytes(strrep("測", 30), 64)
  expect_equal(nchar(x, "bytes"), 63)
  expect_true(validUTF8(x))
})

test_that("kit_fix_utf8_df() keeps labels; kit_is_valid_utf8_df() checks names and text", {
  df <- data.frame(a = c("x", NA), b = 1:2)
  attr(df$a, "label") <- "題目"
  fixed <- kit_fix_utf8_df(df)
  expect_equal(attr(fixed$a, "label"), "題目")
  expect_true(kit_is_valid_utf8_df(fixed))
  bad <- data.frame(a = "\xff", stringsAsFactors = FALSE)
  expect_false(kit_is_valid_utf8_df(bad))
  expect_identical(kit_fix_utf8_chr(1:2), 1:2)
})

test_that("kit_gz_path() copies a non-.gz path to a .csv.gz temp file", {
  f <- tempfile(fileext = ".bin")
  writeLines("a", f)
  g <- kit_gz_path(f)
  expect_match(g, "\\.csv\\.gz$")
  expect_true(file.exists(g))
  expect_identical(kit_gz_path("x.csv.gz"), "x.csv.gz")
})
