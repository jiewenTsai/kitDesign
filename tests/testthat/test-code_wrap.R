# kit_code_wrap()：「用 R 怎麼做」每行最多 70 欄（從 kitJoin 的 tests/testthat/test-code_wrap.R 搬過來）

test_that("中文字算 2 欄", {
  expect_identical(kit_code_cols(c("abc", "讀 CSV", "")), c(3L, 6L, 0L))
})

test_that("短的程式碼原樣傳回", {
  code <- "library(readr)    # 讀 CSV\nx <- 1"
  expect_identical(kit_code_wrap(code), code)
})

test_that("長的註解在空白或中文字之間換行，每行都是註解", {
  out <- strsplit(kit_code_wrap(paste0(
    "  # read.csv() 的設定和 read_csv() 一致：check.names = FALSE ",
    "欄名保持原樣（空白不改成點）；"
  )), "\n")[[1]]
  expect_gt(length(out), 1)
  expect_true(all(kit_code_cols(out) <= 70))
  expect_true(all(startsWith(out, "  # ")))
  expect_false(any(grepl("^  # [，。、：；）]", out)))
})

test_that("長的程式在括號裡的逗號後面換行，續行對齊括號，運算式不變", {
  code <- paste0(
    'picks <- tibble(cohort = c("M03", "M03", "M03", "M03", "M03", "M03", ',
    '"M03", "M36", "M36", "M36", "M36", "M36"),\n',
    "                wave_m = c(3, 6, 12, 18, 24, 36, 48, 60, 72, 36, 48, 60, 72, 84, 96))"
  )
  out <- kit_code_wrap(code)
  lines <- strsplit(out, "\n")[[1]]
  expect_true(all(kit_code_cols(lines) <= 70))
  expect_true(kitDesign:::kit_code_same(code, out))
  expect_match(lines[2], '^                           "M03"')
})

test_that("行尾註解太寬時搬到上一行", {
  out <- kit_code_wrap(
    "scores <- kits_subj(X, item, persons = persons) # theta：各世代分開估計，沒有經過連結"
  )
  expect_identical(strsplit(out, "\n")[[1]], c(
    "# theta：各世代分開估計，沒有經過連結",
    "scores <- kits_subj(X, item, persons = persons)"
  ))
})

test_that("字串裡的逗號、# 不會被當成換行點或註解", {
  code <- paste0('x <- c("a, b # c", "d, e", "f, g", "h, i", "j, k", "l, m", ',
                 '"n, o", "p, q", "r, s")')
  out <- kit_code_wrap(code)
  expect_true(kitDesign:::kit_code_same(code, out))
  expect_true(all(kit_code_cols(strsplit(out, "\n")[[1]]) <= 70))
})

test_that("斷不開的長字串維持原樣；parse 不了的程式碼不動", {
  long <- paste0('df <- readr::read_csv("', strrep("a", 80), '.csv")')
  expect_identical(kit_code_wrap(long), long)
  broken <- paste0("x <- c(1, 2, ", strrep("3, ", 30))
  expect_identical(kit_code_wrap(broken), broken)
})

test_that("括號在前一行打開時，這一行的逗號也能換行，續行同樣縮排", {
  code <- paste(
    "long_1 <- data_1 |>",
    "  mutate(",
    "    cohort = NA_character_, subj_id = as_id(w1_id), wave_m = as.numeric(w1_mon),",
    "    visit_id = paste(cohort, subj_id, sep = \"_\")",
    "  )",
    sep = "\n"
  )
  out <- kit_code_wrap(code)
  lines <- strsplit(out, "\n")[[1]]
  expect_true(all(kit_code_cols(lines) <= 70))
  expect_true(any(lines == "    cohort = NA_character_, subj_id = as_id(w1_id),"))
  expect_true(any(lines == "    wave_m = as.numeric(w1_mon),"))
  expect_identical(
    lapply(parse(text = out, keep.source = FALSE), deparse),
    lapply(parse(text = code, keep.source = FALSE), deparse)
  )
})

test_that("註解換行時標點不放在行首，也不超過寬度", {
  note <- paste0(
    "# 題目表：「kits 作答檔」第 3 步下載的 kits_item_settings.csv（item_id、",
    "include、domain）"
  )
  lines <- strsplit(kit_code_wrap(note), "\n")[[1]]
  expect_true(all(kit_code_cols(lines) <= 70))
  expect_false(any(grepl("^# [，。、：；）]", lines)))
})
