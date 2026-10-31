# 步驟卡的標頭

三種狀態：

## Usage

``` r
kit_step_head(
  k,
  title,
  state = c("current", "done", "locked"),
  summary = NULL,
  edit_id = NULL,
  title_id = NULL
)
```

## Arguments

- k:

  第幾步。

- title:

  這一步的標題。

- state:

  `"current"`、`"done"` 或 `"locked"`。

- summary:

  做完時的一句摘要（例如「5 個檔案 · 世代 TDCYP · 2009、2011（年）」）。
  現在這一步不顯示；還不能做時一律是「先完成第 N−1 步」。

- edit_id:

  做完時「改」的
  [`actionLink()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
  id；`NULL` 不顯示「改」。

- title_id:

  標題的 id（給
  [`kit_step_card()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_card.md)
  的 `title_id`）。

## Value

`<div class="kit-stephead is-current">` 等。

## Details

- `"current"`：現在這一步，萊姆色的圓形編號，`aria-current="step"`。

- `"done"`：做完的，圓形 ✓（薄荷綠），後面一句摘要，最右邊「改」（有給
  `edit_id` 時）。

- `"locked"`：還不能做的，灰色，寫「先完成第 N−1 步」。

編號旁邊有給螢幕閱讀器的文字：「第 N 步，現在這一步：」。

## Examples

``` r
kit_step_head(1, "每個檔案是哪個世代、哪個波次", "done",
              summary = "5 個檔案 · 世代 TDCYP", edit_id = "edit1")
#> <div class="kit-stephead is-done">
#>   <span class="kit-stepnum" aria-hidden="true">✓</span>
#>   <span class="visually-hidden">第 1 步，做完了：</span>
#>   <span class="kit-steptitle">每個檔案是哪個世代、哪個波次</span>
#>   <span class="kit-stepsum">5 個檔案 · 世代 TDCYP</span>
#>   <a aria-label="改第 1 步：每個檔案是哪個世代、哪個波次" class="action-button action-link kit-stepedit" href="#" id="edit1"><span class="action-label">改</span></a>
#> </div>
kit_step_head(2, "哪些欄是題目", "locked")
#> <div class="kit-stephead is-locked">
#>   <span class="kit-stepnum" aria-hidden="true">2</span>
#>   <span class="visually-hidden">第 2 步，還不能做：</span>
#>   <span class="kit-steptitle">哪些欄是題目</span>
#>   <span class="kit-stepsum">先完成第 1 步</span>
#> </div>
```
