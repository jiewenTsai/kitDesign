# 品牌：標誌與顏色

demo_dir <- function() system.file("examples", "brand", package = "kitDesign")

# 一個 1x1 的 PNG
tiny_png <- function() {
  path <- tempfile(fileext = ".png")
  writeBin(as.raw(c(
    0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d, 0x49, 0x48, 0x44, 0x52,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1f, 0x15, 0xc4,
    0x89, 0x00, 0x00, 0x00, 0x0d, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9c, 0x63, 0x60, 0x60, 0x60, 0xf8,
    0x0f, 0x00, 0x01, 0x04, 0x01, 0x00, 0x5f, 0xe5, 0xc3, 0x4b, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45,
    0x4e, 0x44, 0xae, 0x42, 0x60, 0x82
  )), path)
  path
}

blue <- function(...) {
  kit_brand("示範實驗室", logo = file.path(demo_dir(), "demo-logo.svg"),
            mark = file.path(demo_dir(), "demo-mark.svg"),
            colors = list(accent = "#9cc0ff", primary = "#1f4fa3", page = "#f5f7fa"), ...)
}

test_that("kit_brand() with no arguments is KIT", {
  b <- kit_brand()
  expect_s3_class(b, "kit_brand")
  expect_equal(b$name, "KIT")
  expect_equal(b$logo_alt, "KIT 標誌")
  expect_equal(names(b$colors), c("ink", "page", "card", "accent", "accent_light", "primary",
                                  "primary_hover", "success", "warning", "danger", "info"))
  expect_equal(b$colors[["accent"]], "#c6d033")
  expect_equal(b$colors[["primary"]], "#006835")
  expect_true(b$files$logo$builtin)
  expect_equal(b$files$logo$file, "kit-logo.svg")
  expect_equal(vapply(b$files$icons, `[[`, "", "file"), c("kit-mark.svg", "kit-mark-64.png"))
  expect_null(kitDesign:::kit_brand_css(b))
  expect_identical(kit_current_brand(), b)
  expect_output(print(b), "<kit_brand> KIT")
})

test_that("every token matches a --nb-* variable in kit-brite.css with the KIT value", {
  brite <- paste(readLines(system.file("www", "kit-brite.css", package = "kitDesign"),
                           encoding = "UTF-8"), collapse = "\n")
  vars <- kitDesign:::KIT_BRAND_VARS
  cols <- kitDesign:::KIT_BRAND_COLORS
  expect_equal(names(vars), names(cols))
  for (nm in names(vars)) {
    expect_match(brite, paste0(vars[[nm]], ": ", cols[[nm]], ";"), fixed = TRUE, info = nm)
  }
})

test_that("the CSS files use variables, not KIT's brand hexes, outside :root", {
  dir <- system.file("www", package = "kitDesign")
  for (f in c("kit-base.css", "kit-brite.css", "kit-design.css")) {
    css <- readLines(file.path(dir, f), encoding = "UTF-8")
    css <- css[!grepl("^\\s*--nb-", css)]
    hits <- grep("#006835|#c6d033|#3a8f45|#e8f0a0|#004d27", css, ignore.case = TRUE, value = TRUE)
    expect_length(hits, 0)
  }
})

test_that("unknown colour names stop with the list of valid names", {
  expect_error(kit_brand(colors = list(lime = "#c6d033")),
               "colors 裡有不認得的名稱：lime。可以用的名稱：ink, page, card, accent", fixed = TRUE)
  expect_error(kit_brand(colors = list(accent = "not-a-colour")), "colors\\$accent 不是顏色")
  expect_error(kit_brand(colors = list("#fff")), "具名")
  expect_error(kit_brand(name = ""), "name")
  expect_error(kit_brand(logo = "/no/such/logo.svg"), "logo 的檔案找不到")
  bad <- tempfile(fileext = ".gif")
  writeBin(as.raw(1:4), bad)
  expect_error(kit_brand("X", logo = bad), "SVG 或 PNG")
  expect_error(kit_page("X", brand = list()), "kit_brand()", fixed = TRUE)
  withr_opt <- options(kitDesign.brand = "blue")
  on.exit(options(withr_opt), add = TRUE)
  expect_error(kit_current_brand(), "options(kitDesign.brand = )", fixed = TRUE)
})

