# 設定：主題、樣式與小程式、頁面、頁首、標誌
#
# 配色參考 KIT 資料跨波次串連平臺（https://kitwaves.hdfs.ntnu.edu.tw/）。
# 以 Bootswatch Brite 為底（bslib 0.11.0 起才有），套 KIT 的顏色與 neo-brutalism 樣式
# （inst/www/kit-brite.css；原本是 kitJoin 與 kitsUI 各一份的 kit_css_brite()）。

#' KIT 的 bslib 主題
#'
#' 以 Bootswatch Brite 為底（bslib 0.11.0 起才有），換成 KIT 的顏色；全文用圓體
#' Chiron GoRound TC，程式碼用 JetBrains Mono。兩種字型都由瀏覽器向 Google Fonts
#' 按需下載（`local = FALSE`）：CJK 字型切成上百個 unicode-range 片段，
#' 避免伺服器啟動時抓下全部字檔。
#'
#' 通常不用自己呼叫：[kit_page()] 已經用了它。
#'
#' @return [bslib::bs_theme()] 物件。
#' @seealso [kit_page()]、[use_kit()]
#' @examples
#' theme <- kit_theme()
#' bslib::theme_bootswatch(theme)
#' @export
kit_theme <- function() {
  # Bootswatch Brite 從 bslib 0.11.0 起才有：太舊時先停下來，說怎麼修
  # 原文：bslib 版本太舊（ | ），這個 app 需要 0.11.0 以上。請在 R 執行 install.packages(\"bslib\")，再重新開啟。
  if (utils::packageVersion("bslib") < "0.11.0") stop("bslib \u7248\u672c\u592a\u820a\uff08", utils::packageVersion("bslib"), "\uff09\uff0c\u9019\u500b app \u9700\u8981 0.11.0 \u4ee5\u4e0a\u3002\u8acb\u5728 R \u57f7\u884c install.packages(\"bslib\")\uff0c\u518d\u91cd\u65b0\u958b\u555f\u3002", call. = FALSE)
  # 未指定 wght 時只提供 400，需列出 CSS 用到的字重
  kit_font <- bslib::font_collection(
    bslib::font_google(
      "Chiron GoRound TC", local = FALSE, wght = c(400, 500, 700, 900)
    ),
    "sans-serif"
  )
  # 程式碼與等寬字：JetBrains Mono（只有拉丁字母；中文註解退回 app 的中文字型）
  code_font <- bslib::font_collection(
    bslib::font_google("JetBrains Mono", local = FALSE, wght = c(400, 700)),
    "Chiron GoRound TC", "Menlo", "Consolas", "monospace"
  )

  bslib::bs_theme(
    version = 5,
    bootswatch = "brite",
    primary = "#006835",
    secondary = "#616161",
    success = "#006835",
    info = "#2778c4",
    warning = "#d9730d",
    danger = "#d9534f",
    base_font = kit_font,
    # 全文統一用圓體；標題靠字重（700）和內文分開
    heading_font = kit_font,
    code_font = code_font,
    "navbar-bg" = "#006835",
    "body-bg" = "#faf7f0",
    "headings-font-weight" = 700,
    # neo-brutalism：2px 近黑線條（Brite 預設 2px 純黑）
    "border-width" = "2px",
    "border-color" = "#141414",
    # 連結用 KIT 綠（萊姆色當文字太淡）
    "link-color" = "#006835",
    "link-hover-color" = "#004d27",
    # 內文 1rem（Brite 預設 0.875rem）；html 的基準字級在 kit-brite.css 設成 17px
    "font-size-base" = "1rem"
  )
}

