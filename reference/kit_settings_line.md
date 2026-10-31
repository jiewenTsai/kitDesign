# Settings summary: a line of small text above the primary button or the result

For example "本次：5 個檔案 · ID：各檔各自 · 全勤樣本" ("This run: 5
files · ID: per file · complete-attendance sample").

## Usage

``` r
kit_settings_line(parts, prefix = "本次：")
```

## Arguments

- parts:

  The parts of the text (empty strings, `NA`, and `NULL` are skipped),
  joined with " · "; can also be a complete sentence written beforehand
  (kitsUI's `ui_settings_line(text)`; in that case use `prefix = NULL`).

- prefix:

  The text in front, default "本次：" ("This run:"); `NULL` adds
  nothing.

## Value

`<p class="kit-settings-line">`; `NULL` when there are no parts.

## Examples

``` r
kit_settings_line(c("5 個檔案", "ID：各檔各自", "全勤樣本"))
#> <p class="kit-settings-line">本次：5 個檔案 · ID：各檔各自 · 全勤樣本</p>
kit_settings_line("本回合 R1：M03、M36 · 參照世代 M03", prefix = NULL)
#> <p class="kit-settings-line">本回合 R1：M03、M36 · 參照世代 M03</p>
```
