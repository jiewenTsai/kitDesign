# kit_plotly_style()、kit_plotly_fonts()、kit_chart_sequential()

ink <- "#141414"

# 兩張並排的小圖（像 Wright map）：xaxis、xaxis2、yaxis、yaxis2
two_panels <- function() {
  a <- plotly::plot_ly(x = 1:3, y = c(2, 1, 3), type = "scatter", mode = "lines", name = "M03")
  b <- plotly::plot_ly(x = 1:3, y = c(1, 3, 2), type = "scatter", mode = "markers", name = "M36")
  plotly::layout(plotly::subplot(a, b), title = "Wright map：能力值（左）與步驟門檻（右）")
}

test_that("every axis, including subplot axes, gets the KIT axis style", {
  skip_if_not_installed("plotly")
  out <- kit_plotly_style(two_panels())
  lay <- out$x$layout
  axes <- grep("^[xy]axis[0-9]*$", names(lay), value = TRUE)
  expect_setequal(axes, c("xaxis", "xaxis2", "yaxis", "yaxis2"))
  for (ax in axes) {
    a <- lay[[ax]]
    expect_true(a$showline, info = ax)
    expect_false(a$mirror, info = ax)
    expect_equal(a$linecolor, ink, info = ax)
    expect_true(a$linewidth >= 1 && a$linewidth <= 1.5, info = ax)
    expect_equal(a$gridcolor, "#e3ded2", info = ax)
    expect_equal(a$zerolinecolor, "#d9d4c5", info = ax)
    expect_equal(a$ticks, "outside", info = ax)
    expect_true(a$automargin, info = ax)
    expect_equal(a$tickfont$color, "#5a5a5a", info = ax)
    expect_equal(a$tickfont$family, "\"Chiron GoRound TC\", sans-serif", info = ax)
  }
  # 資料不動
  built <- plotly::plotly_build(two_panels())
  for (i in 1:2) {
    expect_identical(out$x$data[[i]]$x, built$x$data[[i]]$x)
    expect_identical(out$x$data[[i]]$y, built$x$data[[i]]$y)
  }
  expect_equal(as.vector(out$x$data[[1]]$y), c(2, 1, 3))
})

test_that("an axis used only by a trace is styled too", {
  skip_if_not_installed("plotly")
  p <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "lines")
  p <- plotly::add_lines(p, x = 1:3, y = 3:1, yaxis = "y2")
  lay <- kit_plotly_style(p)$x$layout
  expect_equal(lay$yaxis2$linecolor, ink)
})

test_that("font, background, title, hover label and margins follow the tokens", {
  skip_if_not_installed("plotly")
  lay <- kit_plotly_style(two_panels())$x$layout
  expect_equal(lay$font$family, "\"Chiron GoRound TC\", sans-serif")
  expect_equal(lay$font$color, ink)
  expect_equal(lay$font$size, 15)
  expect_equal(lay$paper_bgcolor, "#FFFFFF")
  expect_equal(lay$plot_bgcolor, "#FFFFFF")
  # 標題靠左、粗體、約 h5（18px）；文字不變
  expect_equal(lay$title$text, "<b>Wright map：能力值（左）與步驟門檻（右）</b>")
  expect_equal(lay$title$x, 0)
  expect_equal(lay$title$xanchor, "left")
  expect_equal(lay$title$font$size, 18)
  expect_equal(lay$hoverlabel$bgcolor, "#FFFFFF")
  expect_equal(lay$hoverlabel$bordercolor, ink)
  expect_equal(lay$hoverlabel$font$family, "\"Chiron GoRound TC\", sans-serif")
  expect_equal(lay$margin[c("l", "r", "b")], list(l = 12, r = 12, b = 12))
  expect_gt(lay$margin$t, 18)
})

