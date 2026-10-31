# 步驟卡（StepCard）

一張卡片：上面是
[`kit_step_head()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_head.md)（通常由
server 依狀態畫，放
[`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)），
下面是這一步的內容（[`kit_step_body()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_body.md)，通常包在
[`conditionalPanel()`](https://rdrr.io/pkg/shiny/man/conditionalPanel.html)
裡，只有現在這一步打開）。
卡片的框和陰影跟著標頭的狀態：現在這一步有框和陰影；做完和還不能做的沒有陰影、框是灰的。

## Usage

``` r
kit_step_card(head, ..., title_id = NULL)
```

## Arguments

- head:

  標頭：[`kit_step_head()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_head.md)
  或放它的
  [`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)。

- ...:

  卡片的內容（[`kit_step_body()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_body.md)）。

- title_id:

  標頭標題的
  id（[`kit_step_head()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_head.md)
  的 `title_id`），給螢幕閱讀器當卡片名稱。

## Value

`<section class="kit-stepcard">`。

## Details

不想自己管哪一步打開時，用模組
[`kit_stepcards_ui()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_stepcards_ui.md)
/
[`kit_stepcards_server()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_stepcards_ui.md)。

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
