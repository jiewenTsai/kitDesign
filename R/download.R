# 下載按鈕：自己送檔案，每個瀏覽器都拿得到正確檔名與副檔名
#
# shiny::downloadHandler() 遇到中文檔名會先轉址、只送 `attachment`，有些瀏覽器就存成
# `missing-download_sav`；有些瀏覽器（或下載外掛）不看檔名標頭，只看網址最後一段，
# 再照 MIME 補副檔名（`score-fixed_dl(1).zip`）。所以這裡用 session$registerDataObj()
# 自己回應，三道保險都放上同一個檔名：
#   1. 網址最後一段就是檔名：session/<token>/dataobj/<key>/<檔名>?w=&nonce=
#   2. Content-Disposition 同時有 filename（ASCII 備用名）與 filename*（UTF-8，RFC 6266）
#   3. <a download="檔名">
# kitJoin 與 kitsUI 原本各有一份（R/download.R），kitDesign 0.4.0 起放在這裡。

#' Download button
#'
#' Looks the same as [shiny::downloadButton()], but Chinese file names save correctly in every
#' browser: the last part of the URL, the `Content-Disposition` header (`filename` and
#' `filename*`), and `<a download>` all carry the same file name.
#' Put it inside `renderUI()`: it is registered again on each redraw, the URL changes with it, and
#' you never get a stale file.
#'
#' The file is written only when the user clicks download (`content(file)`, which can read
#' reactives). If writing fails: the error goes to the log ("<app> 下載失敗（檔名）：…", "<app>
#' download failed (file name): …"), this session shows a red notification (which does not
#' disappear on its own), and the response is 500 with the same sentence. Messages from
#' [kit_abort()] are shown to the user as written; other errors do not expose internal messages.
#'
#' `Content-Type` follows the extension: `.csv`, `.zip`, and `.html` get their own MIME types;
#' everything else (`.sav`, `.csv.gz`) is `application/octet-stream`, so browsers that add an
#' extension based on MIME type don't add an extra one.
#'
#' @param session The module's session (the namespace is added to the id automatically).
#' @param id The button id (without namespace).
#' @param label The button text, e.g. "下載 CSV" ("Download CSV").
#' @param filename The download file name (a string; may contain Chinese and spaces).
#' @param content `function(file)`: writes the file to `file`.
#' @param class An extra class, e.g. `kit_btn_class("secondary")`, `"btn-primary"`.
#' @param app The app name: used in log messages; when the file name is all Chinese, the ASCII
#'   fallback name for old browsers is its lowercase form ("第一波.csv" → "kitjoin.csv").
#'   Defaults to `getOption("kitDesign.app", "kit")`: the app sets it once in `.onLoad()`.
#' @return `<a class="btn btn-default kit-download" download="檔名">` (`download` holds the file
#'   name).
#' @seealso [kit_test_download()] (for tests)
#' @examples
#' if (interactive()) {
#'   server <- function(input, output, session) {
#'     output$dl_ui <- shiny::renderUI(kit_download_button(
#'       session, "dl", "下載 CSV", "第一波 資料.csv",   # "Download CSV", "Wave 1 data.csv"
#'       function(file) utils::write.csv(mtcars, file)
#'     ))
#'   }
#' }
#' @export
kit_download_button <- function(session, id, label, filename, content, class = NULL,
                                app = getOption("kitDesign.app", "kit")) {
  shiny::tags$a(
    id = session$ns(id),
    class = "btn btn-default kit-download",
    class = class,
    href = kit_register_download(session, id, filename, content, app),
    target = "_blank",
    download = filename,
    shiny::icon("download"),
    label
  )
}

#' Press a download button in tests
#'
#' The mock session of [shiny::testServer()] does not really register downloads
#' (`registerDataObj()` does nothing), so [kit_download_button()] stores the download in
#' `session$userData` instead; this function takes it from there and writes the file and responds
#' the same way as when a browser presses download.
#'
#' @param session The `session` of `testServer()`.
#' @param id The button id: inside a module, the id without namespace (`"dl"`); at the app level,
#'   the full id (`"stack-download_csv"`).
#' @param write When `FALSE`, no file is written and no response is made; only the file name
#'   registered is checked (for example, downloads that are slow to draw a chart).
#' @return [shiny::httpResponse()] (`status`, `content_type`, `headers`, `content$file`), with one
#'   more field `filename`: the file name registered. With `write = FALSE`, only
#'   `list(filename = )`.
#' @examples
#' session <- shiny::MockShinySession$new()
#' b <- kit_download_button(session, "dl", "下載", "a.csv", function(file) writeLines("x", file))
#' res <- kit_test_download(session, "dl")
#' res$content_type
#' readLines(res$content$file)
#' @export
kit_test_download <- function(session, id, write = TRUE) {
  store <- session$userData$kit_downloads
  dl <- store[[id]] %||% store[[session$ns(id)]]
  if (is.null(dl)) stop("No download button registered with id '", id, "'.", call. = FALSE)
  if (!write) return(list(filename = dl$data$filename))
  res <- dl$filter(dl$data, list())
  res$filename <- dl$data$filename
  res
}

# 副檔名（.csv.gz 算一個；只認 ASCII 英數字）
kit_download_ext <- function(filename) {
  m <- regmatches(filename, regexpr("(?i)\\.(csv\\.gz|[a-z0-9]+)$", filename, perl = TRUE))
  if (length(m) == 0) "" else substring(m, 2)
}

# Content-Type：.csv、.zip、.html 用自己的（補的副檔名和原本一樣）；其他都是 octet-stream（不會多加 .gz）
kit_download_type <- function(filename) {
  types <- c(csv = "text/csv; charset=UTF-8", zip = "application/zip",
             html = "text/html; charset=UTF-8")
  type <- types[tolower(kit_download_ext(filename))]
  if (is.na(type)) "application/octet-stream" else unname(type)
}