test_that("a kits subtitle stays on its own line and only the first line is bold", {
  skip_if_not_installed("plotly")
  p <- plotly::layout(plotly::plot_ly(x = 1:2, y = 1:2, type = "scatter", mode = "lines"),
                      title = "Vertical scale<br><sup>actual median age: 3, 6</sup>")
  lay <- kit_plotly_style(p)$x$layout
  expect_equal(lay$title$text, "<b>Vertical scale</b><br><sup>actual median age: 3, 6</sup>")
  one <- kit_plotly_style(plotly::layout(p, title = "Vertical scale"))$x$layout
  expect_gt(lay$margin$t, one$margin$t)
})

test_that("explicit trace colours are kept; plotly's default colours become Okabe-Ito", {
  skip_if_not_installed("plotly")
  p <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "lines+markers", name = "role",
                       line = list(color = "#D55E00"), marker = list(color = "#7F7F7F"))
  p <- plotly::add_trace(p, x = 1:3, y = 3:1, type = "scatter", mode = "markers", name = "plain",
                         inherit = FALSE)
  before <- plotly::plotly_build(p)$x$data
  expect_true(inherits(before[[2]]$marker$color, "colorway"))
  out <- kit_plotly_style(p)
  tr <- out$x$data
  expect_equal(as.character(tr[[1]]$line$color), "#D55E00")
  expect_equal(as.character(tr[[1]]$marker$color), "#7F7F7F")
  # plotly 的第 2 個預設色（橘 #FF7F0E）-> Okabe-Ito 的第 2 個（#E69F00）
  expect_equal(as.character(before[[2]]$marker$color), "rgba(255,127,14,1)")
  expect_equal(as.character(tr[[2]]$marker$color), "rgba(230,159,0,1)")
  expect_equal(out$x$layout$colorway, unname(kit_chart_colors()))
})

test_that("kitsUI-style recolouring survives whichever order it runs in", {
  skip_if_not_installed("plotly")
  recolour <- function(p) {
    p <- plotly::plotly_build(p)
    p$x$data[[1]]$line$color <- "#0072B2"
    p$x$data[[2]]$marker$color <- "#E69F00"
    p
  }
  p <- two_panels()
  a <- kit_plotly_style(recolour(p))
  b <- recolour(kit_plotly_style(p))
  expect_equal(a$x$data[[1]]$line$color, "#0072B2")
  expect_equal(a$x$data[[2]]$marker$color, "#E69F00")
  expect_equal(b$x$data[[1]]$line$color, "#0072B2")
  expect_equal(b$x$layout$xaxis, a$x$layout$xaxis)
})

test_that("heatmap colour scales become the KIT scale only when colorscale = TRUE", {
  skip_if_not_installed("plotly")
  kits_scale <- list(c(0, "#F7FBFF"), c(1, "#0072B2"))
  heat <- plotly::plot_ly(z = matrix(c(0, 0.5, 1, 0.2), 2), type = "heatmap",
                          colorscale = kits_scale, colorbar = list(title = "Pass"))
  dots <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "markers",
                          marker = list(color = 1:3, colorscale = "Viridis", showscale = TRUE))
  on <- kit_plotly_style(heat)$x$data[[1]]
  expect_equal(on$colorscale, kit_chart_sequential())
  expect_false(on$autocolorscale)
  expect_equal(on$colorbar$title$text, "Pass")
  expect_equal(on$colorbar$title$font$family, "\"Chiron GoRound TC\", sans-serif")
  expect_equal(on$colorbar$tickfont$color, "#5a5a5a")
  expect_equal(on$colorbar$outlinecolor, ink)
  off <- kit_plotly_style(heat, colorscale = FALSE)$x$data[[1]]
  expect_equal(off$colorscale, plotly::plotly_build(heat)$x$data[[1]]$colorscale)
  expect_equal(off$colorbar$tickfont$color, "#5a5a5a")
  # 不是熱圖：色階不動，色條的字照樣換
  sc <- kit_plotly_style(dots)$x$data[[1]]
  expect_equal(sc$marker$colorscale, "Viridis")
  expect_equal(sc$marker$colorbar$tickfont$color, "#5a5a5a")
})

