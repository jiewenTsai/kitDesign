# 品牌（Brand）：標誌與顏色
#
# kitDesign 預設是 KIT 的樣子（萊姆頁首、KIT 綠連結、豆子標誌）。別的計畫要用時，
# 用 kit_brand() 換標誌與顏色，其他（字型、框、陰影、元件）照設計語言不變。
# 顏色是設計語言的 tokens：CSS 的 --nb-* 變數、bslib 主題、圖的連續色階都從品牌來。

# 品牌的顏色名稱 → CSS 變數（inst/www/kit-brite.css 的 :root）
KIT_BRAND_VARS <- c(
  ink = "--nb-ink",
  page = "--nb-page",
  card = "--nb-card",
  accent = "--nb-lime",
  accent_light = "--nb-bg-new",
  primary = "--nb-green",
  primary_hover = "--nb-green-hover",
  success = "--nb-mint",
  warning = "--nb-yellow",
  danger = "--nb-salmon",
  info = "--nb-sky"
)

# KIT 的顏色（brand/KIT設計語言.md 的附錄）
KIT_BRAND_COLORS <- c(
  ink = "#141414",
  page = "#faf7f0",
  card = "#ffffff",
  accent = "#c6d033",
  accent_light = "#e8f0a0",
  primary = "#006835",
  primary_hover = "#004d27",
  success = "#b9f0a8",
  warning = "#ffde59",
  danger = "#ff9b8f",
  info = "#a8dcff"
)

