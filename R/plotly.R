# 圖（Chart）：plotly 圖套上 KIT 的樣子
#
# kits 畫好的 plotly 圖（kitsUI 再換色、換中文）最後交給 kit_plotly_style()：字型、軸線、格線、
# 底色、標題、圖例、色條、滑過的說明框、工具列都換成 KIT 的樣子。只改樣子，不改資料。
# plotly 是 Suggests：沒有裝 plotly 的 app 不受影響。

# 設計變數（brand/KIT設計語言.md 的附錄）
KIT_PLOTLY_FONT <- "\"Chiron GoRound TC\", sans-serif"
KIT_PLOTLY_INK <- "#141414"
KIT_PLOTLY_HINT <- "#5a5a5a"
KIT_PLOTLY_LINE <- "#d9d4c5"
KIT_PLOTLY_LINE_SOFT <- "#e3ded2"
KIT_PLOTLY_CARD <- "#FFFFFF"

# 圖例：超過 4 項，或最長的一項超過 20 欄（中文字算 2 欄），放在圖的下面、橫排；
# 圖的寬度小於 600px 時也放到下面（瀏覽器端判斷，視窗變寬時回到右邊）
KIT_LEGEND_MAX_ITEMS <- 4
KIT_LEGEND_MAX_WIDTH <- 20
KIT_PLOTLY_NARROW <- 600

# 標題離卡片的邊（px）
KIT_TITLE_PAD <- 14

# plotly（R）沒有指定顏色時依序給的預設色（d3 category10）；換成 Okabe–Ito 的同一個位置
KIT_PLOTLY_DEFAULT_COLORS <- c(
  "#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9467BD",
  "#8C564B", "#E377C2", "#7F7F7F", "#BCBD22", "#17BECF"
)

# 連續數值的色階（KIT）：極淡萊姆 -> 淡萊姆（bg-new）-> KIT 綠（nb-green），中間在 Lab 空間內插。
# 0 不是白色：沒有施測的空格（NA）是白底，和「0%」分得開。
# 別的品牌由 kit_chart_sequential() 用同一個算法算出來（KIT 的淡端是手調的 #F3F7D3）
KIT_CHART_SEQUENTIAL <- list(
  list(0, "#F3F7D3"), list(0.2, "#E8F0A0"), list(0.4, "#B3CC83"),
  list(0.6, "#7FAA68"), list(0.8, "#4B884D"), list(1, "#006835")
)

# 用色階的 trace（z 是格子的值）
KIT_PLOTLY_HEAT <- c("heatmap", "heatmapgl", "contour", "histogram2d", "histogram2dcontour")

# 沒有 x、y 軸的 trace（工具列只留下載）
KIT_PLOTLY_NOT_XY <- c(
  "pie", "sunburst", "treemap", "icicle", "funnelarea", "sankey", "parcoords", "parcats", "table",
  "indicator", "scatter3d", "surface", "mesh3d", "cone", "streamtube", "volume", "isosurface",
  "scattergeo", "choropleth", "scattermapbox", "choroplethmapbox", "densitymapbox",
  "scatterpolar", "scatterpolargl", "barpolar", "scatterternary", "scattercarpet", "carpet"
)

#' Color scale for continuous values (chart)
#'
#' Very light lime → light lime (`bg-new`) → KIT green (`nb-green`): larger values are darker. For
#' heatmaps and color bars (e.g. pass rates in a response design plot). The minimum is not white,
#' so 0 looks different from an empty cell with no data (white background). [kit_plotly_style()]
#' switches heatmaps to this scale by default.
#'
#' The scale comes from the brand ([kit_brand()]): 0 is a very light color made by mixing
#' `accent_light` with white, 0.2 is `accent_light`, and 0.2 to 1 interpolates in Lab space from
#' `accent_light` to `primary`. For the KIT brand these are the values above. Categorical colors
#' ([kit_chart_colors()], Okabe–Ito) do not change with the brand: they are colorblind-friendly.
#'
#' @param brand The brand ([kit_brand()]); defaults to [kit_current_brand()] (KIT when none is set).
#' @return A plotly colorscale: `list(list(0, "#F3F7D3"), ..., list(1, "#006835"))`.
#' @seealso [kit_plotly_style()], [kit_chart_colors()]
#' @examples
#' kit_chart_sequential()
#' kit_chart_sequential(kit_brand("Demo", colors = list(accent = "#9cc0ff", primary = "#1f4fa3")))
#' @export
kit_chart_sequential <- function(brand = kit_current_brand()) {
  col <- kit_check_brand(brand)$colors
  light <- col[["accent_light"]]
  if (identical(light, KIT_BRAND_COLORS[["accent_light"]]) &&
      identical(col[["primary"]], KIT_BRAND_COLORS[["primary"]])) {
    return(KIT_CHART_SEQUENTIAL)
  }
  faint <- if (identical(light, KIT_BRAND_COLORS[["accent_light"]])) "#F3F7D3" else
    toupper(kit_mix(light, "#ffffff", 0.55))
  ramp <- grDevices::colorRamp(c(light, col[["primary"]]), space = "Lab")
  mid <- grDevices::rgb(ramp(c(0.25, 0.5, 0.75)), maxColorValue = 255)
  stops <- c(faint, toupper(light), mid, toupper(col[["primary"]]))
  lapply(seq_along(stops), function(i) list(c(0, 0.2, 0.4, 0.6, 0.8, 1)[i], stops[[i]]))
}