#' KIT 的樣式與瀏覽器端小程式（htmltools 的 dependency）
#'
#' 放進頁面任何地方都可以（htmltools 會把它搬到 `<head>`）。裡面有：
#'
#' - `kit-base.css`：頁首、說明框、提示框等基本樣式（原本的 `kit_css()`、`kit_css_guide()`）。
#' - `kit-brite.css`：KIT 的 neo-brutalism 樣式（原本的 `kit_css_brite()`）。
#' - `kit-design.css`：kitDesign 新加的少數規則（頁首排版、流程分頁的虛線分頁、程式碼框的寬度）。
#' - `kit.js`：收合區塊、分頁列、分頁狀態、捲到結果、離開前提醒、「複製」按鈕。
#'
#' 用 [kit_page()] 時已經加好了；自己用 `bslib::page_*()` 組頁面時才需要放
#' `use_kit()`，並把 `theme = kit_theme()` 傳給頁面。
#'
#' @return [htmltools::htmlDependency()] 物件。
#' @examples
#' use_kit()
#' @export
use_kit <- function() {
  htmltools::htmlDependency(
    name = "kitDesign",
    version = kit_pkg_version(),
    src = "www",
    package = "kitDesign",
    stylesheet = c("kit-base.css", "kit-brite.css", "kit-design.css"),
    script = "kit.js",
    all_files = FALSE
  )
}

#' kitDesign 自己的版本（htmlDependency 用）
#' @noRd
kit_pkg_version <- function() {
  as.character(utils::packageVersion("kitDesign"))
}

#' KIT 的頁面：主題、樣式、頁首，一次設定好
#'
#' 包住 `bslib::page_fluid(lang = "zh-Hant-TW", theme = kit_theme(), use_kit(), kit_header(...), ...)`。
#' 頁首下面接著放分頁列（[kit_navgroups()] 或 [kit_flow_tabs()]）與各分頁的內容。
#'
#' @param title 工具名稱（頁首的 h1，也是瀏覽器分頁的標題），例如「KIT 資料串接工具」。
#' @param subtitle 副標（粗體），例如資料庫名稱「臺灣幼兒發展調查資料庫」。
#' @param ... 頁面的內容。
#' @param tagline 接在副標後面的一句（例如「跨波次資料處理」）；`NULL` 不顯示。
#' @param version,date 頁首版本行的版本與日期，通常讀 app 自己的 DESCRIPTION：
#'   `kit_app_description("kitJoin")`。
#' @param logo 頁首要不要放 KIT 標誌：`TRUE`（標誌檔由 htmlDependency 提供，Shiny 裡用）、
#'   `"inline"`（標誌直接寫進頁面，給沒有 Shiny 的單一 HTML 檔，例如使用手冊）、`FALSE`。
#' @param meta_extra 版本行後面再接的字（例如「kits 0.25.0」）。
#' @param show_kitdesign 版本行後面要不要接 kitDesign 的版本（「kitDesign 0.1.0」），
#'   回報問題時兩個版本都看得到。
#' @param window_title 瀏覽器分頁的標題（預設和 `title` 一樣）。
#' @return 一個完整的頁面（`bslib::page_fluid()`）。
#' @seealso [kit_header()]、[kit_app_description()]
#' @examples
#' if (interactive()) {
#'   ui <- kit_page(
#'     "KIT ×× 工具", "臺灣幼兒發展調查資料庫",
#'     tagline = "跨波次資料處理", version = "0.1.0", date = "2026-10-31",
#'     kit_tab_guide("示範一頁。", kit_steps("選檔案", "按執行"), "一張表。")
#'   )
#'   shiny::shinyApp(ui, function(input, output, session) {})
#' }
#' @export
kit_page <- function(title, subtitle = NULL, ..., tagline = NULL, version = NULL,
                     date = NULL, logo = TRUE, meta_extra = NULL, window_title = title,
                     show_kitdesign = FALSE) {
  bslib::page_fluid(
    lang = "zh-Hant-TW",
    theme = kit_theme(),
    title = window_title,
    use_kit(),
    kit_header(
      title = title, subtitle = subtitle, tagline = tagline,
      version = version, date = date, meta_extra = meta_extra, logo = logo,
      show_kitdesign = show_kitdesign
    ),
    ...
  )
}