#' 品牌：標誌與顏色
#'
#' kitDesign 預設是 KIT 的樣子。別的計畫或研究室要用 kitDesign 時，用 `kit_brand()`
#' 換掉標誌與顏色；字型、框、陰影、元件的樣子照設計語言不變。
#' 不給任何參數時就是 KIT（`kit_brand()`），畫出來的頁面和以前一模一樣。
#'
#' 品牌交給 [kit_page()]（`brand =`），或在 app 開始時設定一次：
#' `options(kitDesign.brand = kit_brand(...))`，之後 [kit_page()]、[kit_header()]、
#' [kit_theme()]、[kit_colors()]、[kit_chart_sequential()]、[kit_plotly_style()]
#' 都用它（[kit_current_brand()]）。
#'
#' **顏色**（`colors`）用設計語言的名稱，沒有給的照 KIT：
#'
#' | 名稱 | CSS 變數 | KIT | 用在 |
#' |---|---|---|---|
#' | `ink` | `--nb-ink` | `#141414` | 文字、框、陰影 |
#' | `page` | `--nb-page` | `#faf7f0` | 整頁背景 |
#' | `card` | `--nb-card` | `#ffffff` | 卡片、輸入框、表格 |
#' | `accent` | `--nb-lime` | `#c6d033` | 主角色塊：頁首、主要按鈕、目前的分頁 |
#' | `accent_light` | `--nb-bg-new` | `#e8f0a0` | 淡的主角色：圖解裡新加的欄、色階的淡端 |
#' | `primary` | `--nb-green` | `#006835` | 連結、勾選框、進度條、色階的深端 |
#' | `primary_hover` | `--nb-green-hover` | `#004d27` | 連結滑過 |
#' | `success` | `--nb-mint` | `#b9f0a8` | 【完成】 |
#' | `warning` | `--nb-yellow` | `#ffde59` | 【完成，但請注意】 |
#' | `danger` | `--nb-salmon` | `#ff9b8f` | 【停下來】、危險按鈕 |
#' | `info` | `--nb-sky` | `#a8dcff` | 資訊提示框 |
#'
#' 只給 `accent` 時，`accent_light` 由它算出來（和白色混合）；只給 `primary` 時，
#' `primary_hover` 由它算出來（加深）。色塊上的字一律是 `ink`：選 `accent` 與四個狀態色時，
#' 確認 `ink` 在上面的對比至少 4.5:1；`primary` 是文字色，在 `page` 上也要 4.5:1。
#'
#' **標誌**：`logo` 是頁首的完整標誌，`mark` 是瀏覽器分頁的小圖示（方形；沒有給時用
#' `logo`）。都是 SVG 或 PNG 檔的路徑；檔案在建立品牌時讀進來，所以之後換工作目錄也沒關係。
#' 在 Shiny 裡由一個只有這兩個檔的 htmlDependency 提供（不會公開檔案所在的資料夾）；
#' `kit_header(logo = "inline")` 時寫成 data URI。
#' `name = "KIT"` 而且沒有給 `logo` 時用 KIT 的標誌；其他名稱沒有給 `logo` 時，頁首不放標誌。
#' `logo = FALSE` 一律不放標誌。
#'
#' @param name 品牌名稱，例如 `"KIT"`、`"示範實驗室"`。
#' @param logo 頁首標誌的檔案路徑（SVG 或 PNG）；`NULL` 見上面；`FALSE` 不放標誌。
#' @param mark 瀏覽器分頁圖示的檔案路徑（SVG 或 PNG，方形）；`NULL` 時用 `logo`。
#' @param logo_alt 標誌的替代文字；`NULL` 時是「KIT 標誌」（KIT）或「<name> 標誌」。
#' @param colors 要換的顏色：具名 list 或具名字串向量，名稱見上表，值是 `"#RRGGBB"`
#'   或 R 認得的顏色名稱。不認得的名稱會停下來，列出可以用的名稱。
#' @return `kit_brand` 物件（list：`name`、`logo_alt`、`colors`（11 個 `#rrggbb`）、標誌檔）。
#' @seealso [kit_current_brand()]、[kit_page()]、[kit_theme()]、[kit_chart_sequential()]
#' @examples
#' kit_brand()
#'
#' # 別的研究室：藍色系、自己的標誌
#' demo <- kit_brand(
#'   "示範實驗室",
#'   logo = system.file("examples", "brand", "demo-logo.svg", package = "kitDesign"),
#'   mark = system.file("examples", "brand", "demo-mark.svg", package = "kitDesign"),
#'   colors = list(accent = "#9cc0ff", primary = "#1f4fa3", page = "#f5f7fa")
#' )
#' demo
#' if (interactive()) {
#'   options(kitDesign.brand = demo)   # 整個 app 用這個品牌
#'   kit_gallery()
#' }
#' @export
kit_brand <- function(name = "KIT", logo = NULL, mark = NULL, logo_alt = NULL,
                      colors = list()) {
  if (!is.character(name) || length(name) != 1 || is.na(name) || !nzchar(name)) {
    # 原文：name 要是一個字串，例如 \"KIT\"。
    stop("name \u8981\u662f\u4e00\u500b\u5b57\u4e32\uff0c\u4f8b\u5982 \"KIT\"\u3002", call. = FALSE)
  }
  is_kit <- identical(name, "KIT")
  # 原文：KIT 標誌 | 標誌
  if (is.null(logo_alt)) logo_alt <- if (is_kit) "KIT \u6a19\u8a8c" else paste(name, "\u6a19\u8a8c")
  if (!is.character(logo_alt) || length(logo_alt) != 1 || is.na(logo_alt)) {
    # 原文：logo_alt 要是一個字串。
    stop("logo_alt \u8981\u662f\u4e00\u500b\u5b57\u4e32\u3002", call. = FALSE)
  }

  # 標誌：KIT 內建（inst/logo）、自己的檔案，或沒有
  files <- list(logo = NULL, icons = list())
  if (isFALSE(logo)) {
    logo <- NULL
  } else if (is.null(logo)) {
    if (is_kit) {
      files$logo <- kit_builtin_file("kit-logo.svg")
      if (is.null(mark)) {
        files$icons <- list(kit_builtin_file("kit-mark.svg"), kit_builtin_file("kit-mark-64.png"))
      }
    }
  } else {
    files$logo <- kit_brand_file(logo, "logo", "logo")
  }
  if (!is.null(mark)) {
    files$icons <- list(kit_brand_file(mark, "mark", "mark"))
  } else if (!is.null(files$logo) && !isTRUE(files$logo$builtin)) {
    icon <- files$logo
    icon$file <- sub("^logo", "mark", icon$file)
    files$icons <- list(icon)
  }

  structure(
    list(name = name, logo_alt = logo_alt, colors = kit_brand_colors(colors), files = files),
    class = "kit_brand"
  )
}

#' 現在的品牌：`options(kitDesign.brand = )`，沒有設定時是 KIT
#'
#' kitDesign 的函式（[kit_page()]、[kit_header()]、[kit_theme()]、[kit_colors()]、
#' [kit_chart_sequential()]、[kit_plotly_style()]）的 `brand` 預設值。
#' app 只要在開始時設定一次 `options(kitDesign.brand = kit_brand(...))`。
#'
#' @return `kit_brand` 物件。
#' @seealso [kit_brand()]
#' @examples
#' kit_current_brand()$name
#' @export
kit_current_brand <- function() {
  b <- getOption("kitDesign.brand")
  if (is.null(b)) return(kit_brand())
  kit_check_brand(b, "options(kitDesign.brand = )")
}

