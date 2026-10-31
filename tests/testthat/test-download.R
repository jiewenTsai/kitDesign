# 下載按鈕（kit_download_button()）：檔名標頭（RFC 6266）、網址結尾是檔名、MIME、錯誤
# （kitJoin 與 kitsUI 的 R/download.R 的測試搬過來；app 名稱改成參數）

link_attr <- function(html, id, attr) {
  tag <- regmatches(html, regexpr(paste0('<a [^>]*id="', id, '"[^>]*>'), html))
  value <- sub(paste0(".*\\s", attr, '="([^"]*)".*'), "\\1", tag)
  gsub("&amp;", "&", value, fixed = TRUE)
}
file_bytes <- function(path) readBin(path, "raw", file.size(path))

test_that("Content-Disposition：ASCII 檔名只有 filename；\" 與 \\ 前面加 \\", {
  expect_equal(
    kit_content_disposition("joined_20261030_153000.sav"),
    'attachment; filename="joined_20261030_153000.sav"'
  )
  expect_equal(kit_content_disposition("kitsui_fixed_R1.zip", "kitsUI"),
               'attachment; filename="kitsui_fixed_R1.zip"')
  expect_equal(kit_content_disposition('a"b\\c.csv'), 'attachment; filename="a\\"b\\\\c.csv"')
})

test_that("Content-Disposition：中文與空白 → ASCII 備用名（app 名稱的小寫）+ filename*（UTF-8）", {
  expect_equal(
    kit_content_disposition("第一波 資料.sav", "kitJoin"),
    paste0(
      'attachment; filename="kitjoin.sav"; ',
      "filename*=UTF-8''%E7%AC%AC%E4%B8%80%E6%B3%A2%20%E8%B3%87%E6%96%99.sav"
    )
  )
  expect_equal(
    kit_content_disposition("第一波_na.csv.gz", "kitJoin"),
    paste0(
      'attachment; filename="kitjoin_na.csv.gz"; ',
      "filename*=UTF-8''%E7%AC%AC%E4%B8%80%E6%B3%A2_na.csv.gz"
    )
  )
  expect_equal(
    kit_content_disposition("kitsui_fixed_第一回.zip", "kitsUI"),
    paste0(
      'attachment; filename="kitsui_fixed_.zip"; ',
      "filename*=UTF-8''kitsui_fixed_%E7%AC%AC%E4%B8%80%E5%9B%9E.zip"
    )
  )
  expect_match(kit_content_disposition("第一波_na.csv", "kitsUI"), 'filename="kitsui_na.csv"', fixed = TRUE)
  expect_match(kit_content_disposition("第一波.csv"), 'filename="kit.csv"', fixed = TRUE)
  expect_match(kit_content_disposition("w1 第一波.csv"), 'filename="w1.csv"', fixed = TRUE)
  # RFC 5987 attr-char 不編碼；其他（括號、引號）要編碼
  expect_match(kit_content_disposition("資料 (1)'.sav"), "%20%281%29%27.sav", fixed = TRUE)
})

test_that("副檔名與 Content-Type：.csv.gz 算一個；csv、zip、html 有自己的 MIME，其他是 octet-stream", {
  expect_equal(kit_download_ext("第一波.csv.gz"), "csv.gz")
  expect_equal(kit_download_ext("a.SAV"), "SAV")
  expect_equal(kit_download_ext("a.ZIP"), "ZIP")
  expect_equal(kit_download_ext("readme"), "")
  expect_equal(kit_ascii_filename("第一波.CSV.GZ", "kitJoin"), "kitjoin.CSV.GZ")
  expect_equal(kit_ascii_filename("第一波.CSV.GZ", "kitsUI"), "kitsui.CSV.GZ")
  expect_equal(kit_download_type("a.csv"), "text/csv; charset=UTF-8")
  expect_equal(kit_download_type("a.ZIP"), "application/zip")
  expect_equal(kit_download_type("item_lan_M03_fit.html"), "text/html; charset=UTF-8")
  expect_equal(kit_download_type("a.csv.gz"), "application/octet-stream")
  expect_equal(kit_download_type("a.sav"), "application/octet-stream")
  expect_equal(kit_download_type("readme"), "application/octet-stream")
})

test_that("網址最後一段是檔名（registerDataObj 的網址插入檔名），按鈕帶 download 與 class", {
  # 像模組的 session：registerDataObj() 自己加 namespace
  registered <- list()
  session <- list(
    ns = function(id) paste0("m-", id),
    registerDataObj = function(name, data, filterFunc) {
      registered[[paste0("m-", name)]] <<- list(data = data, filter = filterFunc)
      paste0("session/abc/dataobj/m-", name, "?w=&nonce=n1")
    }
  )
  out <- as.character(kit_download_button(
    session, "dl", "下載", "第一波_na.sav", function(file) writeLines("x", file),
    class = "btn-sm btn-primary"
  ))
  expect_equal(
    link_attr(out, "m-dl", "href"),
    "session/abc/dataobj/m-dl/%E7%AC%AC%E4%B8%80%E6%B3%A2_na.sav?w=&nonce=n1"
  )
  expect_equal(link_attr(out, "m-dl", "download"), "第一波_na.sav")
  expect_match(out, "fa-download")
  expect_match(out, 'class="btn btn-default kit-download btn-sm btn-primary"', fixed = TRUE)
  expect_named(registered, "m-dl")
  expect_equal(registered[["m-dl"]]$data$filename, "第一波_na.sav")
  out <- as.character(kit_download_button(
    session, "fixed_dl", "下載", "kitsui_fixed_R1.zip", function(file) writeLines("x", file)
  ))
  expect_equal(link_attr(out, "m-fixed_dl", "href"),
               "session/abc/dataobj/m-fixed_dl/kitsui_fixed_R1.zip?w=&nonce=n1")
})

