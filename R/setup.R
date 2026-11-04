# 設定：主題、樣式與小程式、頁面、頁首、標誌
#
# 配色參考 KIT 資料跨波次串連平臺（https://kitwaves.hdfs.ntnu.edu.tw/）。
# 以 Bootswatch Brite 為底（bslib 0.11.0 起才有），套 KIT 的顏色與 neo-brutalism 樣式
# （inst/www/kit-brite.css；原本是 kitJoin 與 kitsUI 各一份的 kit_css_brite()）。

#' KIT's bslib theme
#'
#' Based on Bootswatch Brite (available from bslib 0.11.0), with KIT's colors; all text uses the
#' rounded typeface Chiron GoRound TC, code uses JetBrains Mono. Both typefaces are downloaded by
#' the browser from Google Fonts on demand (`local = FALSE`): CJK typefaces are split into hundreds
#' of unicode-range pieces, so the server does not fetch every font file at startup.
#'
#' You usually do not need to call it yourself: [kit_page()] already uses it.
#'
#' Colors come from the brand ([kit_brand()]): `primary`, `success`, `navbar-bg`, and `link-color`
#' are the brand's `primary`; `link-hover-color` is `primary_hover`; `body-bg` is `page`;
#' `border-color` is `ink`. `info`, `warning`, `danger`, and `secondary` are Bootstrap's own dark
#' colors and do not change with the brand (the background colors of callouts and status boxes are
#' in the CSS `--nb-*` variables, which do change with the brand).
#' brand.yml is not read (`bslib::bs_theme(brand = FALSE)`): when the working directory or a parent
#' has a `_brand.yml` (for example `brand/_brand.yml`), the theme does not change.
#'
#' @param brand The brand ([kit_brand()]); defaults to [kit_current_brand()] (KIT when not set).
#' @return A [bslib::bs_theme()] object.
#' @seealso [kit_page()], [use_kit()], [kit_brand()]
#' @examples
#' theme <- kit_theme()
#' bslib::theme_bootswatch(theme)
#' @export
kit_theme <- function(brand = kit_current_brand()) {
  col <- kit_check_brand(brand)$colors
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
    # 品牌只從 kit_brand() 來：不讀工作目錄（或上層）的 _brand.yml
    brand = FALSE,
    primary = col[["primary"]],
    secondary = "#616161",
    success = col[["primary"]],
    info = "#2778c4",
    warning = "#d9730d",
    danger = "#d9534f",
    base_font = kit_font,
    # 全文統一用圓體；標題靠字重（700）和內文分開
    heading_font = kit_font,
    code_font = code_font,
    "navbar-bg" = col[["primary"]],
    "body-bg" = col[["page"]],
    "headings-font-weight" = 700,
    # neo-brutalism：2px 近黑線條（Brite 預設 2px 純黑）
    "border-width" = "2px",
    "border-color" = col[["ink"]],
    # 連結用 KIT 綠（萊姆色當文字太淡）
    "link-color" = col[["primary"]],
    "link-hover-color" = col[["primary_hover"]],
    # 內文 1rem（Brite 預設 0.875rem）；html 的基準字級在 kit-brite.css 設成 17px
    "font-size-base" = "1rem"
  )
}

#' KIT styles and browser-side scripts (an htmltools dependency)
#'
#' Can go anywhere in the page (htmltools moves it into `<head>`). It contains:
#'
#' - `kit-base.css`: basic styles for the header, guide boxes, callouts, and so on (formerly
#'   `kit_css()`, `kit_css_guide()`).
#' - `kit-brite.css`: KIT's neo-brutalism styles (formerly `kit_css_brite()`).
#' - `kit-design.css`: the few rules kitDesign adds (header layout, dashed tabs in flow tabs, code
#'   box width).
#' - `kit.js`: collapsible sections, tab bars, tab states, scrolling to results, the reminder before
#'   leaving, and the "複製" ("Copy") button.
#'
#' [kit_page()] already adds it; you only need to add `use_kit()` when you build the page yourself
#' with `bslib::page_*()`, and pass `theme = kit_theme()` to the page.
#'
#' @return An [htmltools::htmlDependency()] object.
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

