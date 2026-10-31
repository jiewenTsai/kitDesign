# A link to another website or app (opens in a new tab)

For example, a link from kitJoin to the cloud version of kitsUI. The
link opens in a new tab (`target="_blank"`) and can be followed by a
line of small print saying where it goes. Whether to show the link
(local version, cloud version) is up to the app.

## Usage

``` r
kit_app_link(label, href, kind = "link", class = NULL, note = NULL)
```

## Arguments

- label:

  The link text, e.g. "開啟 kitsUI" ("Open kitsUI").

- href:

  The URL.

- kind:

  `"link"` (a text link) or a button kind (`"secondary"`, `"primary"`).

- class:

  An extra class for the link (e.g. `"kit-next-link"`).

- note:

  A line of small print after it, e.g. "（開啟網路上的雲端版 kitsUI）"
  ("(opens the online cloud version of kitsUI)"); `NULL` shows nothing.

## Value

`<span class="kit-app-link">`.

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
