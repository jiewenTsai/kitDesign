# 預覽表的資料（交給 `shiny::renderTable()`）

欄位太多時只取前 `max_cols` 欄（優先保留 `priority_cols`），列只取前 `n`
列， 每一欄轉成方便閱讀的文字（值標籤寫成「`[值] 標籤`」、日期
yyyy-mm-dd）。 上面配一行
[`kit_rows_note()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_rows_note.md)。

## Usage

``` r
kit_preview_table(
  df,
  priority_cols = NULL,
  n = KIT_PREVIEW_ROWS,
  max_cols = KIT_PREVIEW_COLS
)
```

## Arguments

- df:

  data.frame。

- priority_cols:

  一定要放進預覽的欄（例如 ID 欄），排在最前面。

- n:

  最多幾列。

- max_cols:

  最多幾欄。

## Value

data.frame（全部是文字欄）。

## Examples

``` r
df <- as.data.frame(matrix(1:60, nrow = 2))
dim(kit_preview_table(df, priority_cols = "V30", n = 1))
#> [1]  1 20
```
