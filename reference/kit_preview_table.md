# Data for a preview table (pass to `shiny::renderTable()`)

With too many columns, only the first `max_cols` columns are kept
(`priority_cols` are kept first); only the first `n` rows are kept. Each
column is converted to easy-to-read text (value labels as
"`[value] label`", dates as yyyy-mm-dd). Put a
[`kit_rows_note()`](https://jiewentsai.github.io/kitDesign/reference/kit_rows_note.md)
line above it.

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

  A data.frame.

- priority_cols:

  Columns that must be in the preview (for example the ID column); they
  go first.

- n:

  Maximum number of rows.

- max_cols:

  Maximum number of columns.

## Value

A data.frame (all columns are text).

## Examples

``` r
df <- as.data.frame(matrix(1:60, nrow = 2))
dim(kit_preview_table(df, priority_cols = "V30", n = 1))
#> [1]  1 20
```
