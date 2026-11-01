# Give a plotly chart the KIT look (chart)

Makes plotly charts look like part of the same app: typeface, text
sizes, and colors all use KIT's design variables. Only the look changes,
not the data (points, lines, axis ranges, tick positions, and hover text
stay the same).

## Usage

``` r
kit_plotly_style(
  p,
  legend = c("auto", "bottom", "right", "keep"),
  colorscale = TRUE,
  fonts = TRUE,
  filename = "kit-chart",
  font_size = 15,
  brand = kit_current_brand()
)
```

## Arguments

- p:

  A plotly chart
  ([`plotly::plot_ly()`](https://rdrr.io/pkg/plotly/man/plot_ly.html),
  kits' [`plot()`](https://rdrr.io/r/graphics/plot.default.html); one
  already passed through
  [`plotly::plotly_build()`](https://rdrr.io/pkg/plotly/man/plotly_build.html)
  also works).

- legend:

  Where the legend goes:

  - `"auto"` (default): with more than 4 entries, or when the longest
    entry is wider than 20 columns (a Chinese character counts as 2),
    the legend goes below the chart, horizontal, left-aligned; otherwise
    on the right. When the chart is narrower than 600px (phones) it also
    moves below, and returns to the right when the chart gets wider
    (decided in the browser).

  - `"bottom"`: always below; `"right"`: always on the right.

  - `"keep"`: leave the legend position alone (only change the font).

- colorscale:

  When `TRUE` (default), heatmap-type traces switch to
  [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md);
  when `FALSE`, the original color scale is kept.

- fonts:

  When `TRUE` (default), attaches the rounded typeface from Google Fonts
  ([`kit_plotly_fonts()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_fonts.md)),
  so a downloaded single HTML file also uses the app's typeface.

- filename:

  The file name (without extension) for the toolbar's "download PNG" and
  "download SVG".

- font_size:

  Body text size (px); the other sizes are derived from it.

- brand:

  The brand
  ([`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)):
  the heatmap color scale comes from it
  ([`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md)).
  Defaults to
  [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md)
  (KIT when not set). Text, axis lines, and background keep the design
  language's ink and white.

## Value

A plotly chart (passed through `plotly_build()`).

## Details

What changes:

- **Typeface**: everything uses the app's rounded typeface
  `"Chiron GoRound TC", sans-serif`; text is `nb-ink` (#141414), ticks
  are `text-hint` (#5a5a5a). Sizes: body `font_size` (default 15px),
  legend and hover box 1px smaller, ticks 2px smaller, title about `h5`
  (1.2 times `font_size`).

- **Title**: left-aligned, bold. When the chart is too narrow, it wraps
  in the browser (breaking between Chinese characters or at spaces).

- **Every axis** (`xaxis`, `xaxis2`…, `yaxis`…, including side-by-side
  small charts such as a Wright map): axis line `nb-ink` 1.5px, grid
  lines `line-soft` (#e3ded2), zero line `line` (#d9d4c5), ticks
  outside; no frame on four sides (`mirror = FALSE`, and the black frame
  kits draws around each small chart is removed; KIT design language: no
  frames inside frames). When axis titles and ticks do not fit, the
  margins widen automatically (`automargin`).

- **Background**: white (the chart sits in a white card); downloaded
  PNGs and SVGs also have a white background.

- **Colors**: `colorway` is Okabe–Ito
  ([`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_colors.md)).
  plotly's own default colors are replaced with the Okabe–Ito color in
  the same position; **colors set by kits or kitsUI stay unchanged**
  (kitsUI's role colors and category recoloring are kept).

- **Color scale** (`colorscale = TRUE`): heatmap-type traces (heatmap,
  contour, histogram2d) switch to
  [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md)
  (very light lime → light lime → KIT green); the color bar's text and
  outline always get the new look.

- **Hover box**: white background, `nb-ink` border, the app's typeface.

- **Legend**: the app's typeface, no border. For position, see `legend`.

- **Toolbar**: no plotly logo; only "download PNG", "download SVG", zoom
  in, zoom out, and reset to the original range remain; interface text
  is Traditional Chinese (`zh-TW`). The PNG is always 2100 pixels wide
  (7 inches at 300 dpi; the aspect ratio is the one on screen) and the
  file says 300 dpi, so it is 7 inches wide when inserted in Word. The
  SVG is a vector image for journals that want 600 dpi or more, EPS or
  PDF; its text uses the fonts on the computer that opens it (the
  rounded typeface is a web font). Both are made in the browser, not by
  R, and also work in a downloaded HTML file.

- **Margins**: equally small on all sides; plotly widens them
  automatically when axes, legend, or color bar do not fit, so no text
  is cut off.

What does not change: data, axis ranges and ticks, trace colors (other
than plotly's default colors), marker shapes, line widths and dashes,
opacity, hover text, legend text, the text of titles and axis titles
(only bold is added), chart height and width, and `shapes` (other than
kits' small-chart frames; for example, the gray band in fit plots).

**Order when used with kits and kitsUI**: kits'
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) → kitsUI
recoloring (`kit_chart_categorical()`, `kit_chart_role()`) → kitsUI
Chinese labels (`kit_chart_zh()`) → `kit_plotly_style()`. Recoloring and
this function can be swapped (this function does not touch set colors),
but **Chinese labels must come first**: this function wraps the title in
`<b>`, after which `kit_chart_zh()` no longer recognizes the original
English title. Applying it twice to the same chart is the same as
applying it once.

## See also

[`kit_plotly_fonts()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_fonts.md),
[`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_colors.md),
[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md)

## Examples

``` r
if (requireNamespace("plotly", quietly = TRUE)) {
  d <- data.frame(wave = rep(c(3, 6, 12), 2), score = c(8, 11, 15, 7, 10, 13),
                  cohort = rep(c("M03", "M36"), each = 3))
  p <- plotly::plot_ly(d, x = ~wave, y = ~score, split = ~cohort,
                       type = "scatter", mode = "lines+markers")
  p <- plotly::layout(p, title = "各世代的分數中位數")
  kit_plotly_style(p)
}

{"x":{"visdat":{"18f21f587fe1":["function () ","plotlyVisDat"]},"cur_data":"18f21f587fe1","attrs":{"18f21f587fe1":{"x":{},"y":{},"mode":"lines+markers","split":{},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter"}},"layout":{"margin":{"l":12,"r":12,"b":12,"t":47,"pad":0},"title":{"text":"<b>各世代的分數中位數<\/b>","x":0,"xanchor":"left","xref":"container","y":1,"yanchor":"top","yref":"container","pad":{"l":14,"r":14,"t":14,"b":0},"font":{"family":"\"Chiron GoRound TC\", sans-serif","size":18,"color":"#141414"}},"xaxis":{"domain":[0,1],"automargin":true,"title":{"text":"wave","font":{"family":"\"Chiron GoRound TC\", sans-serif","size":15,"color":"#141414"}},"showline":true,"mirror":false,"linecolor":"#141414","linewidth":1.5,"ticks":"outside","ticklen":5,"tickwidth":1,"tickcolor":"#141414","gridcolor":"#e3ded2","gridwidth":1,"zerolinecolor":"#d9d4c5","zerolinewidth":1,"tickfont":{"family":"\"Chiron GoRound TC\", sans-serif","size":13,"color":"#5a5a5a"}},"yaxis":{"domain":[0,1],"automargin":true,"title":{"text":"score","font":{"family":"\"Chiron GoRound TC\", sans-serif","size":15,"color":"#141414"}},"showline":true,"mirror":false,"linecolor":"#141414","linewidth":1.5,"ticks":"outside","ticklen":5,"tickwidth":1,"tickcolor":"#141414","gridcolor":"#e3ded2","gridwidth":1,"zerolinecolor":"#d9d4c5","zerolinewidth":1,"tickfont":{"family":"\"Chiron GoRound TC\", sans-serif","size":13,"color":"#5a5a5a"}},"hovermode":"closest","showlegend":true,"font":{"family":"\"Chiron GoRound TC\", sans-serif","size":15,"color":"#141414"},"paper_bgcolor":"#FFFFFF","plot_bgcolor":"#FFFFFF","colorway":["#0072B2","#E69F00","#009E73","#CC79A7","#56B4E9","#D55E00"],"hoverlabel":{"bgcolor":"#FFFFFF","bordercolor":"#141414","align":"left","font":{"family":"\"Chiron GoRound TC\", sans-serif","size":14,"color":"#141414"}},"legend":{"font":{"family":"\"Chiron GoRound TC\", sans-serif","size":14,"color":"#141414"},"bgcolor":"rgba(255,255,255,0)","borderwidth":0,"orientation":"v","x":1.02,"xanchor":"left","xref":"paper","y":1,"yanchor":"top","yref":"paper"}},"source":"A","config":{"showSendToCloud":false,"locale":"zh-TW","modeBarButtons":[[{"name":"kit_save_png","title":"下載 PNG（7 吋寬、300 dpi）","icon":"Plotly.Icons.camera","click":"function(gd) {\n  var FMT = 'png', WIDTH = 2100, DPI = 300;\n  var o = gd._context.toImageButtonOptions || {}, name = (o.filename || 'plot') + '.' + FMT;\n  var w = gd._fullLayout.width, h = gd._fullLayout.height;\n  var opts = {format: FMT, width: w, height: h};\n  if (FMT === 'png') opts.scale = WIDTH / w;\n  function crc32(b) {\n    var c = 0xFFFFFFFF;\n    for (var i = 0; i < b.length; i++) {\n      c ^= b[i];\n      for (var k = 0; k < 8; k++) c = (c & 1) ? (c >>> 1) ^ 0xEDB88320 : c >>> 1;\n    }\n    return (c ^ 0xFFFFFFFF) >>> 0;\n  }\n  // PNG pHYs chunk (pixels per metre) right after IHDR; drop any existing one\n  function withDpi(png) {\n    var ppm = Math.round(DPI / 0.0254), d = new Uint8Array(21), v = new DataView(d.buffer);\n    v.setUint32(0, 9); d.set([112, 72, 89, 115], 4); v.setUint32(8, ppm); v.setUint32(12, ppm);\n    d[16] = 1; v.setUint32(17, crc32(d.subarray(4, 17)));\n    var parts = [png.subarray(0, 8)], dv = new DataView(png.buffer), p = 8;\n    while (p + 8 <= png.length) {\n      var end = p + 12 + dv.getUint32(p);\n      var type = String.fromCharCode(png[p + 4], png[p + 5], png[p + 6], png[p + 7]);\n      if (type !== 'pHYs') parts.push(png.subarray(p, end));\n      if (type === 'IHDR') parts.push(d);\n      p = end;\n    }\n    return parts;\n  }\n  Plotly.toImage(gd, opts)\n    .then(function(url) { return fetch(url); })\n    .then(function(r) { return r.arrayBuffer(); })\n    .then(function(buf) {\n      var bytes = new Uint8Array(buf);\n      var blob = new Blob(FMT === 'png' ? withDpi(bytes) : [bytes],\n                          {type: FMT === 'png' ? 'image/png' : 'image/svg+xml'});\n      var href = URL.createObjectURL(blob), a = document.createElement('a');\n      a.href = href;\n      a.download = name;\n      a.click();\n      setTimeout(function() { URL.revokeObjectURL(href); }, 60000);\n    })\n    .catch(function(e) { if (window.console) console.error(e); });\n}"},{"name":"kit_save_svg","title":"下載 SVG 向量圖（文字用電腦裡有的字型）","icon":"(Plotly.Icons.drawopenpath || Plotly.Icons.disk)","click":"function(gd) {\n  var FMT = 'svg', WIDTH = 2100, DPI = 300;\n  var o = gd._context.toImageButtonOptions || {}, name = (o.filename || 'plot') + '.' + FMT;\n  var w = gd._fullLayout.width, h = gd._fullLayout.height;\n  var opts = {format: FMT, width: w, height: h};\n  if (FMT === 'png') opts.scale = WIDTH / w;\n  function crc32(b) {\n    var c = 0xFFFFFFFF;\n    for (var i = 0; i < b.length; i++) {\n      c ^= b[i];\n      for (var k = 0; k < 8; k++) c = (c & 1) ? (c >>> 1) ^ 0xEDB88320 : c >>> 1;\n    }\n    return (c ^ 0xFFFFFFFF) >>> 0;\n  }\n  // PNG pHYs chunk (pixels per metre) right after IHDR; drop any existing one\n  function withDpi(png) {\n    var ppm = Math.round(DPI / 0.0254), d = new Uint8Array(21), v = new DataView(d.buffer);\n    v.setUint32(0, 9); d.set([112, 72, 89, 115], 4); v.setUint32(8, ppm); v.setUint32(12, ppm);\n    d[16] = 1; v.setUint32(17, crc32(d.subarray(4, 17)));\n    var parts = [png.subarray(0, 8)], dv = new DataView(png.buffer), p = 8;\n    while (p + 8 <= png.length) {\n      var end = p + 12 + dv.getUint32(p);\n      var type = String.fromCharCode(png[p + 4], png[p + 5], png[p + 6], png[p + 7]);\n      if (type !== 'pHYs') parts.push(png.subarray(p, end));\n      if (type === 'IHDR') parts.push(d);\n      p = end;\n    }\n    return parts;\n  }\n  Plotly.toImage(gd, opts)\n    .then(function(url) { return fetch(url); })\n    .then(function(r) { return r.arrayBuffer(); })\n    .then(function(buf) {\n      var bytes = new Uint8Array(buf);\n      var blob = new Blob(FMT === 'png' ? withDpi(bytes) : [bytes],\n                          {type: FMT === 'png' ? 'image/png' : 'image/svg+xml'});\n      var href = URL.createObjectURL(blob), a = document.createElement('a');\n      a.href = href;\n      a.download = name;\n      a.click();\n      setTimeout(function() { URL.revokeObjectURL(href); }, 60000);\n    })\n    .catch(function(e) { if (window.console) console.error(e); });\n}"},"zoomIn2d","zoomOut2d","resetScale2d"]],"displaylogo":false,"toImageButtonOptions":{"format":"png","filename":"kit-chart"}},"data":[{"x":[3,6,12],"y":[8,11,15],"mode":"lines+markers","type":"scatter","name":"M03","marker":{"color":"rgba(0,114,178,1)","line":{"color":"rgba(0,114,178,1)"}},"error_y":{"color":"rgba(0,114,178,1)"},"error_x":{"color":"rgba(0,114,178,1)"},"line":{"color":"rgba(0,114,178,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[3,6,12],"y":[7,10,13],"mode":"lines+markers","type":"scatter","name":"M36","marker":{"color":"rgba(230,159,0,1)","line":{"color":"rgba(230,159,0,1)"}},"error_y":{"color":"rgba(230,159,0,1)"},"error_x":{"color":"rgba(230,159,0,1)"},"line":{"color":"rgba(230,159,0,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":["config.modeBarButtons.0.0.icon","config.modeBarButtons.0.0.click","config.modeBarButtons.0.1.icon","config.modeBarButtons.0.1.click"],"jsHooks":{"render":[{"code":"function(el, x, d) {\n  var gd = el;\n  gd._kitStyle = d;\n  function wrap(text, maxw, font) {\n    var ctx = gd._kitCtx || (gd._kitCtx = document.createElement('canvas').getContext('2d'));\n    ctx.font = font;\n    if (ctx.measureText(text).width <= maxw) return [text];\n    var toks = text.match(/[A-Za-z0-9_.,:;!?%+\\-\\/'=]+|\\s+|[\\s\\S]/g) || [text];\n    var closing = /^[\\uFF09\\uFF0C\\u3001\\u3002\\uFF1A\\uFF1B\\u300D\\)\\],.:;]/;\n    var opening = /[\\uFF08\\u300C(\\[]$/;\n    var out = [], cur = '';\n    for (var i = 0; i < toks.length; i++) {\n      var t = toks[i];\n      if (cur.trim() && !closing.test(t) && ctx.measureText(cur + t).width > maxw) {\n        var carry = '';\n        if (opening.test(cur) && cur.length > 1) { carry = cur.slice(-1); cur = cur.slice(0, -1); }\n        out.push(cur.replace(/\\s+$/, ''));\n        cur = carry + t.replace(/^\\s+/, '');\n      } else {\n        cur += t;\n      }\n    }\n    if (cur.trim()) out.push(cur.replace(/\\s+$/, ''));\n    return out.length ? out : [text];\n  }\n  function apply() {\n    var d = gd._kitStyle, L = gd.layout;\n    if (!d || !L || !window.Plotly) return;\n    var w = gd.clientWidth;\n    if (!w) return;\n    var upd = {};\n    if (d.legend) {\n      var wantH = d.bottom || w < d.narrow;\n      var isH = !!(L.legend && L.legend.orientation === 'h');\n      if (wantH !== isH) {\n        var src = wantH ? d.legend_h : d.legend_v;\n        for (var k in src) upd[k] = src[k];\n      }\n    }\n    if (d.title && d.title.main) {\n      var t = d.title;\n      var lines = wrap(t.main, w - 2 * t.pad - 4, t.font);\n      var text = lines.map(function(s) { return '<b>' + s + '<\/b>'; }).join('<br>') +\n        (t.rest ? '<br>' + t.rest : '');\n      if (!L.title || L.title.text !== text) {\n        upd['title.text'] = text;\n        upd['margin.t'] = t.fixed + t.line * lines.length;\n        upd['title.pad.t'] = t.pad + Math.round((lines.length + t.rest_lines - 1) * t.line / 2);\n      }\n    }\n    // automargin puts axis titles and the legend flush against the edge: leave d.gap px\n    var pm = (gd._fullLayout && gd._fullLayout._pushmargin) || {};\n    var need = {l: 0, b: 0};\n    for (var id in pm) {\n      if (id === 'base' || !pm[id]) continue;\n      ['l', 'b'].forEach(function(s) {\n        var v = pm[id][s];\n        if (v && v.size && (v.val || 0) <= 0.01) need[s] = Math.max(need[s], v.size);\n      });\n    }\n    ['l', 'b'].forEach(function(s) {\n      var want = Math.max(d.base[s], Math.ceil(need[s] + d.gap));\n      var cur = (L.margin && L.margin[s]) || 0;\n      if (need[s] > 0 && Math.abs(cur - want) > 1) upd['margin.' + s] = want;\n    });\n    if (Object.keys(upd).length) window.Plotly.relayout(gd, upd);\n  }\n  gd._kitApply = apply;\n  var timer = null;\n  var later = function() {\n    clearTimeout(timer);\n    timer = setTimeout(function() { if (gd._kitApply) gd._kitApply(); }, 80);\n  };\n  if (!gd._kitBound) {\n    gd._kitBound = true;\n    if (window.ResizeObserver) new ResizeObserver(later).observe(gd);\n    else window.addEventListener('resize', later);\n    if (document.fonts && document.fonts.ready) document.fonts.ready.then(later);\n  }\n  // Plotly.newPlot drops event listeners: bind again on every render\n  if (gd.on) {\n    if (gd._kitAfter && gd.removeListener) gd.removeListener('plotly_afterplot', gd._kitAfter);\n    gd._kitAfter = later;\n    gd.on('plotly_afterplot', later);\n  }\n  apply();\n}","data":{"narrow":600,"base":{"l":12,"b":12},"gap":16,"legend":true,"bottom":false,"legend_h":{"legend.orientation":"h","legend.x":0,"legend.xanchor":"left","legend.xref":"paper","legend.y":0,"legend.yanchor":"bottom","legend.yref":"container"},"legend_v":{"legend.orientation":"v","legend.x":1.02,"legend.xanchor":"left","legend.xref":"paper","legend.y":1,"legend.yanchor":"top","legend.yref":"paper"},"title":{"main":"各世代的分數中位數","rest":"","pad":14,"font":"bold 18px \"Chiron GoRound TC\", sans-serif","fixed":24,"line":23,"rest_lines":0}}}]}}
```
