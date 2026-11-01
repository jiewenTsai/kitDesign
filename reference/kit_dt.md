# Interactive table (DT) with the KIT look

For tables people search, page through, and click: search results, item
lists to edit. Same look as
[`kit_static_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_static_table.md):
2px frame, black header with white text, zebra stripes, `small` type,
numbers right-aligned; a selected row is light lime (`bg-new`), not
blue. Text is in Traditional Chinese ("共 37 列，第 1–20 列", "上一頁",
"下一頁"); the page buttons look like small buttons. Width fits the
content; on a phone a wide table scrolls sideways inside its own box,
never the page.

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

  A data.frame. Column names stay as they are (data and function output
  keep their English names).

- selection:

  `"none"`, `"single"`, or `"multiple"` (click to select rows). A list
  is passed to `DT::datatable(selection = )` as it is (for example with
  `selected = `).

- page_length:

  Rows per page. 0 shows all rows (no paging).

- search:

  Show the table's own search box. Usually `FALSE`: the page has its own
  conditions.

- wrap_cols:

  Columns whose long text wraps (for example the item text); other
  columns do not wrap.

- min_widths:

  Named vector of minimum column widths in CSS units, for example
  `c(label = "24rem")`.

- ordering:

  Click the header to sort.

- options:

  More DataTables options (override the defaults). `columnDefs` given
  here come first, so they win over the ones `kit_dt()` makes.

- ...:

  Passed to
  [`DT::datatable()`](https://rdrr.io/pkg/DT/man/datatable.html).

## Value

A `datatables` htmlwidget with class `kit-dt`.

## Details

Use it inside
[`DT::renderDT()`](https://rdrr.io/pkg/DT/man/dataTableOutput.html).
'DT' is in Suggests: the app itself needs `Imports: DT`. For short
result tables that need no paging, use
[`kit_static_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_static_table.md).

## See also

[`kit_static_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_static_table.md)
for short result tables,
[`kit_table_scroll()`](https://jiewentsai.github.io/kitDesign/reference/kit_table_scroll.md).

## Examples

``` r
if (requireNamespace("DT", quietly = TRUE)) {
  kit_dt(data.frame(itemID = c("a1", "a2"), label = c("睡眠時間", "午睡")),
         selection = "single", wrap_cols = "label")
}

{"x":{"filter":"none","vertical":false,"data":[["a1","a2"],["睡眠時間","午睡"]],"container":"<table class=\"kit-dt compact kit-dt-selectable\">\n  <thead>\n    <tr>\n      <th>itemID<\/th>\n      <th>label<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"<\"kit-dt-box\"<\"kit-dt-scroll\"t><\"kit-dt-foot\"ip>>","pageLength":20,"paging":true,"ordering":true,"autoWidth":false,"language":{"info":"共 _TOTAL_ 列，第 _START_–_END_ 列","infoEmpty":"共 0 列","infoFiltered":"（從 _MAX_ 列篩出）","search":"搜尋：","zeroRecords":"沒有符合的資料","emptyTable":"沒有符合的資料","thousands":",","paginate":{"previous":"上一頁","next":"下一頁","first":"第一頁","last":"最後一頁"},"aria":{"sortAscending":"：按一下由小到大排序","sortDescending":"：按一下由大到小排序"}},"columnDefs":[{"targets":0,"className":"kit-dt-nowrap"},{"targets":1,"className":"kit-dt-wrap"},{"name":"itemID","targets":0},{"name":"label","targets":1}],"order":[],"orderClasses":false,"lengthMenu":[10,20,25,50,100]},"selection":{"mode":"single","selected":null,"target":"row","selectable":null}},"evals":[],"jsHooks":[]}
```
