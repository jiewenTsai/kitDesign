test_that("kit_num() adds thousands separators to whole numbers", {
  expect_equal(kit_num(3418), "3,418")
  expect_equal(kit_num(c(5, 12345, 1e6)), c("5", "12,345", "1,000,000"))
  expect_equal(kit_num("2058"), "2,058")
  expect_equal(kit_num(999), "999")
})

test_that("kit_dims() and kit_rows_note() describe table size", {
  expect_equal(kit_dims(3418, 25), "3,418 列 × 25 欄")
  expect_equal(kit_dims(3418, 25, preview_cols = 20), "3,418 列 × 25 欄（以下只預覽前 20 欄）")
  expect_equal(kit_dims(5, 7, preview_cols = 20), "5 列 × 7 欄")
  expect_equal(kit_rows_note(157, shown_rows = 20), "共 157 列，以下前 20 列。")
  expect_equal(kit_rows_note(8, shown_rows = 10), "共 8 列，以下是全部。")
  expect_equal(kit_rows_note(3418, 25, shown_rows = 10, shown_cols = 20),
               "共 3,418 列 × 25 欄，以下前 10 列、前 20 欄。")
  expect_equal(kit_rows_note(5, 25, shown_rows = 10, shown_cols = 20),
               "共 5 列 × 25 欄，以下全部的列、前 20 欄。")
})

test_that("kit_static_table() is a striped table with formatted integers", {
  df <- data.frame(世代 = c("M03", "M36"), 人數 = c(3389, NA), 比例 = c(0.123456, 1.5),
                   check.names = FALSE)
  out <- html(kit_static_table(df))
  expect_match(out, "^<table class=\"table table-sm table-striped\">")
  expect_match(out, "<th>世代</th>\\s*<th>人數</th>\\s*<th>比例</th>")
  expect_match(out, "<td>3,389</td>", fixed = TRUE)
  expect_match(out, "<td>0.1235</td>", fixed = TRUE)
  expect_match(out, "<td></td>", fixed = TRUE)
  one_col <- html(kit_static_table(data.frame(n = c(1200, 3))))
  expect_match(one_col, "<td>1,200</td>", fixed = TRUE)
})

test_that("kit_preview_table() keeps priority columns and formats labels and dates", {
  df <- as.data.frame(matrix(1:60, nrow = 2))
  pv <- kit_preview_table(df, priority_cols = "V30", n = 1)
  expect_equal(dim(pv), c(1L, 20L))
  expect_equal(names(pv)[1], "V30")
  expect_true(all(vapply(pv, is.character, logical(1))))
  sex <- structure(c(1, 2, 9), labels = c(男 = 1, 女 = 2), class = c("haven_labelled", "vctrs_vctr", "double"))
  df2 <- data.frame(id = 1:3, day = as.Date("2026-10-31") + 0:2)
  df2$sex <- sex
  pv2 <- kit_preview_table(df2)
  expect_equal(pv2$sex, c("[1] 男", "[2] 女", "9"))
  expect_equal(pv2$day[1], "2026-10-31")
  expect_equal(nrow(kit_preview_table(data.frame(a = 1:30))), 10)
})

test_that("kit_table_scroll() wraps wide tables", {
  expect_match(html(kit_table_scroll("x")), "^<div class=\"kit-table-scroll\">")
  expect_match(html(kit_table_scroll("x", tall = TRUE)), "class=\"kit-table-scroll kit-table-tall\"", fixed = TRUE)
})

test_that("chart colours are Okabe-Ito in order, with a neutral grey", {
  cols <- kit_chart_colors()
  expect_equal(names(cols), c("blue", "orange", "green", "purple", "sky", "vermillion"))
  expect_equal(unname(cols[1:2]), c("#0072B2", "#E69F00"))
  expect_equal(kit_chart_colors(2), c("#0072B2", "#E69F00"))
  expect_equal(kit_chart_colors(7)[7], "#0072B2")
  expect_null(names(kit_chart_colors(3)))
  expect_equal(kit_chart_neutral(), "#7F7F7F")
})
