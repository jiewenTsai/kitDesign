test_that("kit_theme() is Bootswatch Brite with the KIT colours and fonts", {
  theme <- kit_theme()
  expect_true(bslib::is_bs_theme(theme))
  expect_equal(bslib::theme_bootswatch(theme), "brite")
  expect_equal(bslib::theme_version(theme), "5")
  vars <- bslib::bs_get_variables(theme, c("primary", "body-bg", "border-width", "link-color"))
  expect_equal(unname(vars[["primary"]]), "#006835")
  expect_equal(unname(vars[["body-bg"]]), "#faf7f0")
  expect_equal(unname(vars[["border-width"]]), "2px")
  expect_equal(unname(vars[["link-color"]]), "#006835")
})

test_that("use_kit() serves the three style sheets and the script from inst/www", {
  dep <- use_kit()
  expect_s3_class(dep, "html_dependency")
  expect_equal(dep$name, "kitDesign")
  expect_equal(dep$stylesheet, c("kit-base.css", "kit-brite.css", "kit-design.css"))
  expect_equal(dep$script, "kit.js")
  dir <- system.file("www", package = "kitDesign")
  expect_true(all(file.exists(file.path(dir, c(dep$stylesheet, dep$script)))))
  brite <- readLines(file.path(dir, "kit-brite.css"), encoding = "UTF-8")
  expect_true(any(grepl("--nb-lime: #c6d033", brite, fixed = TRUE)))
  base <- paste(readLines(file.path(dir, "kit-base.css"), encoding = "UTF-8"), collapse = "\n")
  expect_match(base, "看步驟 ▸", fixed = TRUE)
  expect_match(base, ".kit-header {", fixed = TRUE)
  design <- paste(readLines(file.path(dir, "kit-design.css"), encoding = "UTF-8"), collapse = "\n")
  expect_match(design, ".kit-details > .kit-detail { min-width: 0; max-width: 100%; }", fixed = TRUE)
  js <- paste(readLines(file.path(dir, "kit.js"), encoding = "UTF-8"), collapse = "\n")
  for (h in c("kit-tab-states", "kit-scroll", "kit-open-details", "kit-unload-guard")) {
    expect_match(js, paste0("'", h, "'"), fixed = TRUE)
  }
})

test_that("kit_page() wraps page_fluid with the theme, the dependency and the header", {
  page <- kit_page("KIT 測試工具", "臺灣幼兒發展調查資料庫", shiny::p("內容"),
                   version = "1.2.3", date = "2026-10-31")
  out <- html(page)
  expect_match(out, "kit-header mb-4", fixed = TRUE)
  expect_match(out, "<h1>KIT 測試工具</h1>", fixed = TRUE)
  expect_match(out, "v1.2.3 · 2026-10-31", fixed = TRUE)
  expect_match(out, "內容", fixed = TRUE)
  deps <- vapply(htmltools::findDependencies(page), `[[`, "", "name")
  expect_true("kitDesign" %in% deps)
  expect_true("bootstrap" %in% deps)
  expect_equal(attr(page, "lang"), "zh-Hant-TW")
  expect_true(bslib::is_bs_theme(attr(page, "bs_theme")))
})

test_that("kit_header() has the logo, subtitle, tagline and version line", {
  out <- html(kit_header("KIT 資料串接工具", "臺灣幼兒發展調查資料庫", tagline = "跨波次資料處理",
                         version = "0.5.0", date = "2026-10-31"))
  expect_match(out, "class=\"kit-header mb-4\"", fixed = TRUE)
  expect_match(out, "class=\"kit-header-row\"", fixed = TRUE)
  expect_match(out, "class=\"kit-header-logo\"", fixed = TRUE)
  ver <- as.character(utils::packageVersion("kitDesign"))
  expect_match(out, paste0("<img src=\"kitDesign-logo-", ver, "/kit-logo.svg\" alt=\"KIT 標誌\""), fixed = TRUE)
  expect_false(grepl("<img src=\"data:", out, fixed = TRUE))
  expect_match(out, "<span class=\"kit-subtitle\">臺灣幼兒發展調查資料庫</span>\\s*·\\s*跨波次資料處理")
  expect_match(out, "<div class=\"kit-app-meta\">v0.5.0 · 2026-10-31</div>", fixed = TRUE)
  no_logo <- html(kit_header("KIT", logo = FALSE))
  expect_false(grepl("kit-header-logo", no_logo, fixed = TRUE))
  expect_false(grepl("kit-app-meta", no_logo, fixed = TRUE))
})

