# Ready line ("what's still needed")

When the primary button cannot be pressed yet, a bold line above it says
"還差：…" ("Still needed: …"), followed by a link to where to fix it.
Write what is still needed as concrete tasks and numbers: "至少要 2
個波次的檔案，目前只有 1 個" ("Need files from at least 2 waves; there
is only 1 now").

## Usage

``` r
kit_ready_line(missing, link = NULL)
```

## Arguments

- missing:

  What is still needed (character vector; `NA` and `""` are skipped).

- link:

  A link that follows (for example "到「檔案上傳」加入檔案 →", "Go to
  'File upload' to add files →"); `NULL` shows nothing.

## Value

`<p class="kit-ready todo">`; `NULL` when nothing is missing.

## See also

[`kit_run_gate()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate.md),
[`kit_need_files()`](https://jiewentsai.github.io/kitDesign/reference/kit_need_files.md)

## Examples

``` r
kit_ready_line(c("至少要 2 個波次的檔案，目前只有 1 個", "選 ID 欄"))
#> <p class="kit-ready todo">還差：至少要 2 個波次的檔案，目前只有 1 個；選 ID 欄。</p>
```