#' @export
format.kit_brand <- function(x, ...) {
  logo <- function(f) {
    if (is.null(f)) return("none")
    if (isTRUE(f$builtin)) paste0(f$file, " (kitDesign)") else paste0(basename(f$source))
  }
  changed <- x$colors != KIT_BRAND_COLORS
  cols <- paste0(format(names(x$colors)), "  ", x$colors, ifelse(changed, "  *", ""))
  c(
    paste0("<kit_brand> ", x$name),
    paste0("  logo: ", logo(x$files$logo), "  (alt: ", x$logo_alt, ")"),
    paste0("  mark: ", if (length(x$files$icons) == 0) "none" else
      paste(vapply(x$files$icons, logo, ""), collapse = ", ")),
    "  colors (* = not KIT):",
    paste0("    ", cols)
  )
}

#' @export
print.kit_brand <- function(x, ...) {
  cat(format(x, ...), sep = "\n")
  invisible(x)
}

# 以下是內部的小工具 ----

#' 檢查是不是 kit_brand
#' @noRd
kit_check_brand <- function(brand, arg = "brand") {
  if (!inherits(brand, "kit_brand")) {
    # 原文： 要是 kit_brand() 做出來的品牌。
    stop(arg, " \u8981\u662f kit_brand() \u505a\u51fa\u4f86\u7684\u54c1\u724c\u3002", call. = FALSE)
  }
  brand
}

#' 顏色：檢查名稱與值，沒有給的照 KIT；只給 accent／primary 時算出淡色／滑過色
#' @noRd
kit_brand_colors <- function(colors) {
  if (is.null(colors) || length(colors) == 0) return(KIT_BRAND_COLORS)
  if (!(is.list(colors) || is.character(colors)) || is.null(names(colors)) ||
      any(!nzchar(names(colors)))) {
    # 原文：colors 要是具名的 list，例如 list(accent = \"#9cc0ff\", primary = \"#1f4fa3\")。
    stop("colors \u8981\u662f\u5177\u540d\u7684 list\uff0c\u4f8b\u5982 list(accent = \"#9cc0ff\", primary = \"#1f4fa3\")\u3002",
         call. = FALSE)
  }
  bad <- setdiff(names(colors), names(KIT_BRAND_COLORS))
  if (length(bad) > 0) {
    # 原文：colors 裡有不認得的名稱： | 。可以用的名稱：
    stop("colors \u88e1\u6709\u4e0d\u8a8d\u5f97\u7684\u540d\u7a31\uff1a", paste(bad, collapse = ", "), "\u3002\u53ef\u4ee5\u7528\u7684\u540d\u7a31\uff1a",
         # 原文：。
         paste(names(KIT_BRAND_COLORS), collapse = ", "), "\u3002", call. = FALSE)
  }
  given <- vapply(names(colors), function(nm) kit_hex(colors[[nm]], nm), character(1))
  out <- KIT_BRAND_COLORS
  out[names(given)] <- given
  if ("accent" %in% names(given) && !"accent_light" %in% names(given)) {
    out[["accent_light"]] <- kit_mix(out[["accent"]], "#ffffff", 0.55)
  }
  if ("primary" %in% names(given) && !"primary_hover" %in% names(given)) {
    out[["primary_hover"]] <- kit_mix(out[["primary"]], "#000000", 0.25)
  }
  out
}

#' 一個顏色 -> "#rrggbb"（不認得時停下來）
#' @noRd
kit_hex <- function(x, name) {
  ok <- is.character(x) && length(x) == 1 && !is.na(x) && nzchar(x)
  rgb <- if (ok) tryCatch(grDevices::col2rgb(x), error = function(e) NULL)
  if (is.null(rgb)) {
    # 原文： 不是顏色：要是 \"#RRGGBB\" 或 R 認得的顏色名稱。
    stop("colors$", name, " \u4e0d\u662f\u984f\u8272\uff1a\u8981\u662f \"#RRGGBB\" \u6216 R \u8a8d\u5f97\u7684\u984f\u8272\u540d\u7a31\u3002", call. = FALSE)
  }
  tolower(sprintf("#%02x%02x%02x", rgb[1], rgb[2], rgb[3]))
}

#' 兩個顏色在 Lab 空間混合（w = 0 是 a，1 是 b）
#' @noRd
kit_mix <- function(a, b, w) {
  f <- grDevices::colorRamp(c(a, b), space = "Lab")
  tolower(grDevices::rgb(f(w), maxColorValue = 255))
}

#' KIT 內建的標誌檔（inst/logo）
#' @noRd
kit_builtin_file <- function(file) {
  list(builtin = TRUE, file = file, type = kit_image_type(file))
}