#' Give a plotly chart the KIT look (chart)
#'
#' Makes plotly charts look like part of the same app: typeface, text sizes, and colors all use
#' KIT's design variables. Only the look changes, not the data (points, lines, axis ranges, tick
#' positions, and hover text stay the same).
#'
#' What changes:
#'
#' - **Typeface**: everything uses the app's rounded typeface `"Chiron GoRound TC", sans-serif`;
#'   text is `nb-ink` (#141414), ticks are `text-hint` (#5a5a5a). Sizes: body `font_size` (default
#'   15px), legend and hover box 1px smaller, ticks 2px smaller, title about `h5` (1.2 times
#'   `font_size`).
#' - **Title**: left-aligned, bold. When the chart is too narrow, it wraps in the browser (breaking
#'   between Chinese characters or at spaces).
#' - **Every axis** (`xaxis`, `xaxis2`…, `yaxis`…, including side-by-side small charts such as a
#'   Wright map): axis line `nb-ink` 1.5px, grid lines `line-soft` (#e3ded2), zero line `line`
#'   (#d9d4c5), ticks outside; no frame on four sides (`mirror = FALSE`, and the black frame kits
#'   draws around each small chart is removed; KIT design language: no frames inside frames). When
#'   axis titles and ticks do not fit, the margins widen automatically (`automargin`).
#' - **Background**: white (the chart sits in a white card); downloaded PNGs and SVGs also have a
#'   white background.
#' - **Colors**: `colorway` is Okabe–Ito ([kit_chart_colors()]). plotly's own default colors are
#'   replaced with the Okabe–Ito color in the same position; **colors set by kits or kitsUI stay
#'   unchanged** (kitsUI's role colors and category recoloring are kept).
#' - **Color scale** (`colorscale = TRUE`): heatmap-type traces (heatmap, contour, histogram2d)
#'   switch to [kit_chart_sequential()] (very light lime → light lime → KIT green); the color bar's
#'   text and outline always get the new look.
#' - **Hover box**: white background, `nb-ink` border, the app's typeface.
#' - **Legend**: the app's typeface, no border. For position, see `legend`.
#' - **Toolbar**: no plotly logo; only "download PNG", "download SVG", zoom in, zoom out, and reset
#'   to the original range remain; interface text is Traditional Chinese (`zh-TW`). The PNG is
#'   always 2100 pixels wide (7 inches at 300 dpi; the aspect ratio is the one on screen) and the
#'   file says 300 dpi, so it is 7 inches wide when inserted in Word. The SVG is a vector image for
#'   journals that want 600 dpi or more, EPS or PDF; its text uses the fonts on the computer that
#'   opens it (the rounded typeface is a web font). Both are made in the browser, not by R, and
#'   also work in a downloaded HTML file.
#' - **Margins**: equally small on all sides; plotly widens them automatically when axes, legend,
#'   or color bar do not fit, so no text is cut off.
#'
#' What does not change: data, axis ranges and ticks, trace colors (other than plotly's default
#' colors), marker shapes, line widths and dashes, opacity, hover text, legend text, the text of
#' titles and axis titles (only bold is added), chart height and width, and `shapes` (other than
#' kits' small-chart frames; for example, the gray band in fit plots).
#'
#' **Order when used with kits and kitsUI**: kits' `plot()` → kitsUI recoloring
#' (`kit_chart_categorical()`, `kit_chart_role()`) → kitsUI Chinese labels (`kit_chart_zh()`) →
#' `kit_plotly_style()`. Recoloring and this function can be swapped (this function does not touch
#' set colors), but **Chinese labels must come first**: this function wraps the title in `<b>`,
#' after which `kit_chart_zh()` no longer recognizes the original English title.
#' Applying it twice to the same chart is the same as applying it once.
#'
#' @param p A plotly chart (`plotly::plot_ly()`, kits' `plot()`; one already passed through
#'   `plotly::plotly_build()` also works).
#' @param legend Where the legend goes:
#'   - `"auto"` (default): with more than 4 entries, or when the longest entry is wider than 20
#'     columns (a Chinese character counts as 2), the legend goes below the chart, horizontal,
#'     left-aligned; otherwise on the right. When the chart is narrower than 600px (phones) it also
#'     moves below, and returns to the right when the chart gets wider (decided in the browser).
#'   - `"bottom"`: always below; `"right"`: always on the right.
#'   - `"keep"`: leave the legend position alone (only change the font).
#' @param colorscale When `TRUE` (default), heatmap-type traces switch to [kit_chart_sequential()];
#'   when `FALSE`, the original color scale is kept.
#' @param fonts When `TRUE` (default), attaches the rounded typeface from Google Fonts
#'   ([kit_plotly_fonts()]), so a downloaded single HTML file also uses the app's typeface.
#' @param filename The file name (without extension) for the toolbar's "download PNG" and
#'   "download SVG".
#' @param font_size Body text size (px); the other sizes are derived from it.
#' @param brand The brand ([kit_brand()]): the heatmap color scale comes from it
#'   ([kit_chart_sequential()]). Defaults to [kit_current_brand()] (KIT when not set). Text, axis
#'   lines, and background keep the design language's ink and white.
#' @return A plotly chart (passed through `plotly_build()`).
#' @seealso [kit_plotly_fonts()], [kit_chart_colors()], [kit_chart_sequential()]
#' @examples
#' if (requireNamespace("plotly", quietly = TRUE)) {
#'   d <- data.frame(wave = rep(c(3, 6, 12), 2), score = c(8, 11, 15, 7, 10, 13),
#'                   cohort = rep(c("M03", "M36"), each = 3))
#'   p <- plotly::plot_ly(d, x = ~wave, y = ~score, split = ~cohort,
#'                        type = "scatter", mode = "lines+markers")
#'   p <- plotly::layout(p, title = "各世代的分數中位數")
#'   kit_plotly_style(p)
#' }
#' @export
kit_plotly_style <- function(p, legend = c("auto", "bottom", "right", "keep"),
                             colorscale = TRUE, fonts = TRUE, filename = "kit-chart",
                             font_size = 15, brand = kit_current_brand()) {
  kit_need_plotly("kit_plotly_style()")
  sequential <- kit_chart_sequential(brand)
  legend <- match.arg(legend)
  if (!inherits(p, "plotly")) {
    # 原文：p 要是 plotly 圖（例如 kits 的 plot() 或 plotly::plot_ly() 畫的圖）。
    stop("p \u8981\u662f plotly \u5716\uff08\u4f8b\u5982 kits \u7684 plot() \u6216 plotly::plot_ly() \u756b\u7684\u5716\uff09\u3002", call. = FALSE)
  }
  stopifnot(is.logical(colorscale), length(colorscale) == 1, !is.na(colorscale),
            is.numeric(font_size), length(font_size) == 1, font_size > 0)
  p <- plotly::plotly_build(p)
  size <- kit_plotly_sizes(font_size)
  lay <- p$x$layout

  # 字型、底色、類別色
  lay$font <- kit_plotly_font(size$body)
  lay$paper_bgcolor <- KIT_PLOTLY_CARD
  lay$plot_bgcolor <- KIT_PLOTLY_CARD
  lay$colorway <- unname(kit_chart_colors())

  # 每一條軸（layout 有的，加上 trace 用到的）
  axes <- union(grep("^[xy]axis[0-9]*$", names(lay), value = TRUE), kit_trace_axes(p$x$data))
  for (ax in axes) lay[[ax]] <- kit_axis_style(lay[[ax]], size)

  # kits 在每個小圖外面畫的黑框（四邊的框）：只有一張圖時拿掉；並排的小圖換成淡線（line），
  # 小圖之間還分得開。其他 shapes 不動
  if (length(lay$shapes) > 0) {
    boxes <- vapply(lay$shapes, kit_is_panel_box, logical(1))
    if (sum(boxes) <= 1) {
      lay$shapes <- lay$shapes[!boxes]
    } else {
      lay$shapes[boxes] <- lapply(lay$shapes[boxes], function(s) {
        s$line <- list(color = KIT_PLOTLY_LINE, width = 1)
        s$layer <- "below"
        s
      })
    }
  }
  # 小圖的標題（annotations）：app 的字型
  if (length(lay$annotations) > 0) {
    lay$annotations <- lapply(lay$annotations, kit_annotation_style, size = size)
  }

  # 滑過的說明框
  lay$hoverlabel <- utils::modifyList(lay$hoverlabel %||% list(), list(
    bgcolor = KIT_PLOTLY_CARD, bordercolor = KIT_PLOTLY_INK, align = "left",
    font = kit_plotly_font(size$small)
  ))

  # 圖例
  leg <- utils::modifyList(lay$legend %||% list(), list(
    font = kit_plotly_font(size$small), bgcolor = "rgba(255,255,255,0)", borderwidth = 0
  ))
  if (is.list(leg$title)) leg$title$font <- kit_plotly_font(size$small)
  info <- kit_legend_info(p$x$data)
  bottom <- switch(legend,
    auto = info$n > KIT_LEGEND_MAX_ITEMS || info$width > KIT_LEGEND_MAX_WIDTH,
    bottom = TRUE, right = FALSE, keep = NA
  )
  if (!is.na(bottom)) leg <- utils::modifyList(leg, if (bottom) KIT_LEGEND_BOTTOM else KIT_LEGEND_RIGHT)
  lay$legend <- leg

  # 標題：靠左、粗體；上邊界留給標題（與小圖的標題）
  title <- kit_title_parts(lay$title)
  band <- if (kit_has_top_annotations(lay$annotations)) size$small + 8 else 0
  top <- kit_title_top(title, size, band)
  if (is.null(title)) {
    lay$title <- NULL
  } else {
    lay$title <- list(
      text = kit_title_text(title$main, title$rest),
      x = 0, xanchor = "left", xref = "container",
      y = 1, yanchor = "top", yref = "container",
      pad = list(l = KIT_TITLE_PAD, r = KIT_TITLE_PAD, t = kit_title_pad(top, 1), b = 0),
      font = kit_plotly_font(size$title)
    )
  }
  lay$margin <- list(l = 12, r = 12, b = 12, t = top$fixed + top$line * top$lines, pad = 0)
  p$x$layout <- lay

  # trace：plotly 的預設色換成 Okabe–Ito；熱圖的色階；色條的樣子
  p$x$data <- lapply(p$x$data, function(tr) {
    tr <- kit_recolor_defaults(tr)
    heat <- isTRUE((tr$type %||% "") %in% KIT_PLOTLY_HEAT)
    if (heat && colorscale) {
      tr$colorscale <- sequential
      tr$autocolorscale <- FALSE
    }
    if (!is.null(tr$colorbar) || (heat && !isFALSE(tr$showscale))) {
      tr$colorbar <- kit_colorbar_style(tr$colorbar, size)
    }
    if (is.list(tr$marker) && (!is.null(tr$marker$colorbar) || isTRUE(tr$marker$showscale))) {
      tr$marker$colorbar <- kit_colorbar_style(tr$marker$colorbar, size)
    }
    tr
  })

  # 工具列
  p <- kit_plotly_config(p, xy = kit_all_xy(p$x$data), filename = filename)

  # 瀏覽器端：圖寬小於 600px 時圖例放到下面、標題換行
  p <- kit_plotly_responsive(p, list(
    narrow = KIT_PLOTLY_NARROW, base = list(l = 12, b = 12), gap = 16,
    legend = identical(legend, "auto"),
    bottom = isTRUE(bottom),
    legend_h = kit_relayout_keys("legend", KIT_LEGEND_BOTTOM),
    legend_v = kit_relayout_keys("legend", KIT_LEGEND_RIGHT),
    title = if (!is.null(title)) list(
      main = title$main, rest = title$rest, pad = KIT_TITLE_PAD,
      font = sprintf("bold %dpx %s", size$title, KIT_PLOTLY_FONT),
      fixed = top$fixed, line = top$line, rest_lines = top$rest_lines
    ) else FALSE
  ))
  if (fonts) p <- kit_plotly_fonts(p)
  p
}

