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

# 連續數值的色階：白 -> 淡萊姆（bg-new）-> KIT 綠（nb-green），中間在 Lab 空間內插
KIT_CHART_SEQUENTIAL <- list(
  list(0, "#FFFFFF"), list(0.2, "#E8F0A0"), list(0.4, "#B3CC83"),
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

#' 連續數值的色階（Chart）
#'
#' 白 → 淡萊姆（`bg-new`）→ KIT 綠（`nb-green`）：值越大越深。用在熱圖、色條
#' （例如作答設計圖的通過比例）。[kit_plotly_style()] 預設把熱圖換成這個色階。
#'
#' @return plotly 的 colorscale：`list(list(0, "#FFFFFF"), ..., list(1, "#006835"))`。
#' @seealso [kit_plotly_style()]、[kit_chart_colors()]
#' @examples
#' kit_chart_sequential()
#' @export
kit_chart_sequential <- function() KIT_CHART_SEQUENTIAL

#' plotly 圖套上 KIT 的樣子（Chart）
#'
#' 讓 plotly 圖和 app 的其他部分看起來是一套：字型、字級、顏色都用 KIT 的設計變數。
#' 只改樣子，不改資料（點、線、軸的範圍、刻度的位置、hover 的文字都不動）。
#'
#' 改的地方：
#'
#' - **字型**：全部用 app 的圓體 `"Chiron GoRound TC", sans-serif`；字是 `nb-ink`（#141414），
#'   刻度是 `text-hint`（#5a5a5a）。字級：內文 `font_size`（預設 15px）、圖例與滑過的說明框小 1px、
#'   刻度小 2px、標題約 `h5`（`font_size` 的 1.2 倍）。
#' - **標題**：靠左、粗體。圖寬放不下時在瀏覽器端換行（在中文字或空白之間斷開）。
#' - **每一條軸**（`xaxis`、`xaxis2`…、`yaxis`…，包括 Wright map 這類並排的小圖）：
#'   軸線 `nb-ink` 1.5px、格線 `line-soft`（#e3ded2）、零線 `line`（#d9d4c5）、
#'   刻度朝外；不畫四邊的框（`mirror = FALSE`，並拿掉 kits 畫在每個小圖外面的黑框；
#'   KIT 設計語言：框裡面不再有框）。軸的標題與刻度放不下時自動加寬邊界（`automargin`）。
#' - **底色**：白（圖放在白色卡片裡）；下載的 PNG 也是白底。
#' - **顏色**：`colorway` 是 Okabe–Ito（[kit_chart_colors()]）。plotly 自己給的預設色換成
#'   Okabe–Ito 同一個位置的顏色；**kits 或 kitsUI 指定的顏色不動**（kitsUI 的角色色、
#'   類別換色都保留）。
#' - **色階**（`colorscale = TRUE`）：熱圖類（heatmap、contour、histogram2d）換成
#'   [kit_chart_sequential()]（白 → 淡萊姆 → KIT 綠）；色條的字、外框一律換樣子。
#' - **滑過的說明框**：白底、`nb-ink` 框、app 的字型。
#' - **圖例**：app 的字型、沒有框。位置見 `legend`。
#' - **工具列**：沒有 plotly 的標誌；只留「下載成 PNG」（白底、2 倍解析度）、放大、縮小、
#'   回到原來的範圍；介面文字是繁體中文（`zh-TW`）。
#' - **邊界**：上下左右一樣小，軸、圖例、色條放不下時 plotly 自動加寬；不會切到字。
#'
#' 不改的地方：資料、軸的範圍與刻度、trace 的顏色（plotly 的預設色以外）、點的形狀、線的
#' 粗細與虛線、透明度、hover 的文字、圖例的文字、標題與軸標題的文字（只加粗體）、
#' 圖的高度與寬度、`shapes`（kits 的小圖外框以外，例如適配度圖的灰色帶）。
#'
#' **和 kits、kitsUI 一起用時的順序**：kits 的 `plot()` → kitsUI 換色
#' （`kit_chart_categorical()`、`kit_chart_role()`）→ kitsUI 換中文（`kit_chart_zh()`）→
#' `kit_plotly_style()`。換色和這個函式的順序可以對調（這裡不動指定的顏色），但**換中文要在前面**：
#' 這裡把標題加上 `<b>`，之後 `kit_chart_zh()` 就認不得原來的英文標題了。
#' 同一張圖套兩次和套一次一樣。
#'
#' @param p plotly 圖（`plotly::plot_ly()`、kits 的 `plot()`；`plotly::plotly_build()` 過的也可以）。
#' @param legend 圖例放哪裡：
#'   - `"auto"`（預設）：超過 4 項，或最長的一項超過 20 欄（中文字算 2 欄）時放在圖的下面、橫排、
#'     靠左；其他放在右邊。圖寬小於 600px（手機）時也放到下面，變寬時回到右邊（瀏覽器端判斷）。
#'   - `"bottom"`：一律在下面；`"right"`：一律在右邊。
#'   - `"keep"`：不動圖例的位置（只換字型）。
#' @param colorscale `TRUE`（預設）時熱圖類換成 [kit_chart_sequential()]；`FALSE` 時保留原來的色階。
#' @param fonts `TRUE`（預設）時附上 Google Fonts 的圓體（[kit_plotly_fonts()]），
#'   下載的單一 HTML 檔也是 app 的字型。
#' @param filename 工具列「下載成 PNG」的檔名（不含副檔名）。
#' @param font_size 內文字級（px）；其他字級跟著它算。
#' @return plotly 圖（`plotly_build()` 過的）。
#' @seealso [kit_plotly_fonts()]、[kit_chart_colors()]、[kit_chart_sequential()]
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
                             font_size = 15) {
  kit_need_plotly("kit_plotly_style()")
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
      tr$colorscale <- KIT_CHART_SEQUENTIAL
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

#' plotly 圖附上 app 的字型（下載的 HTML 用）
#'
#' 在 plotly 圖上附一個 htmlDependency：向 Google Fonts 拿圓體 Chiron GoRound TC
#' （字重 400、700）。Shiny 的頁面已經有這個字型（[kit_theme()]），所以這主要是給
#' `htmlwidgets::saveWidget()` 存成的單一 HTML 檔用：打開時也是 app 的字型；沒有網路時退回
#' 系統的 sans-serif。
#'
#' `<link>` 帶 `data-external="1"`：`saveWidget(selfcontained = TRUE)` 用 pandoc 打包時不把
#' 字型檔塞進 HTML（中文字型切成上百個檔，塞進去檔案會很大）。
#' [kit_plotly_style()] 預設（`fonts = TRUE`）已經呼叫它；同一張圖附兩次和附一次一樣。
#'
#' @param p plotly 圖（或其他 htmlwidget）。
#' @return 同一張圖，多一個 htmlDependency（`kit-plotly-fonts`）。
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

#' 有沒有裝某個套件（測試時可以換掉）
#' @noRd
kit_has_pkg <- function(pkg) requireNamespace(pkg, quietly = TRUE)

#' 沒有 plotly 時停下來，說要裝什麼
#' @noRd
kit_need_plotly <- function(fun) {
  if (!kit_has_pkg("plotly")) {
    # 原文： 要用 plotly 套件，但這台電腦還沒有裝。請先安裝：install.packages(\"plotly\")
    stop(fun, " \u8981\u7528 plotly \u5957\u4ef6\uff0c\u4f46\u9019\u53f0\u96fb\u8166\u9084\u6c92\u6709\u88dd\u3002\u8acb\u5148\u5b89\u88dd\uff1ainstall.packages(\"plotly\")",
         call. = FALSE)
  }
  invisible(TRUE)
}

#' 字級：內文、小（圖例、滑過的說明框、小圖的標題）、刻度、標題
#' @noRd
kit_plotly_sizes <- function(font_size) {
  list(body = font_size, small = font_size - 1, tick = font_size - 2,
       title = round(font_size * 1.2))
}

#' plotly 的 font
#' @noRd
kit_plotly_font <- function(size, color = KIT_PLOTLY_INK) {
  list(family = KIT_PLOTLY_FONT, size = size, color = color)
}

#' 一條軸的樣子（範圍、刻度位置、標題文字都不動）
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

#' trace 用到的軸（"x2" -> "xaxis2"）
#' @noRd
kit_trace_axes <- function(data) {
  xy <- Filter(function(tr) !isTRUE((tr$type %||% "scatter") %in% KIT_PLOTLY_NOT_XY), data)
  ax <- unlist(lapply(xy, function(tr) c(tr$xaxis %||% "x", tr$yaxis %||% "y")))
  unique(sub("^([xy])", "\\1axis", as.character(ax)))
}

#' 每個 trace 都有 x、y 軸嗎（工具列要不要放大、縮小）
#' @noRd
kit_all_xy <- function(data) {
  types <- vapply(data, function(tr) as.character(tr$type %||% "scatter")[1], character(1))
  !any(types %in% KIT_PLOTLY_NOT_XY)
}

#' 一個值是不是這個數字
#' @noRd
kit_is_num <- function(x, value) is.numeric(x) && length(x) == 1 && isTRUE(x == value)

#' kits 畫在每個小圖外面的框：rect、x 與 y 都是 0 到 1 的 domain、透明的底
#' @noRd
kit_is_panel_box <- function(s) {
  fill <- s$fillcolor %||% "rgba(0,0,0,0)"
  identical(s$type, "rect") &&
    kit_is_num(s$x0, 0) && kit_is_num(s$x1, 1) && kit_is_num(s$y0, 0) && kit_is_num(s$y1, 1) &&
    grepl(" domain$", s$xref %||% "") && grepl(" domain$", s$yref %||% "") &&
    gsub(" ", "", tolower(fill)) %in% c("rgba(0,0,0,0)", "transparent")
}

#' 圖上的字（annotations）：app 的字型；顏色、字級有指定的就不動。
#' 小圖的標題（放在小圖上緣、yanchor = "bottom"）至少是刻度的字級
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

#' 有沒有放在圖的上緣外面的 annotations（kits 的小圖標題）：標題下面要留一行
#' @noRd
kit_has_top_annotations <- function(annotations) {
  any(vapply(annotations %||% list(), function(a) {
    is.list(a) && identical(a$yref %||% "paper", "paper") && is.numeric(a$y) &&
      length(a$y) == 1 && a$y >= 0.99 && identical(a$yanchor %||% "auto", "bottom")
  }, logical(1)))
}

#' 色條的樣子：字、外框、刻度（標題的文字不動）
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

#' 圖例的項目數與最長的寬度（中文字算 2 欄）
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

#' list(x = 0) -> list("legend.x" = 0)（Plotly.relayout 用）
#' @noRd
kit_relayout_keys <- function(prefix, x) {
  stats::setNames(x, paste0(prefix, ".", names(x)))
}

#' 標題拆成第一行（純文字）與其他行（例如 kits 的 "<sup>…</sup>" 小標）
#' @return NULL（沒有標題）或 list(main, rest)
#' @noRd
kit_title_parts <- function(title) {
  text <- if (is.list(title)) title$text else title
  if (is.null(text) || length(text) != 1 || is.na(text) || !nzchar(as.character(text))) return(NULL)
  parts <- strsplit(as.character(text), "<br>", fixed = TRUE)[[1]]
  main <- gsub("</?b>", "", parts[1])
  rest <- if (length(parts) > 1) paste(parts[-1], collapse = "<br>") else ""
  list(main = main, rest = rest)
}

#' 標題的文字：第一行粗體
#' @noRd
kit_title_text <- function(main, rest = "") {
  paste0("<b>", main, "</b>", if (nzchar(rest)) paste0("<br>", rest))
}

#' 上邊界：fixed + line * lines（標題換行時瀏覽器端用同一個算法）
#' @noRd
kit_title_top <- function(title, size, band) {
  if (is.null(title)) return(list(fixed = 12 + band, line = 0, lines = 0, rest_lines = 0))
  rest_lines <- if (nzchar(title$rest)) length(strsplit(title$rest, "<br>", fixed = TRUE)[[1]]) else 0
  # plotly 的標題每一行高 1.3 倍字級（<sup> 的小標也是）
  line <- round(size$title * 1.3)
  list(fixed = KIT_TITLE_PAD + rest_lines * line + 10 + band,
       line = line, lines = 1, rest_lines = rest_lines)
}

#' 標題的上方留白：plotly 把多行的標題往上移（每多一行約半行），這裡補回來
#' @noRd
kit_title_pad <- function(top, main_lines) {
  KIT_TITLE_PAD + round((main_lines + top$rest_lines - 1) * top$line / 2)
}

#' 一個顏色字串（#RRGGBB、rgb()、rgba()）-> list(hex, alpha)；認不得時 NULL
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

#' plotly 的預設色 -> Okabe–Ito 同一個位置的顏色（認不得的不動）
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

#' trace 裡 plotly（R）自己給的顏色（class 是 "colorway"）換成 Okabe–Ito；指定的顏色不動
#' @noRd
kit_recolor_defaults <- function(x) {
  if (is.character(x) && inherits(x, "colorway")) {
    x[] <- vapply(x, kit_swap_default_color, character(1), USE.NAMES = FALSE)
    return(x)
  }
  if (is.list(x) && length(x) > 0) x[] <- lapply(x, kit_recolor_defaults)
  x
}

#' 工具列：沒有標誌、只留下載 PNG（白底）與放大、縮小、回到原來的範圍；繁體中文
#' @noRd
kit_plotly_config <- function(p, xy, filename) {
  has_locale <- any(vapply(p$dependencies, function(d) identical(d$name, "plotly-locale-zh-TW"),
                           logical(1)))
  if (!has_locale) p <- tryCatch(plotly::config(p, locale = "zh-TW"), error = function(e) p)
  cfg <- p$x$config %||% list()
  cfg$modeBarButtonsToAdd <- NULL
  cfg$modeBarButtonsToRemove <- NULL
  buttons <- if (xy) c("toImage", "zoomIn2d", "zoomOut2d", "resetScale2d") else "toImage"
  cfg$modeBarButtons <- list(as.list(buttons))
  cfg$displaylogo <- FALSE
  cfg$toImageButtonOptions <- list(format = "png", filename = filename, scale = 2)
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

#' 加上（或換掉）瀏覽器端的小程式；同一張圖套兩次只有一份
#' @noRd
kit_plotly_responsive <- function(p, data) {
  hooks <- p$jsHooks$render
  if (length(hooks) > 0) {
    p$jsHooks$render <- Filter(function(h) !identical(h$code, KIT_PLOTLY_JS), hooks)
  }
  if (!kit_has_pkg("htmlwidgets")) return(p)
  htmlwidgets::onRender(p, KIT_PLOTLY_JS, data = data)
}