test_that("colours are normalised; accent_light and primary_hover follow when not given", {
  b <- kit_brand("X", colors = c(accent = "#9CC0FF", primary = "navy"))
  expect_equal(b$colors[["accent"]], "#9cc0ff")
  expect_equal(b$colors[["primary"]], "#000080")
  expect_false(b$colors[["accent_light"]] == "#e8f0a0")
  expect_false(b$colors[["primary_hover"]] == "#004d27")
  b2 <- kit_brand("X", colors = list(accent = "#9cc0ff", accent_light = "#dbe7ff"))
  expect_equal(b2$colors[["accent_light"]], "#dbe7ff")
  expect_equal(b2$colors[["primary_hover"]], "#004d27")
})

test_that("a custom brand changes the logo, favicon, CSS variables and alt text", {
  b <- blue()
  expect_equal(b$logo_alt, "示範實驗室 標誌")
  hdr <- kit_header("示範工具", brand = b)
  out <- html(hdr)
  expect_match(out, "<img src=\"kitDesign-brand-[0-9a-f]+-[0-9.]+/logo.svg\" alt=\"示範實驗室 標誌\"")
  expect_false(grepl("kit-logo.svg", out, fixed = TRUE))
  head <- as.character(htmltools::renderTags(hdr)$head)
  expect_match(head, "rel=\"icon\" type=\"image/svg\\+xml\" href=\"kitDesign-brand-[0-9a-f]+-[0-9.]+/mark.svg\"")
  expect_false(grepl("alternate icon", head, fixed = TRUE))
  expect_match(head, "html:root { --nb-page: #f5f7fa; --nb-lime: #9cc0ff;", fixed = TRUE)
  expect_match(head, "--nb-green: #1f4fa3;", fixed = TRUE)
  expect_false(grepl("--nb-ink", head, fixed = TRUE))
  # Shiny：一個只有這兩個檔的 dependency，不是 KIT 的標誌
  deps <- htmltools::findDependencies(hdr)
  names <- vapply(deps, `[[`, "", "name")
  expect_false("kitDesign-logo" %in% names)
  dep <- deps[[grep("^kitDesign-brand-", names)]]
  expect_setequal(list.files(dep$src$file), c("logo.svg", "mark.svg"))
  expect_equal(readLines(file.path(dep$src$file, "logo.svg"), warn = FALSE),
               readLines(file.path(demo_dir(), "demo-logo.svg"), warn = FALSE))
  # 自己指定的替代文字
  expect_match(html(kit_header("X", brand = blue(logo_alt = ""))), "alt=\"\"", fixed = TRUE)
})

test_that("a custom logo can be inline (data URI) with no dependency", {
  b <- blue()
  h <- kit_header("示範工具", logo = "inline", brand = b)
  expect_match(html(h), "src=\"data:image/svg\\+xml;base64,")
  expect_match(as.character(htmltools::renderTags(h)$head), "href=\"data:image/svg\\+xml;base64,")
  expect_length(htmltools::findDependencies(h), 0)
  expect_false(grepl("kitDesign-brand-", html(h), fixed = TRUE))
})

test_that("a PNG logo works in Shiny and inline; mark defaults to the logo", {
  png <- tiny_png()
  b <- kit_brand("PNG 研究室", logo = png)
  out <- html(kit_header("X", brand = b))
  expect_match(out, "src=\"kitDesign-brand-[0-9a-f]+-[0-9.]+/logo.png\"")
  head <- as.character(htmltools::renderTags(kit_header("X", brand = b))$head)
  expect_match(head, "rel=\"icon\" type=\"image/png\" href=\"kitDesign-brand-[0-9a-f]+-[0-9.]+/mark.png\"")
  dep <- Filter(function(d) grepl("^kitDesign-brand-", d$name),
                htmltools::findDependencies(kit_header("X", brand = b)))[[1]]
  expect_setequal(list.files(dep$src$file), c("logo.png", "mark.png"))
  inline <- html(kit_header("X", logo = "inline", brand = b))
  expect_match(inline, "src=\"data:image/png;base64,iVBORw0KGgo")
  # 讀進來以後，原來的檔案不見了也沒關係
  unlink(png)
  expect_match(html(kit_header("X", logo = "inline", brand = b)), "data:image/png;base64,")
  # 兩個不同的檔案：dependency 的名稱不同
  other <- kit_brand("Y", logo = file.path(demo_dir(), "demo-mark.svg"))
  expect_false(identical(kitDesign:::kit_brand_dependency(b)$name,
                         kitDesign:::kit_brand_dependency(other)$name))
})