#' Attach the app's typeface to a plotly chart (for downloaded HTML)
#'
#' Attaches an htmlDependency to a plotly chart that loads the rounded typeface Chiron GoRound TC
#' from Google Fonts (weights 400 and 700). Shiny pages already have this typeface ([kit_theme()]),
#' so this is mainly for single HTML files saved with `htmlwidgets::saveWidget()`: they also open
#' in the app's typeface; without a network connection they fall back to the system sans-serif.
#'
#' The `<link>` carries `data-external="1"`: when `saveWidget(selfcontained = TRUE)` bundles the
#' file with pandoc, the font files are not embedded in the HTML (a Chinese typeface is split into
#' hundreds of files, so embedding them would make the file very large).
#' [kit_plotly_style()] already calls it by default (`fonts = TRUE`); attaching it twice to the
#' same chart is the same as attaching it once.
#'
#' @param p A plotly chart (or another htmlwidget).
#' @return The same chart, with one more htmlDependency (`kit-plotly-fonts`).
#' @seealso [kit_plotly_style()]
#' @examples
#' if (requireNamespace("plotly", quietly = TRUE)) {
#'   p <- kit_plotly_fonts(plotly::plot_ly(x = 1:3, y = c(2, 4, 3), type = "scatter", mode = "lines"))
#'   vapply(p$dependencies, function(d) d$name, "")
#' }
#' @export
kit_plotly_fonts <- function(p) {
  if (!inherits(p, "htmlwidget")) {
    # 原文：p 要是 plotly 圖（或其他 htmlwidget）。
    stop("p \u8981\u662f plotly \u5716\uff08\u6216\u5176\u4ed6 htmlwidget\uff09\u3002", call. = FALSE)
  }
  names <- vapply(p$dependencies, function(d) d$name %||% "", character(1))
  if ("kit-plotly-fonts" %in% names) return(p)
  css <- paste0("https://fonts.googleapis.com/css2?family=Chiron+GoRound+TC:wght@400;700",
                "&amp;display=swap")
  dep <- htmltools::htmlDependency(
    name = "kit-plotly-fonts", version = kit_pkg_version(),
    src = c(href = "https://fonts.googleapis.com"),
    head = paste0(
      "<link rel=\"preconnect\" href=\"https://fonts.googleapis.com\" data-external=\"1\">\n",
      "<link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin data-external=\"1\">\n",
      "<link rel=\"stylesheet\" href=\"", css, "\" data-external=\"1\">"
    )
  )
  p$dependencies <- c(p$dependencies, list(dep))
  p
}