#' 自己的標誌檔：檢查、讀進來
#' @noRd
kit_brand_file <- function(path, arg, stem) {
  if (!is.character(path) || length(path) != 1 || is.na(path) || !nzchar(path)) {
    # 原文： 要是一個 SVG 或 PNG 檔的路徑。
    stop(arg, " \u8981\u662f\u4e00\u500b SVG \u6216 PNG \u6a94\u7684\u8def\u5f91\u3002", call. = FALSE)
  }
  if (!file.exists(path) || dir.exists(path)) {
    # 原文： 的檔案找不到：
    stop(arg, " \u7684\u6a94\u6848\u627e\u4e0d\u5230\uff1a", path, call. = FALSE)
  }
  type <- kit_image_type(path)
  # 原文： 要是 SVG 或 PNG 檔：
  if (is.null(type)) stop(arg, " \u8981\u662f SVG \u6216 PNG \u6a94\uff1a", path, call. = FALSE)
  ext <- if (identical(type, "image/svg+xml")) "svg" else "png"
  list(builtin = FALSE, file = paste0(stem, ".", ext), type = type,
       raw = readBin(path, "raw", n = file.size(path)), source = normalizePath(path))
}

#' 檔名 -> MIME type（SVG、PNG 以外是 NULL）
#' @noRd
kit_image_type <- function(file) {
  ext <- tolower(sub("^.*\\.", "", basename(file)))
  switch(ext, svg = "image/svg+xml", png = "image/png", NULL)
}

#' 品牌是不是 KIT 的顏色
#' @noRd
kit_brand_is_kit_colors <- function(brand) {
  identical(unname(brand$colors), unname(KIT_BRAND_COLORS))
}

#' 自己的標誌檔（不是內建的）
#' @noRd
kit_brand_custom_files <- function(brand) {
  all <- c(list(brand$files$logo), brand$files$icons)
  Filter(function(f) !is.null(f) && !isTRUE(f$builtin), all)
}

#' 自己的標誌檔的識別碼（htmlDependency 的名稱；內容不同就不同）
#' @noRd
kit_brand_id <- function(files) {
  bytes <- unlist(lapply(files, function(f) c(charToRaw(f$file), f$raw)))
  x <- as.numeric(bytes)
  h1 <- sum(x * seq_along(x)) %% 2147483647
  h2 <- sum(x * rev(seq_along(x))) %% 2147483629
  sprintf("%08x%08x", as.integer(h1), as.integer(h2))
}

#' 自己的標誌檔的 htmlDependency：檔案先寫到暫存資料夾（只有這幾個檔）
#' @noRd
kit_brand_dependency <- function(brand) {
  files <- kit_brand_custom_files(brand)
  if (length(files) == 0) return(NULL)
  name <- paste0("kitDesign-brand-", kit_brand_id(files))
  dir <- file.path(tempdir(), name)
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  for (f in files) {
    path <- file.path(dir, f$file)
    if (!file.exists(path)) writeBin(f$raw, path)
  }
  htmltools::htmlDependency(name = name, version = kit_pkg_version(), src = dir, all_files = TRUE)
}

#' 一個標誌檔的網址：data URI（inline）、內建的、自己的
#' @noRd
kit_brand_src <- function(f, brand, inline) {
  if (isTRUE(f$builtin)) {
    return(if (inline) kit_logo_data(f$file) else kit_logo_file(f$file))
  }
  if (inline) return(paste0("data:", f$type, ";base64,", kit_base64(f$raw)))
  dep <- kit_brand_dependency(brand)
  paste0(dep$name, "-", dep$version, "/", f$file)
}

#' 和 KIT 不同的顏色寫成 CSS 變數（都一樣時是 NULL）
#'
#' `html:root` 比 kit-brite.css 的 `:root` 更具體，不管 `<style>` 放在哪裡都蓋得過去。
#' @noRd
kit_brand_css <- function(brand) {
  changed <- brand$colors != KIT_BRAND_COLORS
  if (!any(changed)) return(NULL)
  vars <- paste0(KIT_BRAND_VARS[changed], ": ", brand$colors[changed], ";")
  paste0("html:root { ", paste(vars, collapse = " "), " }")
}

#' 品牌示範（kit_gallery(brand = "demo")、tools/check_gallery.R 用）
#' @noRd
kit_brand_demo <- function() {
  dir <- system.file("examples", "brand", package = "kitDesign")
  kit_brand(
    # 原文：示範實驗室
    "\u793a\u7bc4\u5be6\u9a57\u5ba4",
    logo = file.path(dir, "demo-logo.svg"),
    mark = file.path(dir, "demo-mark.svg"),
    colors = list(accent = "#9cc0ff", accent_light = "#dbe7ff", primary = "#1f4fa3",
                  primary_hover = "#163a78", page = "#f5f7fa")
  )
}