test_that("brands without a logo, and logo = FALSE", {
  none <- kit_brand("無標誌研究室")
  hdr <- kit_header("X", brand = none)
  expect_false(grepl("kit-header-logo", html(hdr), fixed = TRUE))
  expect_false(grepl("rel=\"icon\"", as.character(htmltools::renderTags(hdr)$head), fixed = TRUE))
  expect_length(htmltools::findDependencies(hdr), 0)
  expect_false(grepl("kit-header-logo", html(kit_header("X", logo = FALSE, brand = blue())),
                     fixed = TRUE))
  # KIT 的顏色、只換分頁圖示
  b <- kit_brand(mark = file.path(demo_dir(), "demo-mark.svg"))
  out <- htmltools::renderTags(kit_header("X", brand = b))
  expect_match(out$html, "kitDesign-logo-[0-9.]+/kit-logo.svg")
  expect_match(out$head, "kitDesign-brand-[0-9a-f]+-[0-9.]+/mark.svg")
  expect_null(kitDesign:::kit_brand_css(b))
})

test_that("kit_theme(), kit_page() and kit_colors() take the brand's colours", {
  b <- blue()
  vars <- bslib::bs_get_variables(kit_theme(b), c("primary", "body-bg", "link-color",
                                                  "link-hover-color", "border-color"))
  expect_equal(tolower(unname(vars[["primary"]])), "#1f4fa3")
  expect_equal(tolower(unname(vars[["body-bg"]])), "#f5f7fa")
  expect_equal(tolower(unname(vars[["link-color"]])), "#1f4fa3")
  expect_equal(tolower(unname(vars[["link-hover-color"]])), b$colors[["primary_hover"]])
  expect_equal(tolower(unname(vars[["border-color"]])), "#141414")
  page <- kit_page("示範工具", brand = b)
  expect_equal(tolower(unname(bslib::bs_get_variables(attr(page, "bs_theme"), "primary"))), "#1f4fa3")
  expect_match(html(page), "kitDesign-brand-", fixed = TRUE)
  cols <- kit_colors(b)
  expect_equal(cols$primary, "#1f4fa3")
  expect_equal(cols$accent, "#9cc0ff")
  expect_equal(cols$subtitle, b$colors[["accent_light"]])
  expect_setequal(names(cols), names(kit_colors()))
  expect_equal(kit_colors()$primary_light, "#3a8f45")
})

test_that("options(kitDesign.brand = ) sets the brand for every function", {
  old <- options(kitDesign.brand = blue())
  on.exit(options(old), add = TRUE)
  expect_equal(kit_current_brand()$name, "示範實驗室")
  expect_match(html(kit_page("示範工具")), "alt=\"示範實驗室 標誌\"", fixed = TRUE)
  expect_equal(kit_colors()$primary, "#1f4fa3")
  expect_equal(kit_chart_sequential()[[6]][[2]], "#1F4FA3")
  options(old)
  expect_equal(kit_current_brand()$name, "KIT")
})

test_that("kit_chart_sequential() follows the brand; KIT keeps its values", {
  kit <- kit_chart_sequential(kit_brand())
  expect_identical(kit, kitDesign:::KIT_CHART_SEQUENTIAL)
  # 同一個算法（Lab 內插）算得出 KIT 的中間值
  ramp <- grDevices::colorRamp(c("#e8f0a0", "#006835"), space = "Lab")
  expect_equal(grDevices::rgb(ramp(c(0.25, 0.5, 0.75)), maxColorValue = 255),
               vapply(kit[3:5], `[[`, "", 2))
  s <- kit_chart_sequential(blue())
  expect_length(s, 6)
  expect_equal(vapply(s, `[[`, 0, 1), c(0, 0.2, 0.4, 0.6, 0.8, 1))
  expect_equal(s[[6]][[2]], "#1F4FA3")
  expect_equal(s[[2]][[2]], toupper(blue()$colors[["accent_light"]]))
  expect_false(s[[1]][[2]] %in% c("#FFFFFF", s[[2]][[2]]))
})

test_that("kit_plotly_style() uses the brand's sequential scale for heatmaps", {
  skip_if_not_installed("plotly")
  p <- plotly::plot_ly(z = matrix(1:4, 2), type = "heatmap")
  expect_equal(kit_plotly_style(p)$x$data[[1]]$colorscale, kit_chart_sequential(kit_brand()))
  expect_equal(kit_plotly_style(p, brand = blue())$x$data[[1]]$colorscale,
               kit_chart_sequential(blue()))
})

test_that("kit_gallery(brand = \"demo\") has a demo brand with its own files", {
  b <- kitDesign:::kit_brand_demo()
  expect_s3_class(b, "kit_brand")
  expect_false(isTRUE(b$files$logo$builtin))
  expect_equal(b$files$icons[[1]]$type, "image/svg+xml")
  expect_error(kit_gallery(brand = "nope"), "kit_brand()", fixed = TRUE)
})