#' 讀取 app 的版本與日期（DESCRIPTION 的 Version、Date）
#'
#' 雲端版、本機 run.bat、套件的 `run_xxx()` 都以 DESCRIPTION 的 Version、Date 為準，
#' 三者顯示一致（不看檔案修改時間：解壓、安裝、部署都會改變 mtime）。
#'
#' 找的順序：
#' 1. `path` 有給：讀那個 DESCRIPTION 檔。
#' 2. `package` 已經載入（`library()`、`run_xxx()`、`load_all()`）：讀載入的那一份。
#' 3. 工作目錄的 `DESCRIPTION`，再往上一層、兩層找（測試時工作目錄在 `tests/testthat`）；
#'    有給 `package` 時，只認 `Package:` 是它的那一份。雲端版與 run.bat 用 `runApp(資料夾)`，
#'    套件沒有載入，讀的是這一份。
#' 4. `package` 有安裝（但沒有載入）：讀安裝的那一份。放在最後，因為它可能是舊版。
#'
#' @param package app 的套件名稱，例如 `"kitJoin"`；`NULL` 時只找 DESCRIPTION 檔。
#' @param path DESCRIPTION 檔的路徑；`NULL` 時照上面的順序找。
#' @return `list(version = , date = )`；找不到的是 `NA`。
#' @examples
#' kit_app_description("kitDesign")
#' @export
kit_app_description <- function(package = NULL, path = NULL) {
  none <- list(version = NA_character_, date = NA_character_)
  read_one <- function(file) {
    desc <- read.dcf(file, fields = c("Package", "Version", "Date"))
    list(package = unname(desc[1, "Package"]), version = unname(desc[1, "Version"]),
         date = unname(desc[1, "Date"]))
  }
  if (!is.null(path)) {
    if (!file.exists(path)) return(none)
    d <- read_one(path)
    return(list(version = d$version, date = d$date))
  }
  installed <- function() {
    desc <- utils::packageDescription(package)
    list(version = desc$Version %||% NA_character_, date = desc$Date %||% NA_character_)
  }
  if (!is.null(package) && package %in% loadedNamespaces()) return(installed())
  paths <- c("DESCRIPTION", file.path("..", "DESCRIPTION"), file.path("..", "..", "DESCRIPTION"))
  for (p in paths[file.exists(paths)]) {
    d <- read_one(p)
    if (is.null(package) || identical(d$package, package)) {
      return(list(version = d$version, date = d$date))
    }
  }
  if (!is.null(package) && nzchar(system.file(package = package))) return(installed())
  none
}

#' 頁首的版本行，例如「v0.5.0 · 2026-10-31」
#'
#' 版本行永遠在頁首，回報問題時用得到。
#'
#' @param version 版本（前面自動加「v」）；`NULL` 或 `NA` 不顯示。
#' @param date 日期；`NULL` 或 `NA` 不顯示。
#' @param extra 後面再接的字（例如 `paste("kits", utils::packageVersion("kits"))`）。
#' @param show_kitdesign 後面要不要接「kitDesign 0.1.0」（[kit_versions()]）。
#' @return `<div class="kit-app-meta">`；三樣都沒有時是 `NULL`。
#' @examples
#' kit_app_meta("0.5.0", "2026-10-31")
#' @export
kit_app_meta <- function(version = NULL, date = NULL, extra = NULL, show_kitdesign = FALSE) {
  ok <- function(x) !is.null(x) && length(x) == 1 && !is.na(x) && nzchar(x)
  parts <- c(
    if (ok(version)) paste0("v", version),
    if (ok(date)) date,
    unlist(extra),
    if (isTRUE(show_kitdesign)) paste("kitDesign", kit_versions()[["kitDesign"]])
  )
  if (length(parts) == 0) return(NULL)
  # 原文： · 
  shiny::div(class = "kit-app-meta", paste(parts, collapse = " \u00b7 "))
}

