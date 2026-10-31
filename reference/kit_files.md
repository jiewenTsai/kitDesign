# File helpers: encoding, SPSS variable names, compressed file paths, opening the browser

- `kit_fix_utf8_chr()`: converts text to UTF-8 (characters that cannot
  be converted become `?`); returns non-text input as is.

- `kit_fix_utf8_df()`: converts every text column (and factor) of a data
  frame to UTF-8, keeping SAV variable labels and value labels.

- `kit_is_valid_utf8_df()`: whether the column names and text columns
  are all valid UTF-8.

- `kit_sav_safe_names()`: converts to valid SPSS variable names (tested
  against `haven::write_sav()`: only letters, digits, and `_ . @ # $`;
  starts with a letter or `@`; does not end with `.`; not a reserved
  word; at most 64 bytes; unique ignoring case, with `_2`, `_3` added
  from the second duplicate on).

- `kit_truncate_bytes()`: truncates by UTF-8 byte count without cutting
  a Chinese character in half.

- `kit_gz_path()`: readr decides whether to decompress from the
  extension; if the path does not end in `.gz`, it copies the file to a
  temp file ending in `.gz`.

- `kit_open_browser()`: opens the URL in the default browser (on
  Windows, unaffected by the RStudio viewer).

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

  A character vector (`kit_fix_utf8_chr()`) or a single string
  (`kit_truncate_bytes()`).

- df:

  A data frame.

- cols:

  Column names.

- max_bytes:

  Maximum number of bytes.

- path:

  A file path.

- url:

  A URL.

## Value

An object of the same kind as the input; `kit_is_valid_utf8_df()` gives
`TRUE` / `FALSE`; `kit_open_browser()` gives `NULL`.

## Examples

``` r
kit_sav_safe_names(c("1st wave", "AND", "id", "ID"))
#> [1] "v_1st_wave" "AND_"       "id"         "ID_2"      
kit_truncate_bytes(strrep("測", 30), 64)
#> [1] "測測測測測測測測測測測測測測測測測測測測測"
```