#' kitDesign's own version (for htmlDependency)
#' @noRd
kit_pkg_version <- function() {
  as.character(utils::packageVersion("kitDesign"))
}

#' A KIT page: theme, styles, and header set up in one call
#'
#' Wraps
#' `bslib::page_fluid(lang = "zh-Hant-TW", theme = kit_theme(), use_kit(), kit_header(...), ...)`.
#' Below the header, put the tab bar ([kit_navgroups()] or [kit_flow_tabs()]) and the content of
#' each tab.
#'
#' @param title The tool name (the header's h1, also the browser tab title), for example
#'   "KIT 資料串接工具" ("KIT data join tool").
#' @param subtitle The subtitle (bold), for example the database name "臺灣幼兒發展調查資料庫" (the
#'   KIT database).
#' @param ... The page content.
#' @param tagline A phrase after the subtitle (for example "跨波次資料處理", "cross-wave data
#'   processing"); `NULL` shows nothing.
#' @param version,date The version and date on the header's version line, usually read from the
#'   app's own DESCRIPTION: `kit_app_description("kitJoin")`.
#' @param package The app's package name, written at the start of the version line:
#'   "kitJoin v0.6.0 · 2026-10-31". Anyone reporting a problem can see at once which app and which
#'   version. `NULL` (the default) writes no name, as before.
#' @param logo Whether the header shows the brand logo (KIT's is the bean plus the KIT wordmark):
#'   `TRUE` (the logo file comes from an htmlDependency; use in Shiny), `"inline"` (the logo is
#'   written into the page, for single HTML files without Shiny, such as user manuals), or `FALSE`.
#' @param brand The brand: logo, tab icon, and colors ([kit_brand()]). Defaults to
#'   [kit_current_brand()]: KIT when `options(kitDesign.brand = )` is not set.
#' @param meta_extra Another main package on the version line, after the app and before the date
#'   (for example "kits v0.25.0": kitsUI is the interface, kits the computation underneath).
#' @param show_kitdesign Whether to add the kitDesign version ("kitDesign v0.1.0") before the date.
#'   Usually not needed: kitDesign is the template, not one of the app's main packages.
#' @param validation Whether the version line ends with a link "驗證報告" to the app's validation
#'   report on GitHub ([kit_validation_url()]); needs `package`.
#' @param window_title The browser tab title (defaults to `title`).
#' @return A complete page (`bslib::page_fluid()`).
#' @seealso [kit_header()], [kit_app_description()]
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
                     show_kitdesign = FALSE, brand = kit_current_brand(), package = NULL,
                     validation = FALSE) {
  brand <- kit_check_brand(brand)
  bslib::page_fluid(
    lang = "zh-Hant-TW",
    theme = kit_theme(brand),
    title = window_title,
    use_kit(),
    kit_header(
      title = title, subtitle = subtitle, tagline = tagline,
      version = version, date = date, meta_extra = meta_extra, logo = logo,
      show_kitdesign = show_kitdesign, brand = brand, package = package, validation = validation
    ),
    ...
  )
}

#' Read the app's version and date (Version and Date in DESCRIPTION)
#'
#' The cloud version, the local run.bat, and the package's `run_xxx()` all take Version and Date
#' from DESCRIPTION, so all three show the same thing (file modification times are not used:
#' unzipping, installing, and deploying all change the mtime).
#'
#' Search order:
#' 1. `path` is given: read that DESCRIPTION file.
#' 2. `package` is already loaded (`library()`, `run_xxx()`, `load_all()`): read the loaded copy.
#' 3. `DESCRIPTION` in the working directory, then one and two levels up (in tests the working
#'    directory is `tests/testthat`); when `package` is given, only a file whose `Package:` matches
#'    counts. The cloud version and run.bat use `runApp(folder)`, the package is not loaded, and
#'    this is the copy that gets read.
#' 4. `package` is installed (but not loaded): read the installed copy. This comes last because it
#'    may be an old version.
#'
#' @param package The app's package name, e.g. `"kitJoin"`; when `NULL`, only DESCRIPTION files are
#'   searched.
#' @param path Path to a DESCRIPTION file; when `NULL`, searched in the order above.
#' @return `list(version = , date = )`; anything not found is `NA`.
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

