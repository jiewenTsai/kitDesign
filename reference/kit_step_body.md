# Step card content

Tables inside the card have no outer border and a light header (CSS
handles this); no indent on phones.

## Usage

``` r
kit_step_body(...)
```

## Arguments

- ...:

  The content of this step; usually ends with "對，下一步" ("Yes, next
  step")
  ([`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html),
  a regular button).

## Value

`<div class="kit-stepbody">`.

## Examples

``` r
kit_step_body(shiny::p("說明"), shiny::actionButton("ok1", "對，下一步"))
#> <div class="kit-stepbody">
#>   <p>說明</p>
#>   <button id="ok1" type="button" class="btn btn-default action-button"><span class="action-label">對，下一步</span></button>
#> </div>
```