#' KIT 頁首
#'
#' 萊姆色塊、黑框、頁首陰影；左邊完整標誌，右邊工具名稱、一行副標、一行版本。
#' 一個 app 只有一個，放在最上面（[kit_page()] 已經放好了）。也會設定瀏覽器分頁的
#' 圖示（豆子標誌）。
#'
#' @inheritParams kit_page
#' @return `<div class="kit-header mb-4">`。
#' @examples
#' kit_header("KIT 資料串接工具", "臺灣幼兒發展調查資料庫", tagline = "跨波次資料處理",
#'            version = "0.5.0", date = "2026-10-31")
#' @export
kit_header <- function(title, subtitle = NULL, tagline = NULL, version = NULL, date = NULL,
                       meta_extra = NULL, logo = TRUE, show_kitdesign = FALSE) {
  sub_line <- if (!is.null(subtitle) || !is.null(tagline)) {
    shiny::p(
      if (!is.null(subtitle)) shiny::tags$span(class = "kit-subtitle", subtitle),
      # 原文： · 
      if (!is.null(subtitle) && !is.null(tagline)) " \u00b7 ",
      tagline
    )
  }
  inline <- identical(logo, "inline")
  src <- function(file) if (inline) kit_logo_data(file) else kit_logo_file(file)
  header <- shiny::div(
    class = "kit-header mb-4",
    # 分頁圖示（favicon）：向量的豆子，舊的瀏覽器用 PNG；Shiny 會把 tags$head() 搬到 <head>
    shiny::tags$head(
      shiny::tags$link(rel = "icon", type = "image/svg+xml", href = src("kit-mark.svg")),
      shiny::tags$link(rel = "alternate icon", type = "image/png", href = src("kit-mark-64.png"))
    ),
    shiny::div(
      class = "kit-header-row",
      if (isTRUE(logo) || inline) {
        # 向量標誌（SVG）：放大縮小都清楚；檔案由 htmlDependency 提供（inline 時寫進頁面）
        # 原文：KIT 標誌
        shiny::tags$img(src = src("kit-logo.svg"), alt = "KIT \u6a19\u8a8c", class = "kit-header-logo")
      },
      shiny::div(
        shiny::h1(title),
        sub_line,
        kit_app_meta(version, date, meta_extra, show_kitdesign = show_kitdesign)
      )
    )
  )
  if (inline) return(header)
  htmltools::attachDependencies(header, kit_logo_dependency(), append = TRUE)
}

#' 標誌檔寫成 data URI（kit_header(logo = "inline") 用）
#' @noRd
kit_logo_data <- function(file) {
  path <- system.file("logo", file, package = "kitDesign")
  if (!nzchar(path)) stop("No such logo file: ", file, call. = FALSE)
  type <- if (grepl("\\.svg$", file)) "image/svg+xml" else "image/png"
  paste0("data:", type, ";base64,", kit_base64(readBin(path, "raw", n = file.size(path))))
}

#' 標誌檔（inst/logo/）的 htmlDependency：頁首的 SVG 與分頁圖示用網址取得
#'
#' @return [htmltools::htmlDependency()] 物件；檔案的網址是 `kitDesign-logo-<版本>/<檔名>`
#'   （[kit_logo_file()]）。
#' @examples
#' kit_logo_dependency()$name
#' @export
kit_logo_dependency <- function() {
  htmltools::htmlDependency(
    name = "kitDesign-logo",
    version = kit_pkg_version(),
    src = "logo",
    package = "kitDesign",
    all_files = TRUE
  )
}

#' 標誌檔的網址（頁面上用）
#'
#' 頁首的向量標誌與分頁圖示都用它；網址由 [kit_logo_dependency()] 提供
#' （頁面要有這個 dependency：[kit_header()] 已經附上了）。
#' 要嵌進頁面、不另外取檔時，用 [kit_logo_uri()]（PNG 的 data URI）。
#'
#' @param file `inst/logo/` 裡的檔名：`"kit-logo.svg"`（完整標誌）、`"kit-mark.svg"`（豆子）、
#'   或 PNG（`"kit-mark-64.png"`、`"kit-logo-h512.png"`…）。
#' @return 相對網址，例如 `"kitDesign-logo-0.1.0/kit-logo.svg"`。
#' @examples
#' kit_logo_file("kit-logo.svg")
#' @export
kit_logo_file <- function(file = "kit-logo.svg") {
  if (!nzchar(system.file("logo", file, package = "kitDesign"))) {
    stop("No such logo file: ", file, call. = FALSE)
  }
  paste0("kitDesign-logo-", kit_pkg_version(), "/", file)
}

