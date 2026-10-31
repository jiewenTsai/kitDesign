# 檔案的小工具：編碼、SPSS 變項名稱、壓縮檔路徑、開啟瀏覽器

- `kit_fix_utf8_chr()`：文字轉成 UTF-8（轉不了的字換成
  `?`）；不是文字時原樣傳回。

- `kit_fix_utf8_df()`：資料框每個文字欄（與因子）轉成 UTF-8，保留 SAV
  的變項標籤與數值標籤。

- `kit_is_valid_utf8_df()`：欄名與文字欄是不是都是合法的 UTF-8。

- `kit_sav_safe_names()`：轉成合法的 SPSS 變項名稱（以
  `haven::write_sav()` 實測：只能有字母、 數字與
  `_ . @ # $`；開頭是字母或 `@`；不以 `.` 結尾；不是保留字；最長 64
  bytes； 不分大小寫不重複，重複的第二個起加 `_2`、`_3`）。

- `kit_truncate_bytes()`：依 UTF-8 位元組數截斷，不切斷中文字。

- `kit_gz_path()`：readr 看副檔名決定要不要解壓縮；路徑不是 `.gz`
  結尾時，複製成 `.gz` 結尾的暫存檔。

- `kit_open_browser()`：在預設瀏覽器開啟網址（Windows 上不受 RStudio
  檢視器影響）。

## Usage

``` r
kit_fix_utf8_chr(x)

kit_fix_utf8_df(df)

kit_is_valid_utf8_df(df)

kit_sav_safe_names(cols)

kit_truncate_bytes(x, max_bytes)

kit_gz_path(path)

kit_open_browser(url)
```

## Arguments

- x:

  文字向量（`kit_fix_utf8_chr()`）或一個字串（`kit_truncate_bytes()`）。

- df:

  資料框。

- cols:

  欄名。

- max_bytes:

  最多幾個位元組。

- path:

  檔案路徑。

- url:

  網址。

## Value

和輸入同類的物件；`kit_is_valid_utf8_df()` 是
`TRUE`／`FALSE`；`kit_open_browser()` 是 `NULL`。

## Examples

``` r
kit_sav_safe_names(c("1st wave", "AND", "id", "ID"))
#> [1] "v_1st_wave" "AND_"       "id"         "ID_2"      
kit_truncate_bytes(strrep("測", 30), 64)
#> [1] "測測測測測測測測測測測測測測測測測測測測測"
```