# 百分比編碼（UTF-8 位元組，%XX 大寫）；keep 裡的字元不編碼
kit_percent_encode <- function(x, keep) {
  bytes <- charToRaw(enc2utf8(x))
  ok <- bytes %in% charToRaw(keep)
  out <- sprintf("%%%02X", as.integer(bytes))
  out[ok] <- vapply(bytes[ok], rawToChar, "")
  paste(out, collapse = "")
}

# RFC 5987 attr-char（filename* 用）與網址路徑的安全字元（unreserved）
KIT_ATTR_CHAR <- paste0(
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", "!#$&+-.^_`|~"
)
KIT_URL_CHAR <- "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"

# 不認得 filename* 的舊瀏覽器用的 ASCII 檔名：去掉非 ASCII（副檔名保留），空了或開頭是 _-. 時補 app 名稱
kit_ascii_filename <- function(filename, app = "kit") {
  ext <- kit_download_ext(filename)
  base <- if (nzchar(ext)) substr(filename, 1, nchar(filename) - nchar(ext) - 1) else filename
  base <- gsub("[^ -~]+", "", base) |> gsub(pattern = " +", replacement = " ") |> trimws()
  fallback <- tolower(app)
  if (!nzchar(base)) base <- fallback
  if (grepl("^[-_.]", base)) base <- paste0(fallback, base)
  paste0(base, if (nzchar(ext)) ".", ext)
}

# Content-Disposition（RFC 6266）：ASCII 檔名只有 filename；有非 ASCII 時再加 filename*=UTF-8''…
kit_content_disposition <- function(filename, app = "kit") {
  quote <- function(x) paste0('"', gsub('(["\\\\])', "\\\\\\1", x), '"')
  if (!grepl("[^ -~]", filename)) return(paste0("attachment; filename=", quote(filename)))
  paste0(
    "attachment; filename=", quote(kit_ascii_filename(filename, app)),
    "; filename*=UTF-8''", kit_percent_encode(filename, KIT_ATTR_CHAR)
  )
}

# 收到下載請求時寫檔、回應；content() 在 session 的 reactive domain 裡跑，可以讀 reactive。
# 出錯時：log、紅色通知（<a download> 失敗時瀏覽器頂多寫「失敗」）、500 與同一句話
kit_download_filter <- function(session) {
  function(data, req) {
    tryCatch(
      shiny::withReactiveDomain(session, shiny::isolate(kit_download_response(data))),
      error = function(e) {
        # 原文： 下載失敗（ | ）：
        message(data$app, " \u4e0b\u8f09\u5931\u6557\uff08", data$filename, "\uff09\uff1a", conditionMessage(e))
        text <- kit_download_error_text(e)
        kit_download_notify(session, text)
        shiny::httpResponse(500, "text/plain; charset=UTF-8", text)
      }
    )
  }
}

# 給使用者看的一句話：kit_abort() 的訊息照原文；其他錯誤不給內部訊息
kit_download_error_text <- function(e) {
  # 原文：下載失敗：
  if (inherits(e, "kit_user_error")) return(paste0("\u4e0b\u8f09\u5931\u6557\uff1a", conditionMessage(e)))
  # 原文：下載失敗，請重新執行後再試一次。
  "\u4e0b\u8f09\u5931\u6557\uff0c\u8acb\u91cd\u65b0\u57f7\u884c\u5f8c\u518d\u8a66\u4e00\u6b21\u3002"
}

# 下載請求是 HTTP、不在 reactive 流程裡：showNotification() 直接經 websocket 送出；送不出去也不影響回應
kit_download_notify <- function(session, text) {
  tryCatch(
    shiny::withReactiveDomain(
      session, shiny::showNotification(text, type = "error", duration = NULL)
    ),
    error = function(e) NULL
  )
  invisible()
}

# 寫暫存檔（副檔名照下載檔名），回傳檔案本身；httpuv 送完會刪掉（owned = TRUE）
kit_download_response <- function(data) {
  ext <- kit_download_ext(data$filename)
  tmp <- tempfile(fileext = if (nzchar(ext)) paste0(".", ext) else "")
  done <- FALSE
  on.exit(if (!done) unlink(tmp))
  data$content(tmp)
  # 原文：沒有寫出檔案
  if (!file.exists(tmp)) stop("\u6c92\u6709\u5beb\u51fa\u6a94\u6848")
  done <- TRUE
  shiny::httpResponse(
    200, kit_download_type(data$filename), list(file = tmp, owned = TRUE),
    headers = list(
      "Content-Disposition" = kit_content_disposition(data$filename, data$app),
      "Cache-Control" = "no-cache"
    )
  )
}

# 註冊下載、回傳網址（相對於 app，Posit Connect 的 /_w_.../ 底下也能用）。網址最後一段是編碼過的檔名
# （shiny 只看 key）；nonce 每次不同，結果更新後網址也會變。testServer() 的假 session 不註冊
# （回傳 NULL）：改存在 userData$kit_downloads[[key]]（kit_test_download() 從那裡拿）
kit_register_download <- function(session, id, filename, content, app = "kit") {
  data <- list(filename = filename, content = content, app = app)
  filter <- kit_download_filter(session)
  url <- session$registerDataObj(id, data, filter)
  if (is.null(url)) {
    key <- session$ns(id)
    store <- session$userData
    store$kit_downloads[[key]] <- list(data = data, filter = filter)
    url <- paste0("session/test/dataobj/", utils::URLencode(key, TRUE), "?w=&nonce=test")
  }
  sub("?", paste0("/", kit_percent_encode(filename, KIT_URL_CHAR), "?"), url, fixed = TRUE)
}
