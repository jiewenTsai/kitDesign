# 元件樣張的畫面檢查：開 gallery、在 1280 與 390 寬截圖，整頁不能左右捲
#
# 用法（在套件根目錄）：
#   LC_ALL=en_US.UTF-8 Rscript tools/check_gallery.R [截圖資料夾] [port]
# 截圖資料夾預設是暫存資料夾。任何一頁 document.documentElement.scrollWidth 不等於視窗寬時，
# 結束代碼是 1（CI 或發布前用）。
# 需要：chromote（和它用的 Chrome）、processx。先把這個資料夾的原始碼裝到暫存的 library，
# 所以檢查的是現在的程式碼，不是之前裝好的版本。

main <- function() {
args <- commandArgs(trailingOnly = TRUE)
out <- if (length(args) >= 1) args[[1]] else file.path(tempdir(), "kitdesign_gallery")
port <- if (length(args) >= 2) as.integer(args[[2]]) else 7551L
stopifnot(file.exists("DESCRIPTION"), requireNamespace("chromote", quietly = TRUE),
          requireNamespace("processx", quietly = TRUE))
dir.create(out, recursive = TRUE, showWarnings = FALSE)

# 1. 裝到暫存的 library
lib <- file.path(tempdir(), "kitdesign-lib")
dir.create(lib, showWarnings = FALSE)
r_bin <- file.path(R.home("bin"), "R")
status <- system2(r_bin, c("CMD", "INSTALL", "--no-test-load", "-l", shQuote(lib), "."),
                  stdout = FALSE, stderr = FALSE)
if (status != 0) stop("R CMD INSTALL failed")

# 2. 在背景開 gallery
env <- c("current", R_LIBS = paste(c(lib, .libPaths()), collapse = .Platform$path.sep),
         LC_ALL = "en_US.UTF-8")
log <- file.path(tempdir(), "kitdesign-gallery.log")
app <- processx::process$new(
  file.path(R.home("bin"), "Rscript"),
  c("-e", sprintf(paste0("shiny::runApp(system.file('examples/gallery', package = 'kitDesign'), ",
                         "port = %d, launch.browser = FALSE)"), port)),
  env = env, stdout = log, stderr = "2>&1"
)
on.exit(app$kill(), add = TRUE)
url <- sprintf("http://127.0.0.1:%d", port)
for (i in 1:60) {
  ok <- tryCatch({
    con <- url(url)
    suppressWarnings(readLines(con, n = 1))
    close(con)
    TRUE
  }, error = function(e) FALSE)
  if (ok) break
  if (!app$is_alive()) stop("The gallery app stopped:\n", paste(readLines(log), collapse = "\n"))
  Sys.sleep(0.5)
}

# 3. 截圖與量寬度
js <- function(b, code) b$Runtime$evaluate(code, awaitPromise = TRUE, returnByValue = TRUE)$result$value
tabs <- c("page", "status", "steps", "checklist", "flow", "code", "chart")
sizes <- list(list(w = 1280, h = 900, mobile = FALSE), list(w = 390, h = 844, mobile = TRUE))
rows <- list()
for (sz in sizes) {
  b <- chromote::ChromoteSession$new(width = sz$w, height = sz$h, mobile = sz$mobile)
  b$Page$navigate(url)
  b$Page$loadEventFired(timeout_ = 30)
  Sys.sleep(4)
  for (i in seq_along(tabs)) {
    tab <- tabs[[i]]
    js(b, sprintf("document.querySelector('.kit-navgroups a[data-kit-tab=\"%s\"]').click()", tab))
    Sys.sleep(1.5)
    if (tab == "page") {
      js(b, "var s=document.getElementById('id_col').selectize; s.setValue('subj_id'); true")
      Sys.sleep(1.5)
      js(b, "document.getElementById('gate-run').click(); true")
      Sys.sleep(2.5)
    }
    if (tab == "steps") {
      js(b, "document.getElementById('cards-ok1').click(); true")
      Sys.sleep(1.5)
    }
    # 打開所有的收合區塊（包括「用 R 怎麼做」）
    js(b, "document.querySelectorAll('details').forEach(function(d){d.open=true}); true")
    Sys.sleep(2)
    sw <- js(b, "document.documentElement.scrollWidth")
    vw <- js(b, "window.innerWidth")
    rows[[length(rows) + 1]] <- data.frame(width = sz$w, tab = tab, scrollWidth = sw,
                                           viewport = vw, ok = sw == sz$w && vw == sz$w)
    js(b, "window.scrollTo(0, 0); true")
    b$screenshot(file.path(out, sprintf("%d_%d_%s.png", sz$w, i, tab)), selector = "html",
                 scale = 1, show = FALSE)
  }
  b$close()
}
res <- do.call(rbind, rows)
print(res, row.names = FALSE)
cat("screenshots:", normalizePath(out), "\n")
if (!all(res$ok)) {
  cat("FAILED: the page scrolls sideways (scrollWidth != viewport width)\n")
  return(1L)
}
cat("OK: no page scrolls sideways at 1280 or 390.\n")
0L
}

quit(status = main())