#' The version line in the header, e.g. "kitJoin v0.6.0 · 2026-10-31"
#'
#' The version line always sits in the header; it is needed when reporting problems. The packages
#' come first, then the date: the app, `extra` (another main package, such as kits for kitsUI:
#' "kitsUI v0.8.3 · kits v0.25.2 · 2026-11-02"), then kitDesign when `show_kitdesign = TRUE`.
#' Every version is written with "v".
#'
#' @param version The version ("v" is added in front); `NULL` or `NA` shows nothing.
#' @param date The date; `NULL` or `NA` shows nothing.
#' @param extra Text placed after the app and before the date: another main package
#'   (e.g. `paste0("kits v", utils::packageVersion("kits"))`).
#' @param show_kitdesign Whether to add "kitDesign v0.1.0" ([kit_versions()]). Usually not
#'   needed: kitDesign is the template, not one of the app's main packages.
#' @param package The app's package name, written before the version ("kitJoin v0.6.0"); `NULL`
#'   writes no name.
#' @param validation Whether to add a link "驗證報告" to the package's validation report after the
#'   date ([kit_validation_url()]); needs `package`.
#' @return `<div class="kit-app-meta">`; `NULL` when all three are missing.
#' @examples
#' kit_app_meta("0.5.0", "2026-10-31")
#' kit_app_meta("0.6.0", "2026-10-31", package = "kitJoin")
#' @export
kit_app_meta <- function(version = NULL, date = NULL, extra = NULL, show_kitdesign = FALSE,
                         package = NULL, validation = FALSE) {
  ok <- function(x) !is.null(x) && length(x) == 1 && !is.na(x) && nzchar(x)
  # 套件名稱和版本是同一段：「kitJoin v0.6.0」（沒有版本時只寫名稱）
  app <- paste(c(if (ok(package)) package, if (ok(version)) paste0("v", version)), collapse = " ")
  # 先列套件（app、extra、kitDesign），日期放最後：「kitsUI v0.8.3 · kits v0.25.2 · 2026-11-02」
  parts <- c(
    if (nzchar(app)) app,
    unlist(extra),
    if (isTRUE(show_kitdesign)) paste0("kitDesign v", kit_versions()[["kitDesign"]]),
    if (ok(date)) date
  )
  if (length(parts) == 0) return(NULL)
  # 原文： · 
  line <- paste(parts, collapse = " \u00b7 ")
  if (!isTRUE(validation) || !ok(package)) return(shiny::div(class = "kit-app-meta", line))
  # 原文： · 
  # 同一行、沒有多的空白：「kitsUI v0.8.8 · kits v0.26.1 · 2026-11-04 · 驗證報告」
  link <- as.character(kit_validation_link(package))
  shiny::div(class = "kit-app-meta", shiny::HTML(paste0(htmltools::htmlEscape(line), " \u00b7 ", link)))
}