test_that("kit_app_meta() joins version, date and extra parts", {
  expect_match(html(kit_app_meta("0.4.0", "2026-10-31", "kits 0.25.0")),
               "v0.4.0 · 2026-10-31 · kits 0.25.0", fixed = TRUE)
  expect_match(html(kit_app_meta(NA, "2026-10-31")), ">2026-10-31<", fixed = TRUE)
  expect_null(kit_app_meta())
})

test_that("kit_app_description() reads a package or a DESCRIPTION file", {
  own <- kit_app_description("kitDesign")
  expect_equal(own$version, as.character(utils::packageVersion("kitDesign")))
  expect_equal(own$date, "2026-10-31")
  tmp <- tempfile()
  writeLines(c("Package: kitDemo", "Version: 9.8.7", "Date: 2026-01-02"), tmp)
  expect_equal(kit_app_description(path = tmp), list(version = "9.8.7", date = "2026-01-02"))
  expect_equal(kit_app_description(path = tempfile()), list(version = NA_character_, date = NA_character_))
  # 工作目錄的 DESCRIPTION：只認 Package 對的那一份
  dir <- tempfile()
  dir.create(dir)
  file.copy(tmp, file.path(dir, "DESCRIPTION"))
  old <- setwd(dir)
  on.exit(setwd(old), add = TRUE)
  expect_equal(kit_app_description("kitDemo")$version, "9.8.7")
  expect_true(is.na(kit_app_description("noSuchPkgXyz")$version))
})

test_that("kit_logo_uri() returns a PNG data URI; base64 matches the standard", {
  uri <- kit_logo_uri(64)
  expect_match(uri, "^data:image/png;base64,iVBORw0KGgo")
  expect_match(kit_logo_uri(192, "logo"), "^data:image/png;base64,")
  expect_equal(kit_logo_uri(13), "")
  expect_error(kit_logo_uri(64, "other"))
  expect_equal(kitDesign:::kit_base64(charToRaw("Man")), "TWFu")
  expect_equal(kitDesign:::kit_base64(charToRaw("Ma")), "TWE=")
  expect_equal(kitDesign:::kit_base64(charToRaw("M")), "TQ==")
  expect_equal(kitDesign:::kit_base64(as.raw(0:255)),
               "AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn+AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t/g4eLj5OXm5+jp6uvs7e7v8PHy8/T19vf4+fr7/P3+/w==")
})

test_that("kit_colors() keeps the KIT brand colours", {
  cols <- kit_colors()
  expect_equal(cols$primary, "#006835")
  expect_equal(cols$accent, "#c6d033")
  expect_setequal(names(cols), c("primary", "primary_light", "accent", "subtitle", "body_bg",
                                 "text_muted", "border", "info", "danger"))
})

test_that("kit_gallery() finds a gallery app that builds", {
  dir <- system.file("examples", "gallery", package = "kitDesign")
  expect_true(file.exists(file.path(dir, "app.R")))
  env <- new.env()
  app <- source(file.path(dir, "app.R"), local = env, encoding = "UTF-8")$value
  expect_s3_class(app, "shiny.appobj")
  out <- html(env$ui)
  expect_match(out, "kit-navgroups", fixed = TRUE)
  expect_match(out, "kit-flow-tabs", fixed = TRUE)
  expect_match(out, "kit-checklist", fixed = TRUE)
  expect_true(is.function(kit_gallery))
})

test_that("kit_versions() and the header can show the kitDesign version", {
  v <- kit_versions()
  expect_equal(names(v), "kitDesign")
  expect_equal(unname(v), as.character(utils::packageVersion("kitDesign")))
  v2 <- kit_versions("kitDesign")
  expect_length(v2, 1)
  tmp <- tempfile()
  dir.create(tmp)
  writeLines(c("Package: kitFake", "Version: 0.5.0", "Date: 2026-10-31"), file.path(tmp, "DESCRIPTION"))
  old <- setwd(tmp)
  on.exit(setwd(old), add = TRUE)
  expect_equal(kit_versions("kitFake")[["kitFake"]], "0.5.0")
  meta <- html(kit_app_meta("0.5.0", "2026-10-31", show_kitdesign = TRUE))
  expect_match(meta, paste0("v0.5.0 · 2026-10-31 · kitDesign ", v[["kitDesign"]]), fixed = TRUE)
  expect_match(html(kit_page("KIT", NULL, version = "1.0.0", show_kitdesign = TRUE)),
               "v1.0.0 · kitDesign ", fixed = TRUE)
  expect_false(grepl("· kitDesign", html(kit_header("KIT", version = "1.0.0")), fixed = TRUE))
})

