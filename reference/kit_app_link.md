# 連到別的網站或 app 的連結（開新分頁）

例如從 kitJoin 連到 kitsUI 的雲端版。連結開新分頁（`target="_blank"`），
後面可以接一行小字說明會開到哪裡。要不要放連結（本機版、雲端版）由 app
自己決定。

## Usage

``` r
kit_app_link(label, href, kind = "link", class = NULL, note = NULL)
```

## Arguments

- label:

  連結的字，例如「開啟 kitsUI」。

- href:

  網址。

- kind:

  `"link"`（文字連結）或按鈕的種類（`"secondary"`、`"primary"`）。

- class:

  連結另外加的 class（例如 `"kit-next-link"`）。

- note:

  後面的一行小字，例如「（開啟網路上的雲端版 kitsUI）」；`NULL` 不顯示。

## Value

`<span class="kit-app-link">`。

## Examples

``` r
kit_app_link("開啟 kitsUI", "https://example.org/kitsui/", kind = "secondary",
             note = "（開啟網路上的雲端版 kitsUI）")
#> <span class="kit-app-link">
#>   <a href="https://example.org/kitsui/" target="_blank" rel="noopener noreferrer" class="btn kit-ext-btn btn-sm btn-outline-secondary">
#>     <i class="fas fa-arrow-up-right-from-square" role="presentation" aria-label="arrow-up-right-from-square icon"></i>
#>     開啟 kitsUI
#>   </a>
#>    
#>   <small class="kit-hint">（開啟網路上的雲端版 kitsUI）</small>
#> </span>
```