test_that("kit_chart_sequential() runs from white through bg-new to nb-green", {
  s <- kit_chart_sequential()
  expect_equal(s[[1]], list(0, "#FFFFFF"))
  expect_equal(s[[2]], list(0.2, "#E8F0A0"))
  expect_equal(s[[length(s)]], list(1, "#006835"))
  pos <- vapply(s, function(x) x[[1]], numeric(1))
  expect_false(is.unsorted(pos))
})

test_that("config: no logo, a short modebar, PNG on white, zh-TW", {
  skip_if_not_installed("plotly")
  out <- kit_plotly_style(two_panels(), filename = "wright")
  cfg <- out$x$config
  expect_false(cfg$displaylogo)
  expect_equal(cfg$modeBarButtons, list(list("toImage", "zoomIn2d", "zoomOut2d", "resetScale2d")))
  expect_null(cfg$modeBarButtonsToAdd)
  expect_equal(cfg$toImageButtonOptions, list(format = "png", filename = "wright", scale = 2))
  expect_equal(cfg$locale, "zh-TW")
  deps <- vapply(out$dependencies, function(d) d$name, "")
  expect_true("plotly-locale-zh-TW" %in% deps)
  # PNG 的底色就是 paper_bgcolor
  expect_equal(out$x$layout$paper_bgcolor, "#FFFFFF")
  # 沒有 x、y 軸的圖：只留下載
  pie <- kit_plotly_style(plotly::plot_ly(labels = c("a", "b"), values = 1:2, type = "pie"))
  expect_equal(pie$x$config$modeBarButtons, list(list("toImage")))
})

test_that("legend: the rule, the opt-out, and the browser-side data", {
  skip_if_not_installed("plotly")
  few <- kit_plotly_style(two_panels())
  expect_equal(few$x$layout$legend$orientation, "v")
  expect_equal(few$x$layout$legend$font$family, "\"Chiron GoRound TC\", sans-serif")
  many <- plotly::plot_ly()
  for (w in c(3, 6, 12, 36, 48)) {
    many <- plotly::add_lines(many, x = 1:3, y = runif(3), name = as.character(w))
  }
  lay <- kit_plotly_style(many)$x$layout
  expect_equal(lay$legend$orientation, "h")
  expect_equal(lay$legend$yref, "container")
  long <- plotly::add_lines(plotly::add_lines(plotly::plot_ly(), x = 1:2, y = 1:2,
    name = "最後的線（留下的點）：1.03 + 0.93 x"), x = 1:2, y = 2:1, name = "留下")
  expect_equal(kit_plotly_style(long)$x$layout$legend$orientation, "h")
  expect_equal(kit_plotly_style(many, legend = "right")$x$layout$legend$orientation, "v")
  expect_equal(kit_plotly_style(two_panels(), legend = "bottom")$x$layout$legend$orientation, "h")
  # keep：位置不動（kits 自己放的位置），字型照換
  kits_leg <- plotly::layout(many, legend = list(orientation = "h", y = -0.22, x = 0.1))
  kept <- kit_plotly_style(kits_leg, legend = "keep")$x$layout$legend
  expect_equal(kept$y, -0.22)
  expect_equal(kept$x, 0.1)
  expect_equal(kept$font$color, ink)
  # 瀏覽器端：圖寬小於 600px 時放到下面（只在 "auto"）
  hook <- function(p) p$jsHooks$render[[1]]$data
  expect_true(hook(kit_plotly_style(two_panels()))$legend)
  expect_false(hook(kit_plotly_style(two_panels()))$bottom)
  expect_equal(hook(kit_plotly_style(two_panels()))$narrow, 600)
  expect_false(hook(kit_plotly_style(two_panels(), legend = "keep"))$legend)
})

