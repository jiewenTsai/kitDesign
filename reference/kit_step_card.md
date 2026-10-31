# Step card

One card: on top is
[`kit_step_head()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_head.md)
(usually rendered by the server based on the state, in a
[`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)), below is
the content of this step
([`kit_step_body()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_body.md),
usually wrapped in
[`conditionalPanel()`](https://rdrr.io/pkg/shiny/man/conditionalPanel.html)
so only the current step is open). The card's border and shadow follow
the header's state: the current step has a border and shadow; finished
steps and steps not yet available have no shadow and a gray border.

## Usage

``` r
kit_step_card(head, ..., title_id = NULL)
```

## Arguments

- head:

  The header:
  [`kit_step_head()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_head.md),
  or the [`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)
  that holds it.

- ...:

  The card content
  ([`kit_step_body()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_body.md)).

- title_id:

  The id of the header title (the `title_id` of
  [`kit_step_head()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_head.md)),
  used by screen readers as the card name.

## Value

`<section class="kit-stepcard">`.

## Details

If you do not want to manage which step is open yourself, use the module
[`kit_stepcards_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md)
/
[`kit_stepcards_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md).

## Examples

``` r
kit_step_card(
  kit_step_head(1, "每個檔案是哪個世代、哪個波次", "current", title_id = "steptitle1"),
  kit_step_body(shiny::p("已經照欄名猜好了，請看一遍。"),
                shiny::actionButton("ok1", "對，下一步")),
  title_id = "steptitle1"
)
#> <section class="kit-stepcard" aria-labelledby="steptitle1">
#>   <div class="kit-stephead is-current" aria-current="step">
#>     <span class="kit-stepnum" aria-hidden="true">1</span>
#>     <span class="visually-hidden">第 1 步，現在這一步：</span>
#>     <span class="kit-steptitle" id="steptitle1">每個檔案是哪個世代、哪個波次</span>
#>   </div>
#>   <div class="kit-stepbody">
#>     <p>已經照欄名猜好了，請看一遍。</p>
#>     <button id="ok1" type="button" class="btn btn-default action-button"><span class="action-label">對，下一步</span></button>
#>   </div>
#> </section>
```