# 以下是內部的小工具 ----

#' Whether a package is installed (can be replaced in tests)
#' @noRd
kit_has_pkg <- function(pkg) requireNamespace(pkg, quietly = TRUE)

#' Stop when plotly is missing, and say what to install
#' @noRd
kit_need_plotly <- function(fun) {
  if (!kit_has_pkg("plotly")) {
    # 原文： 要用 plotly 套件，但這台電腦還沒有裝。請先安裝：install.packages(\"plotly\")
    stop(fun, " \u8981\u7528 plotly \u5957\u4ef6\uff0c\u4f46\u9019\u53f0\u96fb\u8166\u9084\u6c92\u6709\u88dd\u3002\u8acb\u5148\u5b89\u88dd\uff1ainstall.packages(\"plotly\")",
         call. = FALSE)
  }
  invisible(TRUE)
}

#' Text sizes: body, small (legend, hover box, small-chart titles), ticks, title
#' @noRd
kit_plotly_sizes <- function(font_size) {
  list(body = font_size, small = font_size - 1, tick = font_size - 2,
       title = round(font_size * 1.2))
}

#' A plotly font
#' @noRd
kit_plotly_font <- function(size, color = KIT_PLOTLY_INK) {
  list(family = KIT_PLOTLY_FONT, size = size, color = color)
}

