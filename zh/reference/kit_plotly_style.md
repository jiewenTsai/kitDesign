# plotly 圖套上 KIT 的樣子（Chart）

讓 plotly 圖和 app 的其他部分看起來是一套：字型、字級、顏色都用 KIT
的設計變數。 只改樣子，不改資料（點、線、軸的範圍、刻度的位置、hover
的文字都不動）。

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

  plotly
  圖（[`plotly::plot_ly()`](https://rdrr.io/pkg/plotly/man/plot_ly.html)、kits
  的
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html)；[`plotly::plotly_build()`](https://rdrr.io/pkg/plotly/man/plotly_build.html)
  過的也可以）。

- legend:

  圖例放哪裡：

  - `"auto"`（預設）：超過 4 項，或最長的一項超過 20 欄（中文字算 2
    欄）時放在圖的下面、橫排、 靠左；其他放在右邊。圖寬小於
    600px（手機）時也放到下面，變寬時回到右邊（瀏覽器端判斷）。

  - `"bottom"`：一律在下面；`"right"`：一律在右邊。

  - `"keep"`：不動圖例的位置（只換字型）。

- colorscale:

  `TRUE`（預設）時熱圖類換成
  [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_sequential.md)；`FALSE`
  時保留原來的色階。

- fonts:

  `TRUE`（預設）時附上 Google Fonts
  的圓體（[`kit_plotly_fonts()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_fonts.md)），
  下載的單一 HTML 檔也是 app 的字型。

- filename:

  工具列「下載 PNG」、「下載 SVG」的檔名（不含副檔名）。

- font_size:

  內文字級（px）；其他字級跟著它算。

- brand:

  品牌（[`kit_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_brand.md)）：熱圖的色階從它來（[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_sequential.md)）。
  預設是
  [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_current_brand.md)（沒有設定時是
  KIT）。字、軸線、底色維持設計語言的墨色與白色。

## Value

plotly 圖（`plotly_build()` 過的）。

## Details

改的地方：

- **字型**：全部用 app 的圓體 `"Chiron GoRound TC", sans-serif`；字是
  `nb-ink`（#141414）， 刻度是 `text-hint`（#5a5a5a）。字級：內文
  `font_size`（預設 15px）、圖例與滑過的說明框小 1px、 刻度小
  2px、標題約 `h5`（`font_size` 的 1.2 倍）。

- **標題**：靠左、粗體。圖寬放不下時在瀏覽器端換行（在中文字或空白之間斷開）。

- **每一條軸**（`xaxis`、`xaxis2`…、`yaxis`…，包括 Wright map
  這類並排的小圖）： 軸線 `nb-ink` 1.5px、格線
  `line-soft`（#e3ded2）、零線 `line`（#d9d4c5）、
  刻度朝外；不畫四邊的框（`mirror = FALSE`，並拿掉 kits
  畫在每個小圖外面的黑框； KIT
  設計語言：框裡面不再有框）。軸的標題與刻度放不下時自動加寬邊界（`automargin`）。

- **底色**：白（圖放在白色卡片裡）；下載的 PNG、SVG 也是白底。

- **顏色**：`colorway` 是
  Okabe–Ito（[`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_colors.md)）。plotly
  自己給的預設色換成 Okabe–Ito 同一個位置的顏色；**kits 或 kitsUI
  指定的顏色不動**（kitsUI 的角色色、 類別換色都保留）。

- **色階**（`colorscale = TRUE`）：熱圖類（heatmap、contour、histogram2d）換成
  [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_sequential.md)（極淡萊姆
  → 淡萊姆 → KIT 綠）；色條的字、外框一律換樣子。

- **滑過的說明框**：白底、`nb-ink` 框、app 的字型。

- **圖例**：app 的字型、沒有框。位置見 `legend`。

- **工具列**：沒有 plotly 的標誌；只留「下載 PNG」、「下載
  SVG」、放大、縮小、 回到原來的範圍；介面文字是繁體中文（`zh-TW`）。PNG
  一律 2100 像素寬（7 吋、300 dpi；長寬比照畫面）， 檔案裡寫 300
  dpi，插進 Word 預設就是 7 吋寬。SVG 是向量圖，給要 600 dpi 以上、EPS
  或 PDF 的期刊；
  文字用打開它的電腦裡有的字型（圓體是網頁字型）。兩個都在瀏覽器裡做，不經過
  R；下載的 HTML 檔裡也能用。

- **邊界**：上下左右一樣小，軸、圖例、色條放不下時 plotly
  自動加寬；不會切到字。

不改的地方：資料、軸的範圍與刻度、trace 的顏色（plotly
的預設色以外）、點的形狀、線的 粗細與虛線、透明度、hover
的文字、圖例的文字、標題與軸標題的文字（只加粗體）、
圖的高度與寬度、`shapes`（kits 的小圖外框以外，例如適配度圖的灰色帶）。

**和 kits、kitsUI 一起用時的順序**：kits 的
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) → kitsUI 換色
（`kit_chart_categorical()`、`kit_chart_role()`）→ kitsUI
換中文（`kit_chart_zh()`）→
`kit_plotly_style()`。換色和這個函式的順序可以對調（這裡不動指定的顏色），但**換中文要在前面**：
這裡把標題加上 `<b>`，之後 `kit_chart_zh()` 就認不得原來的英文標題了。
同一張圖套兩次和套一次一樣。

## See also

[`kit_plotly_fonts()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_fonts.md)、[`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_colors.md)、[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_sequential.md)

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

{"x":{"visdat":{"19a32471e200":["function () ","plotlyVisDat"]},"cur_data":"19a32471e200","attrs":{"19a32471e200":{"x":{},"y":{},"mode":"lines+markers","split":{},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter"}},"layout":{"margin":{"l":12,"r":12,"b":12,"t":47,"pad":0},"title":{"text":"<b>各世代的分數中位數<\/b>","x":0,"xanchor":"left","xref":"container","y":1,"yanchor":"top","yref":"container","pad":{"l":14,"r":14,"t":14,"b":0},"font":{"family":"\"Chiron GoRound TC\", sans-serif","size":18,"color":"#141414"}},"xaxis":{"domain":[0,1],"automargin":true,"title":{"text":"wave","font":{"family":"\"Chiron GoRound TC\", sans-serif","size":15,"color":"#141414"}},"showline":true,"mirror":false,"linecolor":"#141414","linewidth":1.5,"ticks":"outside","ticklen":5,"tickwidth":1,"tickcolor":"#141414","gridcolor":"#e3ded2","gridwidth":1,"zerolinecolor":"#d9d4c5","zerolinewidth":1,"tickfont":{"family":"\"Chiron GoRound TC\", sans-serif","size":13,"color":"#5a5a5a"}},"yaxis":{"domain":[0,1],"automargin":true,"title":{"text":"score","font":{"family":"\"Chiron GoRound TC\", sans-serif","size":15,"color":"#141414"}},"showline":true,"mirror":false,"linecolor":"#141414","linewidth":1.5,"ticks":"outside","ticklen":5,"tickwidth":1,"tickcolor":"#141414","gridcolor":"#e3ded2","gridwidth":1,"zerolinecolor":"#d9d4c5","zerolinewidth":1,"tickfont":{"family":"\"Chiron GoRound TC\", sans-serif","size":13,"color":"#5a5a5a"}},"hovermode":"closest","showlegend":true,"font":{"family":"\"Chiron GoRound TC\", sans-serif","size":15,"color":"#141414"},"paper_bgcolor":"#FFFFFF","plot_bgcolor":"#FFFFFF","colorway":["#0072B2","#E69F00","#009E73","#CC79A7","#56B4E9","#D55E00"],"hoverlabel":{"bgcolor":"#FFFFFF","bordercolor":"#141414","align":"left","font":{"family":"\"Chiron GoRound TC\", sans-serif","size":14,"color":"#141414"}},"legend":{"font":{"family":"\"Chiron GoRound TC\", sans-serif","size":14,"color":"#141414"},"bgcolor":"rgba(255,255,255,0)","borderwidth":0,"orientation":"v","x":1.02,"xanchor":"left","xref":"paper","y":1,"yanchor":"top","yref":"paper"}},"source":"A","config":{"showSendToCloud":false,"locale":"zh-TW","modeBarButtons":[[{"name":"kit_save_png","title":"下載 PNG（7 吋寬、300 dpi）","icon":"Plotly.Icons.camera","click":"function(gd) {\n  var FMT = 'png', WIDTH = 2100, DPI = 300;\n  var o = gd._context.toImageButtonOptions || {}, name = (o.filename || 'plot') + '.' + FMT;\n  var w = gd._fullLayout.width, h = gd._fullLayout.height;\n  var opts = {format: FMT, width: w, height: h};\n  if (FMT === 'png') opts.scale = WIDTH / w;\n  function crc32(b) {\n    var c = 0xFFFFFFFF;\n    for (var i = 0; i < b.length; i++) {\n      c ^= b[i];\n      for (var k = 0; k < 8; k++) c = (c & 1) ? (c >>> 1) ^ 0xEDB88320 : c >>> 1;\n    }\n    return (c ^ 0xFFFFFFFF) >>> 0;\n  }\n  // PNG pHYs chunk (pixels per metre) right after IHDR; drop any existing one\n  function withDpi(png) {\n    var ppm = Math.round(DPI / 0.0254), d = new Uint8Array(21), v = new DataView(d.buffer);\n    v.setUint32(0, 9); d.set([112, 72, 89, 115], 4); v.setUint32(8, ppm); v.setUint32(12, ppm);\n    d[16] = 1; v.setUint32(17, crc32(d.subarray(4, 17)));\n    var parts = [png.subarray(0, 8)], dv = new DataView(png.buffer), p = 8;\n    while (p + 8 <= png.length) {\n      var end = p + 12 + dv.getUint32(p);\n      var type = String.fromCharCode(png[p + 4], png[p + 5], png[p + 6], png[p + 7]);\n      if (type !== 'pHYs') parts.push(png.subarray(p, end));\n      if (type === 'IHDR') parts.push(d);\n      p = end;\n    }\n    return parts;\n  }\n  Plotly.toImage(gd, opts)\n    .then(function(url) { return fetch(url); })\n    .then(function(r) { return r.arrayBuffer(); })\n    .then(function(buf) {\n      var bytes = new Uint8Array(buf);\n      var blob = new Blob(FMT === 'png' ? withDpi(bytes) : [bytes],\n                          {type: FMT === 'png' ? 'image/png' : 'image/svg+xml'});\n      var href = URL.createObjectURL(blob), a = document.createElement('a');\n      a.href = href;\n      a.download = name;\n      a.click();\n      setTimeout(function() { URL.revokeObjectURL(href); }, 60000);\n    })\n    .catch(function(e) { if (window.console) console.error(e); });\n}"},{"name":"kit_save_svg","title":"下載 SVG 向量圖（文字用電腦裡有的字型）","icon":"(Plotly.Icons.drawopenpath || Plotly.Icons.disk)","click":"function(gd) {\n  var FMT = 'svg', WIDTH = 2100, DPI = 300;\n  var o = gd._context.toImageButtonOptions || {}, name = (o.filename || 'plot') + '.' + FMT;\n  var w = gd._fullLayout.width, h = gd._fullLayout.height;\n  var opts = {format: FMT, width: w, height: h};\n  if (FMT === 'png') opts.scale = WIDTH / w;\n  function crc32(b) {\n    var c = 0xFFFFFFFF;\n    for (var i = 0; i < b.length; i++) {\n      c ^= b[i];\n      for (var k = 0; k < 8; k++) c = (c & 1) ? (c >>> 1) ^ 0xEDB88320 : c >>> 1;\n    }\n    return (c ^ 0xFFFFFFFF) >>> 0;\n  }\n  // PNG pHYs chunk (pixels per metre) right after IHDR; drop any existing one\n  function withDpi(png) {\n    var ppm = Math.round(DPI / 0.0254), d = new Uint8Array(21), v = new DataView(d.buffer);\n    v.setUint32(0, 9); d.set([112, 72, 89, 115], 4); v.setUint32(8, ppm); v.setUint32(12, ppm);\n    d[16] = 1; v.setUint32(17, crc32(d.subarray(4, 17)));\n    var parts = [png.subarray(0, 8)], dv = new DataView(png.buffer), p = 8;\n    while (p + 8 <= png.length) {\n      var end = p + 12 + dv.getUint32(p);\n      var type = String.fromCharCode(png[p + 4], png[p + 5], png[p + 6], png[p + 7]);\n      if (type !== 'pHYs') parts.push(png.subarray(p, end));\n      if (type === 'IHDR') parts.push(d);\n      p = end;\n    }\n    return parts;\n  }\n  Plotly.toImage(gd, opts)\n    .then(function(url) { return fetch(url); })\n    .then(function(r) { return r.arrayBuffer(); })\n    .then(function(buf) {\n      var bytes = new Uint8Array(buf);\n      var blob = new Blob(FMT === 'png' ? withDpi(bytes) : [bytes],\n                          {type: FMT === 'png' ? 'image/png' : 'image/svg+xml'});\n      var href = URL.createObjectURL(blob), a = document.createElement('a');\n      a.href = href;\n      a.download = name;\n      a.click();\n      setTimeout(function() { URL.revokeObjectURL(href); }, 60000);\n    })\n    .catch(function(e) { if (window.console) console.error(e); });\n}"},"zoomIn2d","zoomOut2d","resetScale2d"]],"displaylogo":false,"toImageButtonOptions":{"format":"png","filename":"kit-chart"}},"data":[{"x":[3,6,12],"y":[8,11,15],"mode":"lines+markers","type":"scatter","name":"M03","marker":{"color":"rgba(0,114,178,1)","line":{"color":"rgba(0,114,178,1)"}},"error_y":{"color":"rgba(0,114,178,1)"},"error_x":{"color":"rgba(0,114,178,1)"},"line":{"color":"rgba(0,114,178,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[3,6,12],"y":[7,10,13],"mode":"lines+markers","type":"scatter","name":"M36","marker":{"color":"rgba(230,159,0,1)","line":{"color":"rgba(230,159,0,1)"}},"error_y":{"color":"rgba(230,159,0,1)"},"error_x":{"color":"rgba(230,159,0,1)"},"line":{"color":"rgba(230,159,0,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":["config.modeBarButtons.0.0.icon","config.modeBarButtons.0.0.click","config.modeBarButtons.0.1.icon","config.modeBarButtons.0.1.click"],"jsHooks":{"render":[{"code":"function(el, x, d) {\n  var gd = el;\n  gd._kitStyle = d;\n  function wrap(text, maxw, font) {\n    var ctx = gd._kitCtx || (gd._kitCtx = document.createElement('canvas').getContext('2d'));\n    ctx.font = font;\n    if (ctx.measureText(text).width <= maxw) return [text];\n    var toks = text.match(/[A-Za-z0-9_.,:;!?%+\\-\\/'=]+|\\s+|[\\s\\S]/g) || [text];\n    var closing = /^[\\uFF09\\uFF0C\\u3001\\u3002\\uFF1A\\uFF1B\\u300D\\)\\],.:;]/;\n    var opening = /[\\uFF08\\u300C(\\[]$/;\n    var out = [], cur = '';\n    for (var i = 0; i < toks.length; i++) {\n      var t = toks[i];\n      if (cur.trim() && !closing.test(t) && ctx.measureText(cur + t).width > maxw) {\n        var carry = '';\n        if (opening.test(cur) && cur.length > 1) { carry = cur.slice(-1); cur = cur.slice(0, -1); }\n        out.push(cur.replace(/\\s+$/, ''));\n        cur = carry + t.replace(/^\\s+/, '');\n      } else {\n        cur += t;\n      }\n    }\n    if (cur.trim()) out.push(cur.replace(/\\s+$/, ''));\n    return out.length ? out : [text];\n  }\n  function apply() {\n    var d = gd._kitStyle, L = gd.layout;\n    if (!d || !L || !window.Plotly) return;\n    var w = gd.clientWidth;\n    if (!w) return;\n    var upd = {};\n    if (d.legend) {\n      var wantH = d.bottom || w < d.narrow;\n      var isH = !!(L.legend && L.legend.orientation === 'h');\n      if (wantH !== isH) {\n        var src = wantH ? d.legend_h : d.legend_v;\n        for (var k in src) upd[k] = src[k];\n      }\n    }\n    if (d.title && d.title.main) {\n      var t = d.title;\n      var lines = wrap(t.main, w - 2 * t.pad - 4, t.font);\n      var text = lines.map(function(s) { return '<b>' + s + '<\/b>'; }).join('<br>') +\n        (t.rest ? '<br>' + t.rest : '');\n      if (!L.title || L.title.text !== text) {\n        upd['title.text'] = text;\n        upd['margin.t'] = t.fixed + t.line * lines.length;\n        upd['title.pad.t'] = t.pad + Math.round((lines.length + t.rest_lines - 1) * t.line / 2);\n      }\n    }\n    // automargin puts axis titles and the legend flush against the edge: leave d.gap px\n    var pm = (gd._fullLayout && gd._fullLayout._pushmargin) || {};\n    var need = {l: 0, b: 0};\n    for (var id in pm) {\n      if (id === 'base' || !pm[id]) continue;\n      ['l', 'b'].forEach(function(s) {\n        var v = pm[id][s];\n        if (v && v.size && (v.val || 0) <= 0.01) need[s] = Math.max(need[s], v.size);\n      });\n    }\n    ['l', 'b'].forEach(function(s) {\n      var want = Math.max(d.base[s], Math.ceil(need[s] + d.gap));\n      var cur = (L.margin && L.margin[s]) || 0;\n      if (need[s] > 0 && Math.abs(cur - want) > 1) upd['margin.' + s] = want;\n    });\n    if (Object.keys(upd).length) window.Plotly.relayout(gd, upd);\n  }\n  gd._kitApply = apply;\n  var timer = null;\n  var later = function() {\n    clearTimeout(timer);\n    timer = setTimeout(function() { if (gd._kitApply) gd._kitApply(); }, 80);\n  };\n  if (!gd._kitBound) {\n    gd._kitBound = true;\n    if (window.ResizeObserver) new ResizeObserver(later).observe(gd);\n    else window.addEventListener('resize', later);\n    if (document.fonts && document.fonts.ready) document.fonts.ready.then(later);\n  }\n  // Plotly.newPlot drops event listeners: bind again on every render\n  if (gd.on) {\n    if (gd._kitAfter && gd.removeListener) gd.removeListener('plotly_afterplot', gd._kitAfter);\n    gd._kitAfter = later;\n    gd.on('plotly_afterplot', later);\n  }\n  apply();\n}","data":{"narrow":600,"base":{"l":12,"b":12},"gap":16,"legend":true,"bottom":false,"legend_h":{"legend.orientation":"h","legend.x":0,"legend.xanchor":"left","legend.xref":"paper","legend.y":0,"legend.yanchor":"bottom","legend.yref":"container"},"legend_v":{"legend.orientation":"v","legend.x":1.02,"legend.xanchor":"left","legend.xref":"paper","legend.y":1,"legend.yanchor":"top","legend.yref":"paper"},"title":{"main":"各世代的分數中位數","rest":"","pad":14,"font":"bold 18px \"Chiron GoRound TC\", sans-serif","fixed":24,"line":23,"rest_lines":0}}}]}}
```
