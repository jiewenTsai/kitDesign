# Download button

Looks the same as
[`shiny::downloadButton()`](https://rdrr.io/pkg/shiny/man/downloadButton.html),
but Chinese file names save correctly in every browser: the last part of
the URL, the `Content-Disposition` header (`filename` and `filename*`),
and `<a download>` all carry the same file name. Put it inside
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html): it is
registered again on each redraw, the URL changes with it, and you never
get a stale file.

## Usage

``` r
kit_download_button(
  session,
  id,
  label,
  filename,
  content,
  class = NULL,
  app = getOption("kitDesign.app", "kit")
)
```

## Arguments

- session:

  The module's session (the namespace is added to the id automatically).

- id:

  The button id (without namespace).

- label:

  The button text, e.g. "下載 CSV" ("Download CSV").

- filename:

  The download file name (a string; may contain Chinese and spaces).

- content:

  `function(file)`: writes the file to `file`.

- class:

  An extra class, e.g. `kit_btn_class("secondary")`, `"btn-primary"`.

- app:

  The app name: used in log messages; when the file name is all Chinese,
  the ASCII fallback name for old browsers is its lowercase form
  ("第一波.csv" → "kitjoin.csv"). Defaults to
  `getOption("kitDesign.app", "kit")`: the app sets it once in
  `.onLoad()`.

## Value

`<a class="btn btn-default kit-download" download="檔名">` (`download`
holds the file name).

## Details

The file is written only when the user clicks download (`content(file)`,
which can read reactives). If writing fails: the error goes to the log
(" 下載失敗（檔名）：…", "\<app\> download failed (file name): …"), this
session shows a red notification (which does not disappear on its own),
and the response is 500 with the same sentence. Messages from
[`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md)
are shown to the user as written; other errors do not expose internal
messages.

`Content-Type` follows the extension: `.csv`, `.zip`, and `.html` get
their own MIME types; everything else (`.sav`, `.csv.gz`) is
`application/octet-stream`, so browsers that add an extension based on
MIME type don't add an extra one.

## See also

[`kit_test_download()`](https://jiewentsai.github.io/kitDesign/reference/kit_test_download.md)
(for tests)

## Examples

``` r
if (interactive()) {
  server <- function(input, output, session) {
    output$dl_ui <- shiny::renderUI(kit_download_button(
      session, "dl", "下載 CSV", "第一波 資料.csv",   # "Download CSV", "Wave 1 data.csv"
      function(file) utils::write.csv(mtcars, file)
    ))
  }
}
```