#' The look of one axis (range, tick positions, and title text stay the same)
#' @noRd
kit_axis_style <- function(ax, size) {
  ax <- ax %||% list()
  title <- ax$title
  if (is.character(title) || is.numeric(title)) title <- list(text = as.character(title))
  if (is.list(title)) title$font <- kit_plotly_font(size$body)
  ax <- utils::modifyList(ax, list(
    showline = TRUE, mirror = FALSE, linecolor = KIT_PLOTLY_INK, linewidth = 1.5,
    ticks = "outside", ticklen = 5, tickwidth = 1, tickcolor = KIT_PLOTLY_INK,
    gridcolor = KIT_PLOTLY_LINE_SOFT, gridwidth = 1,
    zerolinecolor = KIT_PLOTLY_LINE, zerolinewidth = 1,
    automargin = TRUE,
    tickfont = kit_plotly_font(size$tick, KIT_PLOTLY_HINT)
  ))
  if (!is.null(title)) ax$title <- title
  ax
}

#' The axes a trace uses ("x2" -> "xaxis2")
#' @noRd
kit_trace_axes <- function(data) {
  xy <- Filter(function(tr) !isTRUE((tr$type %||% "scatter") %in% KIT_PLOTLY_NOT_XY), data)
  ax <- unlist(lapply(xy, function(tr) c(tr$xaxis %||% "x", tr$yaxis %||% "y")))
  unique(sub("^([xy])", "\\1axis", as.character(ax)))
}

#' Whether every trace has x and y axes (whether the toolbar gets zoom in and zoom out)
#' @noRd
kit_all_xy <- function(data) {
  types <- vapply(data, function(tr) as.character(tr$type %||% "scatter")[1], character(1))
  !any(types %in% KIT_PLOTLY_NOT_XY)
}

#' Whether a value is this number
#' @noRd
kit_is_num <- function(x, value) is.numeric(x) && length(x) == 1 && isTRUE(x == value)

#' The frame kits draws around each small chart: a rect, x and y both domain 0 to 1, a
#' transparent fill
#' @noRd
kit_is_panel_box <- function(s) {
  fill <- s$fillcolor %||% "rgba(0,0,0,0)"
  identical(s$type, "rect") &&
    kit_is_num(s$x0, 0) && kit_is_num(s$x1, 1) && kit_is_num(s$y0, 0) && kit_is_num(s$y1, 1) &&
    grepl(" domain$", s$xref %||% "") && grepl(" domain$", s$yref %||% "") &&
    gsub(" ", "", tolower(fill)) %in% c("rgba(0,0,0,0)", "transparent")
}

#' Text on the chart (annotations): the app's typeface; colors and sizes that are set stay the same.
#' Small-chart titles (at the top edge of a small chart, yanchor = "bottom") are at least the tick
#' size
#' @noRd
kit_annotation_style <- function(a, size) {
  if (!is.list(a) || is.null(a$text)) return(a)
  f <- a$font %||% list()
  f$family <- KIT_PLOTLY_FONT
  f$color <- f$color %||% KIT_PLOTLY_INK
  if (identical(a$yanchor, "bottom")) f$size <- max(f$size %||% 0, size$tick)
  a$font <- f
  a
}

#' Whether there are annotations above the top edge of the plot (kits' small-chart titles): leave a
#' line below the title
#' @noRd
kit_has_top_annotations <- function(annotations) {
  any(vapply(annotations %||% list(), function(a) {
    is.list(a) && identical(a$yref %||% "paper", "paper") && is.numeric(a$y) &&
      length(a$y) == 1 && a$y >= 0.99 && identical(a$yanchor %||% "auto", "bottom")
  }, logical(1)))
}

#' The look of a color bar: text, outline, ticks (the title text stays the same)
#' @noRd
kit_colorbar_style <- function(cb, size) {
  cb <- cb %||% list()
  title <- cb$title
  if (is.character(title) || is.numeric(title)) title <- list(text = as.character(title))
  if (is.list(title)) {
    title$font <- kit_plotly_font(size$small)
    title$side <- title$side %||% "top"
  }
  cb <- utils::modifyList(cb, list(
    tickfont = kit_plotly_font(size$tick, KIT_PLOTLY_HINT),
    outlinecolor = KIT_PLOTLY_INK, outlinewidth = 1, thickness = 14,
    ticks = "outside", tickcolor = KIT_PLOTLY_INK, ticklen = 4
  ))
  if (!is.null(title)) cb$title <- title
  cb
}