test_that("kits' panel frames go away on single plots and turn soft on small multiples", {
  skip_if_not_installed("plotly")
  box <- function(i) list(type = "rect", x0 = 0, x1 = 1, y0 = 0, y1 = 1,
                          xref = paste0("x", i, " domain"), yref = paste0("y", i, " domain"),
                          line = list(color = "#000000", width = 1), fillcolor = "rgba(0,0,0,0)")
  band <- list(type = "rect", x0 = 0, x1 = 1, y0 = 0.6, y1 = 1.4, xref = "paper", yref = "y",
               fillcolor = "rgba(127,127,127,0.15)", line = list(width = 0))
  one <- plotly::layout(plotly::plot_ly(x = 1:2, y = 1:2, type = "scatter", mode = "lines"),
                        shapes = list(band, box("")))
  shapes <- kit_plotly_style(one)$x$layout$shapes
  expect_length(shapes, 1)
  expect_equal(shapes[[1]]$y0, 0.6)
  multi <- plotly::plotly_build(two_panels())
  multi$x$layout$shapes <- list(box(""), box("2"))
  shapes <- kit_plotly_style(multi)$x$layout$shapes
  expect_length(shapes, 2)
  expect_equal(shapes[[1]]$line$color, "#d9d4c5")
})

test_that("styling twice is the same as styling once", {
  skip_if_not_installed("plotly")
  once <- kit_plotly_style(two_panels())
  twice <- kit_plotly_style(once)
  expect_equal(twice$x$layout, once$x$layout)
  expect_equal(twice$x$data, once$x$data)
  expect_length(twice$jsHooks$render, 1)
  deps <- vapply(twice$dependencies, function(d) d$name, "")
  expect_equal(sum(deps == "kit-plotly-fonts"), 1)
  expect_equal(sum(deps == "plotly-locale-zh-TW"), 1)
})

test_that("kit_plotly_fonts() links the app font without embedding it", {
  skip_if_not_installed("plotly")
  p <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "lines")
  out <- kit_plotly_fonts(p)
  dep <- Filter(function(d) d$name == "kit-plotly-fonts", out$dependencies)
  expect_length(dep, 1)
  head <- dep[[1]]$head
  expect_match(head, "family=Chiron+GoRound+TC", fixed = TRUE)
  expect_match(head, "rel=\"stylesheet\"[^>]*data-external=\"1\"")
  expect_identical(kit_plotly_fonts(out)$dependencies, out$dependencies)
  expect_false("kit-plotly-fonts" %in%
                 vapply(kit_plotly_style(p, fonts = FALSE)$dependencies, function(d) d$name, ""))
  expect_error(kit_plotly_fonts(list()), "htmlwidget")
})

test_that("a clear message when plotly is missing or p is not a plotly figure", {
  local_mocked_bindings(kit_has_pkg = function(pkg) FALSE)
  expect_error(kit_plotly_style(NULL), "kit_plotly_style\\(\\) .*plotly")
  expect_error(kit_plotly_style(NULL), "install.packages(\"plotly\")", fixed = TRUE)
})

test_that("p must be a plotly figure", {
  skip_if_not_installed("plotly")
  expect_error(kit_plotly_style(data.frame(x = 1)), "plotly")
})

test_that("the danger button rule comes after the small-button rules (salmon wins)", {
  css <- readLines(system.file("www", "kit-brite.css", package = "kitDesign"), encoding = "UTF-8")
  small <- grep("^\\.btn-sm,$", css)
  small_hover <- grep("^\\.btn-sm:hover,$", css)
  danger <- grep("^\\.btn-sm\\.btn-danger:not\\(:disabled\\):not\\(\\.disabled\\),$", css)
  expect_length(danger, 1)
  expect_gt(danger, max(small, small_hover))
  block <- css[danger:(danger + 8)]
  expect_true(any(grepl("background: var(--nb-salmon);", block, fixed = TRUE)))
  expect_true(any(grepl("color: var(--nb-ink);", block, fixed = TRUE)))
  expect_true(any(grepl(":hover", block, fixed = TRUE)))
})
