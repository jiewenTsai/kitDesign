test_that("kit_new_app() scaffolds a package that loads and passes its own test", {
  skip_if_not_installed("pkgload")
  dir <- file.path(withr_tempdir <- tempfile("newapp"), "kitDemo")
  on.exit(unlink(withr_tempdir, recursive = TRUE), add = TRUE)
  out <- kit_new_app(dir, "KIT 示範工具", "臺灣幼兒發展調查資料庫")
  expect_true(dir.exists(out))
  files <- list.files(dir, recursive = TRUE, all.files = TRUE)
  expect_setequal(files, c(".gitignore", ".Rbuildignore", "app.R", "DESCRIPTION", "LICENSE",
                           "NAMESPACE", "R/app.R", "R/page_calc.R", "README.md",
                           "tests/testthat.R", "tests/testthat/test-app.R"))
  desc <- read.dcf(file.path(dir, "DESCRIPTION"))
  ver <- as.character(utils::packageVersion("kitDesign"))
  expect_equal(unname(desc[1, "Package"]), "kitDemo")
  expect_match(desc[1, "Imports"], paste0("kitDesign (>= ", ver, ")"), fixed = TRUE)
  expect_match(desc[1, "Remotes"], paste0("jiewenTsai/kitDesign@v", ver), fixed = TRUE)
  readme <- readLines(file.path(dir, "README.md"), encoding = "UTF-8")
  # 安裝的說明會一起升級太舊的套件（例如 bslib）
  expect_true(any(grepl("pak::pkg_install(\"<GitHub 帳號>/kitDemo\")", readme, fixed = TRUE)))
  expect_true(any(grepl("upgrade = \"always\"", readme, fixed = TRUE)))
  gi <- readLines(file.path(dir, ".gitignore"))
  expect_true("tests/testthat/_problems/" %in% gi)
  expect_true("testthat-problems.rds" %in% gi)
  app_r <- readLines(file.path(dir, "R", "app.R"), encoding = "UTF-8")
  expect_true(any(grepl("KIT 示範工具", app_r, fixed = TRUE)))
  expect_false(any(grepl("{{", app_r, fixed = TRUE)))

  # 載入（pkgload）並跑它自己的測試
  pkgload::load_all(dir, quiet = TRUE, export_all = TRUE, helpers = FALSE, attach_testthat = FALSE)
  on.exit(pkgload::unload("kitDemo"), add = TRUE)
  res <- as.data.frame(testthat::test_dir(file.path(dir, "tests", "testthat"), package = "kitDemo",
                                          load_package = "none", reporter = "silent",
                                          stop_on_failure = FALSE))
  expect_equal(nrow(res), 1)
  expect_equal(sum(res$failed), 0)
  expect_false(any(res$error))
  # 頁面組得起來
  ns <- asNamespace("kitDemo")
  page <- html(ns$app_ui(NULL))
  expect_match(page, "KIT 示範工具", fixed = TRUE)
  expect_match(page, "kitDesign ", fixed = TRUE)
})

test_that("kit_new_app() does not touch a non-empty folder and checks its arguments", {
  dir <- tempfile("busy")
  dir.create(dir)
  writeLines("keep me", file.path(dir, "notes.txt"))
  on.exit(unlink(dir, recursive = TRUE), add = TRUE)
  expect_error(kit_new_app(dir, "KIT 工具"), "already exists and is not empty")
  expect_equal(list.files(dir), "notes.txt")
  expect_error(kit_new_app(file.path(tempdir(), "1bad"), "x"), "`package` must start with a letter")
  expect_error(kit_new_app(file.path(tempdir(), "okName"), ""), "`title`")
  empty <- tempfile("empty")
  dir.create(empty)
  on.exit(unlink(empty, recursive = TRUE), add = TRUE)
  expect_silent(kit_new_app(empty, "KIT 工具", package = "kitEmpty"))
  expect_true(file.exists(file.path(empty, "DESCRIPTION")))
})