#' The number of legend entries and the widest one (a Chinese character counts as 2 columns)
#' @noRd
kit_legend_info <- function(data) {
  shown <- Filter(function(tr) {
    !isFALSE(tr$showlegend) && length(tr$name) > 0 && nzchar(as.character(tr$name)[1])
  }, data)
  if (length(shown) == 0) return(list(n = 0L, width = 0L))
  # 只有一個 trace、又沒有說要顯示時，plotly 不畫圖例
  if (length(data) == 1 && !isTRUE(data[[1]]$showlegend)) return(list(n = 0L, width = 0L))
  key <- vapply(shown, function(tr) as.character(tr$legendgroup %||% tr$name)[1], character(1))
  names <- vapply(shown, function(tr) as.character(tr$name)[1], character(1))
  plain <- gsub("<[^>]+>", "", names)
  list(n = length(unique(key)), width = max(nchar(plain, type = "width")))
}

# 圖例的兩個位置
KIT_LEGEND_BOTTOM <- list(
  orientation = "h", x = 0, xanchor = "left", xref = "paper",
  y = 0, yanchor = "bottom", yref = "container"
)
KIT_LEGEND_RIGHT <- list(
  orientation = "v", x = 1.02, xanchor = "left", xref = "paper",
  y = 1, yanchor = "top", yref = "paper"
)

#' list(x = 0) -> list("legend.x" = 0) (for Plotly.relayout)
#' @noRd
kit_relayout_keys <- function(prefix, x) {
  stats::setNames(x, paste0(prefix, ".", names(x)))
}

#' Split a title into the first line (plain text) and the other lines (e.g. kits' "<sup>…</sup>"
#' subtitle)
#' @return NULL (no title) or list(main, rest)
#' @noRd
kit_title_parts <- function(title) {
  text <- if (is.list(title)) title$text else title
  if (is.null(text) || length(text) != 1 || is.na(text) || !nzchar(as.character(text))) return(NULL)
  parts <- strsplit(as.character(text), "<br>", fixed = TRUE)[[1]]
  main <- gsub("</?b>", "", parts[1])
  rest <- if (length(parts) > 1) paste(parts[-1], collapse = "<br>") else ""
  list(main = main, rest = rest)
}

#' The title text: the first line in bold
#' @noRd
kit_title_text <- function(main, rest = "") {
  paste0("<b>", main, "</b>", if (nzchar(rest)) paste0("<br>", rest))
}

#' Top margin: fixed + line * lines (the browser uses the same formula when the title wraps)
#' @noRd
kit_title_top <- function(title, size, band) {
  if (is.null(title)) return(list(fixed = 12 + band, line = 0, lines = 0, rest_lines = 0))
  rest_lines <- if (nzchar(title$rest)) length(strsplit(title$rest, "<br>", fixed = TRUE)[[1]]) else 0
  # plotly 的標題每一行高 1.3 倍字級（<sup> 的小標也是）
  line <- round(size$title * 1.3)
  list(fixed = KIT_TITLE_PAD + rest_lines * line + 10 + band,
       line = line, lines = 1, rest_lines = rest_lines)
}

#' Space above the title: plotly moves a multi-line title up (about half a line per extra line);
#' this adds it back
#' @noRd
kit_title_pad <- function(top, main_lines) {
  KIT_TITLE_PAD + round((main_lines + top$rest_lines - 1) * top$line / 2)
}

#' A color string (#RRGGBB, rgb(), rgba()) -> list(hex, alpha); NULL when not recognized
#' @noRd
kit_parse_color <- function(x) {
  x <- gsub(" ", "", x)
  if (grepl("^#[0-9A-Fa-f]{6}$", x)) return(list(hex = toupper(x), alpha = NULL))
  m <- regmatches(x, regexec("^rgba?\\(([0-9.]+),([0-9.]+),([0-9.]+)(,([0-9.]+))?\\)$", x))[[1]]
  if (length(m) == 0) return(NULL)
  rgb <- round(as.numeric(m[2:4]))
  list(hex = sprintf("#%02X%02X%02X", rgb[1], rgb[2], rgb[3]),
       alpha = if (nzchar(m[6])) m[6] else NULL)
}

#' plotly's default color -> the Okabe–Ito color in the same position (others stay the same)
#' @noRd
kit_swap_default_color <- function(x) {
  col <- kit_parse_color(x)
  if (is.null(col)) return(x)
  i <- match(col$hex, KIT_PLOTLY_DEFAULT_COLORS)
  if (is.na(i)) return(x)
  new <- kit_chart_colors(length(KIT_PLOTLY_DEFAULT_COLORS))[i]
  if (is.null(col$alpha)) return(new)
  rgb <- strtoi(c(substr(new, 2, 3), substr(new, 4, 5), substr(new, 6, 7)), 16L)
  sprintf("rgba(%d,%d,%d,%s)", rgb[1], rgb[2], rgb[3], col$alpha)
}

#' Replace the colors plotly (R) itself gives a trace (class "colorway") with Okabe–Ito; set colors
#' stay the same
#' @noRd
kit_recolor_defaults <- function(x) {
  if (is.character(x) && inherits(x, "colorway")) {
    x[] <- vapply(x, kit_swap_default_color, character(1), USE.NAMES = FALSE)
    return(x)
  }
  if (is.list(x) && length(x) > 0) x[] <- lapply(x, kit_recolor_defaults)
  x
}