#' KIT header
#'
#' A lime color block, black border, header shadow; the full logo on the left, and on the right the
#' tool name, one subtitle line, and one version line. One per app, at the very top ([kit_page()]
#' already places it). It also sets the browser tab icon (the bean logo for KIT).
#'
#' Logo, tab icon, and colors come from the brand ([kit_brand()]). When the brand's colors differ
#' from KIT's, the header adds a short `<style>` that overrides the differing `--nb-*` variables;
#' for the KIT brand nothing is added and the page is the same as before.
#'
#' @inheritParams kit_page
#' @return `<div class="kit-header mb-4">`.
#' @examples
#' kit_header("KIT 資料串接工具", "臺灣幼兒發展調查資料庫", tagline = "跨波次資料處理",
#'            version = "0.6.0", date = "2026-10-31", package = "kitJoin")
#' @export
kit_header <- function(title, subtitle = NULL, tagline = NULL, version = NULL, date = NULL,
                       meta_extra = NULL, logo = TRUE, show_kitdesign = FALSE,
                       brand = kit_current_brand(), package = NULL, validation = FALSE) {
  brand <- kit_check_brand(brand)
  sub_line <- if (!is.null(subtitle) || !is.null(tagline)) {
    shiny::p(
      if (!is.null(subtitle)) shiny::tags$span(class = "kit-subtitle", subtitle),
      # 原文： · 
      if (!is.null(subtitle) && !is.null(tagline)) " \u00b7 ",
      tagline
    )
  }
  inline <- identical(logo, "inline")
  src <- function(f) kit_brand_src(f, brand, inline)
  icons <- brand$files$icons
  logo_file <- brand$files$logo
  css <- kit_brand_css(brand)
  header <- shiny::div(
    class = "kit-header mb-4",
    # 分頁圖示（favicon）：KIT 是向量的豆子，舊的瀏覽器用 PNG；Shiny 會把 tags$head() 搬到 <head>
    shiny::tags$head(
      lapply(seq_along(icons), function(i) {
        shiny::tags$link(rel = if (i == 1) "icon" else "alternate icon", type = icons[[i]]$type,
                         href = src(icons[[i]]))
      }),
      if (!is.null(css)) shiny::tags$style(css)
    ),
    shiny::div(
      class = "kit-header-row",
      if ((isTRUE(logo) || inline) && !is.null(logo_file)) {
        # 向量標誌（SVG）：放大縮小都清楚；檔案由 htmlDependency 提供（inline 時寫進頁面）
        shiny::tags$img(src = src(logo_file), alt = brand$logo_alt, class = "kit-header-logo")
      },
      shiny::div(
        shiny::h1(title),
        sub_line,
        kit_app_meta(version, date, meta_extra, show_kitdesign = show_kitdesign, package = package,
                     validation = validation)
      )
    )
  )
  if (inline) return(header)
  files <- c(list(logo_file), icons)
  deps <- c(
    if (any(vapply(files, function(f) isTRUE(f$builtin), logical(1)))) list(kit_logo_dependency()),
    list(kit_brand_dependency(brand))
  )
  deps <- Filter(Negate(is.null), deps)
  if (length(deps) == 0) return(header)
  htmltools::attachDependencies(header, deps, append = TRUE)
}

#' A logo file as a data URI (for kit_header(logo = "inline"))
#' @noRd
kit_logo_data <- function(file) {
  path <- system.file("logo", file, package = "kitDesign")
  if (!nzchar(path)) stop("No such logo file: ", file, call. = FALSE)
  type <- if (grepl("\\.svg$", file)) "image/svg+xml" else "image/png"
  paste0("data:", type, ";base64,", kit_base64(readBin(path, "raw", n = file.size(path))))
}

#' htmlDependency for the logo files (inst/logo/): the header SVG and tab icon are fetched by URL
#'
#' @return An [htmltools::htmlDependency()] object; file URLs are
#'   `kitDesign-logo-<version>/<file name>` ([kit_logo_file()]).
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