test_that("the header serves the SVG logo and favicon through a dependency", {
  hdr <- kit_header("KIT")
  deps <- htmltools::findDependencies(hdr)
  logo_dep <- Filter(function(d) d$name == "kitDesign-logo", deps)
  expect_length(logo_dep, 1)
  dir <- system.file("logo", package = "kitDesign")
  expect_true(all(file.exists(file.path(dir, c("kit-logo.svg", "kit-mark.svg", "kit-mark-64.png",
                                               "kit-logo-h512.png", "kit-mark-h1024.png")))))
  head <- as.character(htmltools::renderTags(hdr)$head)
  ver <- as.character(utils::packageVersion("kitDesign"))
  expect_match(head, paste0("rel=\"icon\" type=\"image/svg+xml\" href=\"kitDesign-logo-", ver,
                            "/kit-mark.svg\""), fixed = TRUE)
  expect_match(head, "type=\"image/png\" href=\"kitDesign-logo-", fixed = TRUE)
  expect_equal(kit_logo_file("kit-mark.svg"), paste0("kitDesign-logo-", ver, "/kit-mark.svg"))
  expect_error(kit_logo_file("nope.svg"), "No such logo file")
  expect_equal(kit_logo_dependency()$name, "kitDesign-logo")
  expect_true(kit_logo_dependency()$all_files)
  svg <- readLines(file.path(dir, "kit-logo.svg"), n = 1, warn = FALSE)
  expect_match(svg, "^<svg ")
  expect_match(kit_logo_uri("h512", "logo"), "^data:image/png;base64,")
})

test_that("kit_theme() stops with a clear message when bslib is older than 0.11.0", {
  real <- utils::packageVersion
  local_mocked_bindings(
    packageVersion = function(pkg, ...) {
      if (identical(pkg, "bslib")) package_version("0.10.0") else real(pkg, ...)
    },
    .package = "utils"
  )
  expect_error(kit_theme(), "bslib 版本太舊（0.10.0），這個 app 需要 0.11.0 以上。", fixed = TRUE)
  expect_error(kit_theme(), "install.packages(\"bslib\")", fixed = TRUE)
})

test_that("kitDesign itself requires bslib 0.11.0 or later", {
  imports <- utils::packageDescription("kitDesign")$Imports
  expect_match(imports, "bslib (>= 0.11.0)", fixed = TRUE)
})

test_that("kit_app_description(): a local DESCRIPTION wins over an installed copy that isn't loaded", {
  # 雲端版、run.bat 用 runApp(資料夾)：套件沒有載入，電腦上可能另外裝了舊版
  skip_if_not_installed("MASS")
  skip_if("MASS" %in% loadedNamespaces())
  dir <- tempfile()
  dir.create(dir)
  writeLines(c("Package: MASS", "Version: 0.0.1", "Date: 2026-10-31"), file.path(dir, "DESCRIPTION"))
  old <- setwd(dir)
  on.exit(setwd(old), add = TRUE)
  expect_equal(kit_app_description("MASS"), list(version = "0.0.1", date = "2026-10-31"))
  setwd(old)
  expect_false(identical(kit_app_description("MASS")$version, "0.0.1"))
})

test_that("kit_header(logo = \"inline\") writes the logo into the page, with no file dependency", {
  h <- kit_header("KIT 工具", logo = "inline")
  x <- as.character(h)
  expect_match(x, 'src="data:image/svg\\+xml;base64,')
  expect_match(as.character(htmltools::renderTags(h)$head), 'href="data:image/png;base64,')
  expect_length(htmltools::htmlDependencies(h), 0)
  expect_false(grepl("kitDesign-logo-", x))
  expect_length(htmltools::htmlDependencies(kit_header("KIT 工具")), 1)
})
