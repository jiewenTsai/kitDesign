# 互動資料表（DT），KIT 的樣子

給要搜尋、換頁、點選的表：搜尋結果、要編輯的題目清單。 和
[`kit_static_table()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_static_table.md)
同一個樣子：2px 框、黑表頭白字、斑馬紋、`small` 字級、數字靠右；
選到的列是淡萊姆（`bg-new`），不是藍色。文字是中文（「共 37 列，第 1–20
列」「上一頁」「下一頁」）；
換頁按鈕長得像小按鈕。寬度跟著內容；手機上太寬的表在自己的框裡左右捲，整頁不左右捲。

## Usage

``` r
kit_dt(
  df,
  selection = "none",
  page_length = 20L,
  search = FALSE,
  wrap_cols = NULL,
  min_widths = NULL,
  ordering = TRUE,
  options = list(),
  ...
)
```

## Arguments

- df:

  data.frame。欄名照原樣（資料與函式的輸出維持英文欄名）。

- selection:

  `"none"`、`"single"` 或 `"multiple"`（點一下選列）。給 list
  時照原樣交給 `DT::datatable(selection = )`（例如加上 `selected = `）。

- page_length:

  一頁幾列。0 是全部顯示（不分頁）。

- search:

  顯示表自己的搜尋框。通常是 `FALSE`：頁面有自己的條件。

- wrap_cols:

  長文字要換行的欄（例如題目文字）；其他欄不換行。

- min_widths:

  欄的最小寬度（CSS 單位），有名字的向量，例如 `c(label = "24rem")`。

- ordering:

  點表頭排序。

- options:

  其他 DataTables 選項（蓋過預設值）。這裡給的 `columnDefs` 排在前面，比
  `kit_dt()` 做的優先。

- ...:

  交給 [`DT::datatable()`](https://rdrr.io/pkg/DT/man/datatable.html)。

## Value

class 有 `kit-dt` 的 `datatables` htmlwidget。

## Details

放在 [`DT::renderDT()`](https://rdrr.io/pkg/DT/man/dataTableOutput.html)
裡。DT 在 kitDesign 的 Suggests：app 自己要 `Imports: DT`。
不用換頁的短結果表用
[`kit_static_table()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_static_table.md)。

## See also

短的結果表用
[`kit_static_table()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_static_table.md)；[`kit_table_scroll()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_table_scroll.md)。

## Examples

``` r
if (requireNamespace("DT", quietly = TRUE)) {
  kit_dt(data.frame(itemID = c("a1", "a2"), label = c("睡眠時間", "午睡")),
         selection = "single", wrap_cols = "label")
}

{"x":{"filter":"none","vertical":false,"data":[["a1","a2"],["睡眠時間","午睡"]],"container":"<table class=\"kit-dt compact kit-dt-selectable\">\n  <thead>\n    <tr>\n      <th>itemID<\/th>\n      <th>label<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"<\"kit-dt-box\"<\"kit-dt-scroll\"t><\"kit-dt-foot\"ip>>","pageLength":20,"paging":true,"ordering":true,"autoWidth":false,"language":{"info":"共 _TOTAL_ 列，第 _START_–_END_ 列","infoEmpty":"共 0 列","infoFiltered":"（從 _MAX_ 列篩出）","search":"搜尋：","zeroRecords":"沒有符合的資料","emptyTable":"沒有符合的資料","thousands":",","paginate":{"previous":"上一頁","next":"下一頁","first":"第一頁","last":"最後一頁"},"aria":{"sortAscending":"：按一下由小到大排序","sortDescending":"：按一下由大到小排序"}},"columnDefs":[{"targets":0,"className":"kit-dt-nowrap"},{"targets":1,"className":"kit-dt-wrap"},{"name":"itemID","targets":0},{"name":"label","targets":1}],"order":[],"orderClasses":false,"lengthMenu":[10,20,25,50,100]},"selection":{"mode":"single","selected":null,"target":"row","selectable":null}},"evals":[],"jsHooks":[]}
```