#' URL of a logo file (for use on the page)
#'
#' Used for both the header's vector logo and the tab icon; the URL is served by
#' [kit_logo_dependency()] (the page must include this dependency: [kit_header()] already attaches
#' it). To embed the logo in the page without a separate file, use [kit_logo_uri()] (a PNG data
#' URI).
#'
#' @param file A file name in `inst/logo/`: `"kit-logo.svg"` (full logo), `"kit-mark.svg"` (the
#'   bean), or a PNG (`"kit-mark-64.png"`, `"kit-logo-h512.png"`…).
#' @return A relative URL, e.g. `"kitDesign-logo-0.1.0/kit-logo.svg"`.
#' @examples
#' kit_logo_file("kit-logo.svg")
#' @export
kit_logo_file <- function(file = "kit-logo.svg") {
  if (!nzchar(system.file("logo", file, package = "kitDesign"))) {
    stop("No such logo file: ", file, call. = FALSE)
  }
  paste0("kitDesign-logo-", kit_pkg_version(), "/", file)
}

#' KIT logo (data URI)
#'
#' Goes straight into the page (no static file path to set up). The logos are transparent PNGs in
#' `inst/logo/`.
#'
#' @param size Pixels: the bean (`"mark"`) comes in 64, 96, 256, `"h512"`, `"h1024"`; the full logo
#'   (`"logo"`, bean plus KIT wordmark) comes in 128, 192, `"h512"`, `"h1024"` (height). The header
#'   uses the vector logo ([kit_logo_file()]); this function gives a PNG to embed in the page.
#' @param kind `"mark"` is the bean only (browser tab icon); `"logo"` is the full logo (header).
#' @return `"data:image/png;base64,..."`; `""` when that size does not exist.
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

#' Path to a logo file ("" when not found)
#' @noRd
kit_logo_path <- function(size, kind) {
  system.file("logo", paste0("kit-", kind, "-", size, ".png"), package = "kitDesign")
}

#' base64 encoding (base R only, no dependency on base64enc)
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

#' KIT brand color constants (for custom CSS or charts)
#'
#' Same names as `kit_colors()` in kitJoin and kitsUI. Colors for UI components are in the CSS
#' tokens (`var(--nb-lime)` etc.; see the appendix of `brand/en/design-language.md`).
#' `primary`, `accent`, and `subtitle` come from the brand (`primary`, `accent`, and `accent_light`
#' in [kit_brand()]); `primary_light` is a lighter `primary`; the rest are fixed neutrals and older
#' alert colors.
#'
#' @param brand The brand ([kit_brand()]); defaults to [kit_current_brand()] (KIT when none is set).
#' @return A named list.
#' @examples
#' kit_colors()$primary
#' @export
kit_colors <- function(brand = kit_current_brand()) {
  col <- kit_check_brand(brand)$colors
  primary_light <- if (identical(col[["primary"]], KIT_BRAND_COLORS[["primary"]])) {
    "#3a8f45"
  } else {
    kit_mix(col[["primary"]], "#ffffff", 0.25)
  }
  list(
    primary = col[["primary"]],
    primary_light = primary_light,
    accent = col[["accent"]],
    subtitle = col[["accent_light"]],
    body_bg = "#f5f5f5",
    text_muted = "#424242",
    border = "#e0e0e0",
    info = "#2778c4",
    danger = "#d9534f"
  )
}

#' Use y when x is NULL (base R has this from R 4.4; defined here to support older R)
#' @noRd
`%||%` <- function(x, y) if (is.null(x)) y else x

#' Versions: kitDesign and the app's own
#'
#' When reporting a problem, include both versions. The header's version line can include the
#' kitDesign version:
#' `kit_page(..., show_kitdesign = TRUE)` → "v0.5.0 · kitDesign v0.1.0 · 2026-10-31".
#'
#' @param package The app's package name (for example `"kitJoin"`); with `NULL`, only kitDesign.
#'   Versions are read the same way as [kit_app_description()].
#' @return A named character vector, for example `c(kitDesign = "0.1.0", kitJoin = "0.5.0")`.
#' @examples
#' kit_versions()
#' @export
kit_versions <- function(package = NULL) {
  out <- c(kitDesign = kit_pkg_version())
  if (!is.null(package)) out[[package]] <- kit_app_description(package)$version
  out
}