# 工具列的兩個下載（瀏覽器端，不經過 R）：
#   PNG：寬度一律 2100 px（7 吋、300 dpi；長寬比照畫面），檔案裡寫 300 dpi（pHYs），
#        Word 插進去預設就是 7 吋寬，投稿系統讀到的也是 300 dpi。
#   SVG：向量圖；文字只記字型名稱，用電腦裡有的字型顯示。
# 存檔用一個不放進頁面的 <a download>（和 kit.js 的下載一樣，外掛看不到）。
# 下載的單一 HTML 檔裡也有這兩顆按鈕：程式寫在 config 裡，不靠 kit.js。
KIT_PLOTLY_PNG_WIDTH <- 2100
KIT_PLOTLY_PNG_DPI <- 300
KIT_PLOTLY_SAVE_JS <- "function(gd) {
  var FMT = '%s', WIDTH = %d, DPI = %d;
  var o = gd._context.toImageButtonOptions || {}, name = (o.filename || 'plot') + '.' + FMT;
  var w = gd._fullLayout.width, h = gd._fullLayout.height;
  var opts = {format: FMT, width: w, height: h};
  if (FMT === 'png') opts.scale = WIDTH / w;
  function crc32(b) {
    var c = 0xFFFFFFFF;
    for (var i = 0; i < b.length; i++) {
      c ^= b[i];
      for (var k = 0; k < 8; k++) c = (c & 1) ? (c >>> 1) ^ 0xEDB88320 : c >>> 1;
    }
    return (c ^ 0xFFFFFFFF) >>> 0;
  }
  // PNG pHYs chunk (pixels per metre) right after IHDR; drop any existing one
  function withDpi(png) {
    var ppm = Math.round(DPI / 0.0254), d = new Uint8Array(21), v = new DataView(d.buffer);
    v.setUint32(0, 9); d.set([112, 72, 89, 115], 4); v.setUint32(8, ppm); v.setUint32(12, ppm);
    d[16] = 1; v.setUint32(17, crc32(d.subarray(4, 17)));
    var parts = [png.subarray(0, 8)], dv = new DataView(png.buffer), p = 8;
    while (p + 8 <= png.length) {
      var end = p + 12 + dv.getUint32(p);
      var type = String.fromCharCode(png[p + 4], png[p + 5], png[p + 6], png[p + 7]);
      if (type !== 'pHYs') parts.push(png.subarray(p, end));
      if (type === 'IHDR') parts.push(d);
      p = end;
    }
    return parts;
  }
  Plotly.toImage(gd, opts)
    .then(function(url) { return fetch(url); })
    .then(function(r) { return r.arrayBuffer(); })
    .then(function(buf) {
      var bytes = new Uint8Array(buf);
      var blob = new Blob(FMT === 'png' ? withDpi(bytes) : [bytes],
                          {type: FMT === 'png' ? 'image/png' : 'image/svg+xml'});
      var href = URL.createObjectURL(blob), a = document.createElement('a');
      a.href = href;
      a.download = name;
      a.click();
      setTimeout(function() { URL.revokeObjectURL(href); }, 60000);
    })
    .catch(function(e) { if (window.console) console.error(e); });
}"

#' A toolbar button that saves the chart as PNG (2100 px wide, 300 dpi) or SVG
#' @noRd
kit_plotly_save_button <- function(format = c("png", "svg")) {
  format <- match.arg(format)
  title <- switch(format,
    # 原文：下載 PNG（7 吋寬、300 dpi）
    png = "\u4e0b\u8f09 PNG\uff087 \u540b\u5bec\u3001300 dpi\uff09",
    # 原文：下載 SVG 向量圖（文字用電腦裡有的字型）
    svg = "\u4e0b\u8f09 SVG \u5411\u91cf\u5716\uff08\u6587\u5b57\u7528\u96fb\u8166\u88e1\u6709\u7684\u5b57\u578b\uff09")
  icon <- switch(format,
    png = "Plotly.Icons.camera",
    svg = "(Plotly.Icons.drawopenpath || Plotly.Icons.disk)")
  list(
    name = paste0("kit_save_", format),
    title = title,
    icon = htmlwidgets::JS(icon),
    click = htmlwidgets::JS(sprintf(KIT_PLOTLY_SAVE_JS, format, KIT_PLOTLY_PNG_WIDTH, KIT_PLOTLY_PNG_DPI))
  )
}

#' Toolbar: no logo; download PNG (300 dpi), download SVG, zoom in, zoom out, and reset to the
#' original range; Traditional Chinese
#' @noRd
kit_plotly_config <- function(p, xy, filename) {
  has_locale <- any(vapply(p$dependencies, function(d) identical(d$name, "plotly-locale-zh-TW"),
                           logical(1)))
  if (!has_locale) p <- tryCatch(plotly::config(p, locale = "zh-TW"), error = function(e) p)
  cfg <- p$x$config %||% list()
  cfg$modeBarButtonsToAdd <- NULL
  cfg$modeBarButtonsToRemove <- NULL
  save <- list(kit_plotly_save_button("png"), kit_plotly_save_button("svg"))
  zoom <- if (xy) list("zoomIn2d", "zoomOut2d", "resetScale2d") else list()
  cfg$modeBarButtons <- list(c(save, zoom))
  cfg$displaylogo <- FALSE
  # 檔名給上面兩顆按鈕用（plotly 自己的「下載成 PNG」已經拿掉）
  cfg$toImageButtonOptions <- list(format = "png", filename = filename)
  p$x$config <- cfg
  p
}

