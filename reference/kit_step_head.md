# Step card header

Three states:

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

  The step number.

- title:

  The title of this step.

- state:

  `"current"`, `"done"`, or `"locked"`.

- summary:

  A one-sentence summary shown when done (for example "5 個檔案 · 世代
  TDCYP · 2009、2011（年）", "5 files · cohort TDCYP · 2009, 2011
  (year)"). Not shown for the current step; a step not yet available
  always shows "先完成第 N−1 步" ("Finish step N−1 first").

- edit_id:

  The [`actionLink()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
  id for "改" ("Edit") when done; `NULL` hides "改".

- title_id:

  The id of the title (pass it to the `title_id` of
  [`kit_step_card()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_card.md)).

## Value

`<div class="kit-stephead is-current">` or similar.

## Details

- `"current"`: the current step, a lime round number,
  `aria-current="step"`.

- `"done"`: finished, a round ✓ (mint green), followed by a one-sentence
  summary, with "改" ("Edit") at the far right (when `edit_id` is
  given).

- `"locked"`: not yet available, gray, showing "先完成第 N−1 步"
  ("Finish step N−1 first").

Next to the number there is text for screen readers: "第 N
步，現在這一步：" ("Step N, current step:").

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