#' KIT 標誌（data URI）
#'
#' 直接放進頁面（不用另外設定靜態檔案的路徑）。標誌是透明底 PNG，在 `inst/logo/`。
#'
#' @param size 像素：豆子（`"mark"`）有 64、96、256、`"h512"`、`"h1024"`；完整標誌（`"logo"`，
#'   豆子＋KIT 字樣）有 128、192、`"h512"`、`"h1024"`（高度）。頁首用的是向量標誌
#'   （[kit_logo_file()]），這個函式給要嵌進頁面的 PNG。
#' @param kind `"mark"` 只有豆子（瀏覽器分頁圖示）；`"logo"` 完整標誌（頁首）。
#' @return `"data:image/png;base64,..."`；沒有這個大小時是 `""`。
#' @examples
#' substr(kit_logo_uri(64), 1, 30)
#' @export
kit_logo_uri <- function(size = 96, kind = c("mark", "logo")) {
  kind <- match.arg(kind)
  path <- kit_logo_path(size, kind)
  if (!nzchar(path)) return("")
  bytes <- readBin(path, "raw", n = file.size(path))
  paste0("data:image/png;base64,", kit_base64(bytes))
}

#' 標誌檔的路徑（找不到時是 ""）
#' @noRd
kit_logo_path <- function(size, kind) {
  system.file("logo", paste0("kit-", kind, "-", size, ".png"), package = "kitDesign")
}

#' base64 編碼（只用 base R，不另外依賴 base64enc）
#' @noRd
kit_base64 <- function(bytes) {
  if (length(bytes) == 0) return("")
  alphabet <- c(LETTERS, letters, 0:9, "+", "/")
  x <- as.integer(bytes)
  pad <- (3 - length(x) %% 3) %% 3
  x <- c(x, rep(0L, pad))
  m <- matrix(x, nrow = 3)
  n <- m[1, ] * 65536L + m[2, ] * 256L + m[3, ]
  idx <- rbind(n %/% 262144L, (n %/% 4096L) %% 64L, (n %/% 64L) %% 64L, n %% 64L)
  chars <- alphabet[as.vector(idx) + 1L]
  if (pad > 0) chars[(length(chars) - pad + 1):length(chars)] <- "="
  paste(chars, collapse = "")
}

#' KIT 品牌色常數（供自訂 CSS 或圖表使用）
#'
#' 和 kitJoin、kitsUI 的 `kit_colors()` 相同的值。介面元件的顏色在 CSS 的 tokens 裡
#' （`var(--nb-lime)` 等，見 `brand/KIT設計語言.md` 的附錄）。
#'
#' @return 具名 list。
#' @examples
#' kit_colors()$primary
#' @export
kit_colors <- function() {
  list(
    primary = "#006835",
    primary_light = "#3a8f45",
    accent = "#c6d033",
    subtitle = "#e8f0a0",
    body_bg = "#f5f5f5",
    text_muted = "#424242",
    border = "#e0e0e0",
    info = "#2778c4",
    danger = "#d9534f"
  )
}

#' x 為 NULL 時改用 y（R 4.4 起 base 也有，這裡為了支援較舊的 R）
#' @noRd
`%||%` <- function(x, y) if (is.null(x)) y else x

#' 版本：kitDesign 與 app 自己的
#'
#' 回報問題時，兩個版本都要寫。頁首的版本行可以接上 kitDesign 的版本：
#' `kit_page(..., show_kitdesign = TRUE)` →「v0.5.0 · 2026-10-31 · kitDesign 0.1.0」。
#'
#' @param package app 的套件名稱（例如 `"kitJoin"`）；`NULL` 時只有 kitDesign。
#'   版本讀法和 [kit_app_description()] 一樣。
#' @return 具名字串向量，例如 `c(kitDesign = "0.1.0", kitJoin = "0.5.0")`。
#' @examples
#' kit_versions()
#' @export
kit_versions <- function(package = NULL) {
  out <- c(kitDesign = kit_pkg_version())
  if (!is.null(package)) out[[package]] <- kit_app_description(package)$version
  out
}