# 瀏覽器端：圖寬小於 narrow 時圖例放到下面（legend = "auto" 時）；標題放不下時換行；
# 左邊、下面的軸標題與圖例離卡片的邊至少 gap px（plotly 的 automargin 會貼齊邊）。
# 每次畫圖（含 Shiny 重畫）更新設定；圖的大小變了（ResizeObserver）、畫完（plotly_afterplot）再算一次。
KIT_PLOTLY_JS <- "function(el, x, d) {
  var gd = el;
  gd._kitStyle = d;
  function wrap(text, maxw, font) {
    var ctx = gd._kitCtx || (gd._kitCtx = document.createElement('canvas').getContext('2d'));
    ctx.font = font;
    if (ctx.measureText(text).width <= maxw) return [text];
    var toks = text.match(/[A-Za-z0-9_.,:;!?%+\\-\\/'=]+|\\s+|[\\s\\S]/g) || [text];
    var closing = /^[\\uFF09\\uFF0C\\u3001\\u3002\\uFF1A\\uFF1B\\u300D\\)\\],.:;]/;
    var opening = /[\\uFF08\\u300C(\\[]$/;
    var out = [], cur = '';
    for (var i = 0; i < toks.length; i++) {
      var t = toks[i];
      if (cur.trim() && !closing.test(t) && ctx.measureText(cur + t).width > maxw) {
        var carry = '';
        if (opening.test(cur) && cur.length > 1) { carry = cur.slice(-1); cur = cur.slice(0, -1); }
        out.push(cur.replace(/\\s+$/, ''));
        cur = carry + t.replace(/^\\s+/, '');
      } else {
        cur += t;
      }
    }
    if (cur.trim()) out.push(cur.replace(/\\s+$/, ''));
    return out.length ? out : [text];
  }
  function apply() {
    var d = gd._kitStyle, L = gd.layout;
    if (!d || !L || !window.Plotly) return;
    var w = gd.clientWidth;
    if (!w) return;
    var upd = {};
    if (d.legend) {
      var wantH = d.bottom || w < d.narrow;
      var isH = !!(L.legend && L.legend.orientation === 'h');
      if (wantH !== isH) {
        var src = wantH ? d.legend_h : d.legend_v;
        for (var k in src) upd[k] = src[k];
      }
    }
    if (d.title && d.title.main) {
      var t = d.title;
      var lines = wrap(t.main, w - 2 * t.pad - 4, t.font);
      var text = lines.map(function(s) { return '<b>' + s + '</b>'; }).join('<br>') +
        (t.rest ? '<br>' + t.rest : '');
      if (!L.title || L.title.text !== text) {
        upd['title.text'] = text;
        upd['margin.t'] = t.fixed + t.line * lines.length;
        upd['title.pad.t'] = t.pad + Math.round((lines.length + t.rest_lines - 1) * t.line / 2);
      }
    }
    // automargin puts axis titles and the legend flush against the edge: leave d.gap px
    var pm = (gd._fullLayout && gd._fullLayout._pushmargin) || {};
    var need = {l: 0, b: 0};
    for (var id in pm) {
      if (id === 'base' || !pm[id]) continue;
      ['l', 'b'].forEach(function(s) {
        var v = pm[id][s];
        if (v && v.size && (v.val || 0) <= 0.01) need[s] = Math.max(need[s], v.size);
      });
    }
    ['l', 'b'].forEach(function(s) {
      var want = Math.max(d.base[s], Math.ceil(need[s] + d.gap));
      var cur = (L.margin && L.margin[s]) || 0;
      if (need[s] > 0 && Math.abs(cur - want) > 1) upd['margin.' + s] = want;
    });
    if (Object.keys(upd).length) window.Plotly.relayout(gd, upd);
  }
  gd._kitApply = apply;
  var timer = null;
  var later = function() {
    clearTimeout(timer);
    timer = setTimeout(function() { if (gd._kitApply) gd._kitApply(); }, 80);
  };
  if (!gd._kitBound) {
    gd._kitBound = true;
    if (window.ResizeObserver) new ResizeObserver(later).observe(gd);
    else window.addEventListener('resize', later);
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(later);
  }
  // Plotly.newPlot drops event listeners: bind again on every render
  if (gd.on) {
    if (gd._kitAfter && gd.removeListener) gd.removeListener('plotly_afterplot', gd._kitAfter);
    gd._kitAfter = later;
    gd.on('plotly_afterplot', later);
  }
  apply();
}"

#' Add (or replace) the browser-side script; applying it twice to the same chart leaves one copy
#' @noRd
kit_plotly_responsive <- function(p, data) {
  hooks <- p$jsHooks$render
  if (length(hooks) > 0) {
    p$jsHooks$render <- Filter(function(h) !identical(h$code, KIT_PLOTLY_JS), hooks)
  }
  if (!kit_has_pkg("htmlwidgets")) return(p)
  htmlwidgets::onRender(p, KIT_PLOTLY_JS, data = data)
}