test_that("回應：200、標頭、檔案位元組和寫檔函式一樣；kit_test_download() 附上檔名", {
  df <- data.frame(id = c("0012", "0013"), x = c(1, NA), name = c("王", "李"))
  session <- shiny::MockShinySession$new()
  writers <- list(
    "第一波 資料.csv" = function(file) utils::write.csv(df, file, row.names = FALSE, fileEncoding = "UTF-8"),
    "第一波 資料.csv.gz" = function(file) {
      con <- gzfile(file, "w")
      utils::write.csv(df, con, row.names = FALSE)
      close(con)
    },
    "kitsui_fixed_R1.zip" = function(file) writeBin(as.raw(1:200), file),
    "joined.sav" = function(file) writeBin(as.raw(200:1), file)
  )
  for (name in names(writers)) {
    kit_download_button(session, "dl", "下載", name, writers[[name]], app = "kitJoin")
    res <- kit_test_download(session, "dl")
    expect_equal(res$status, 200)
    expect_equal(res$filename, name)
    expect_equal(res$content_type, kit_download_type(name))
    expect_equal(res$headers[["Content-Disposition"]], kit_content_disposition(name, "kitJoin"))
    expect_equal(res$headers[["Cache-Control"]], "no-cache")
    expect_true(res$content$owned)
    expect_true(endsWith(res$content$file, paste0(".", kit_download_ext(name))))
    old <- tempfile(fileext = paste0(".", kit_download_ext(name)))
    writers[[name]](old)
    if (!endsWith(name, ".gz")) expect_equal(file_bytes(res$content$file), file_bytes(old))
    unlink(old)
  }
  expect_equal(res$content_type, "application/octet-stream")
  expect_equal(kit_test_download(session, "dl", write = FALSE), list(filename = "joined.sav"))
  expect_error(kit_test_download(session, "nope"), "No download button registered")
})

test_that("app 名稱：預設是 getOption(\"kitDesign.app\", \"kit\")；log 與備用檔名用它", {
  session <- shiny::MockShinySession$new()
  old <- options(kitDesign.app = "kitsUI")
  on.exit(options(old))
  kit_download_button(session, "dl", "下載", "第一波.csv", function(file) writeLines("x", file))
  expect_match(kit_test_download(session, "dl")$headers[["Content-Disposition"]],
               'filename="kitsui.csv"', fixed = TRUE)
  kit_download_button(session, "dl", "下載", "x.csv", function(file) stop("壞掉"))
  expect_message(kit_test_download(session, "dl"), "kitsUI 下載失敗（x.csv）：壞掉")
  options(kitDesign.app = NULL)
  kit_download_button(session, "dl", "下載", "x.csv", function(file) stop("壞掉"))
  expect_message(kit_test_download(session, "dl"), "^kit 下載失敗")
})

test_that("回應：寫檔函式可以讀 reactive；出錯時回 500 並寫 log", {
  session <- shiny::MockShinySession$new()
  value <- shiny::reactiveVal("a")
  kit_download_button(session, "dl", "下載", "x.csv", function(file) writeLines(value(), file))
  value("b")
  expect_equal(readLines(kit_test_download(session, "dl")$content$file), "b")

  kit_download_button(session, "dl", "下載", "x.csv", function(file) stop("壞掉"), app = "kitJoin")
  expect_message(res <- kit_test_download(session, "dl"), "kitJoin 下載失敗.*壞掉")
  expect_equal(res$status, 500)
  expect_match(res$content, "下載失敗")
  # 寫檔函式沒有寫出檔案
  kit_download_button(session, "dl", "下載", "x.csv", function(file) NULL)
  expect_message(res <- kit_test_download(session, "dl"), "沒有寫出檔案")
  expect_equal(res$status, 500)
})

test_that("下載失敗：在這個 session 跳出紅色通知（不會自己消失）；kit_abort() 的訊息照原文", {
  shown <- list()
  testthat::local_mocked_bindings(
    showNotification = function(ui, action = NULL, duration = 5, closeButton = TRUE, id = NULL,
                                type = "default", session = shiny::getDefaultReactiveDomain()) {
      shown[[length(shown) + 1]] <<- list(ui = ui, duration = duration, type = type,
                                          session = session)
      invisible(id)
    },
    .package = "shiny"
  )
  session <- shiny::MockShinySession$new()
  kit_download_button(session, "dl", "下載", "x.csv", function(file) stop("內部的錯誤"))
  expect_message(res <- kit_test_download(session, "dl"), "內部的錯誤")
  expect_equal(res$status, 500)
  expect_length(shown, 1)
  expect_equal(shown[[1]]$ui, "下載失敗，請重新執行後再試一次。")
  expect_equal(shown[[1]]$type, "error")
  expect_null(shown[[1]]$duration)
  expect_identical(shown[[1]]$session, session)
  expect_equal(res$content, "下載失敗，請重新執行後再試一次。")

  kit_download_button(session, "dl", "下載", "x.csv", function(file) kit_abort("先算分數。"))
  expect_message(res <- kit_test_download(session, "dl"), "先算分數")
  expect_equal(shown[[2]]$ui, "下載失敗：先算分數。")
  expect_equal(res$content, "下載失敗：先算分數。")

  # 通知送不出去（例如連線已經關了）時照樣回 500
  testthat::local_mocked_bindings(showNotification = function(...) stop("closed"),
                                  .package = "shiny")
  expect_message(res <- kit_test_download(session, "dl"), "先算分數")
  expect_equal(res$status, 500)
})
