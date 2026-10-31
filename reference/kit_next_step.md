# Next step

At the bottom of the page, aligned right: a line of small text on the
left (it can be a list of places to go next), and a button on the right,
"下一步：××× →" ("Next step: ××× →"). Shown only after a result is ready
(【完成】 done, or 【完成，但請注意】 done, but take note); removed when
the result is out of date (【要重新執行】, needs a rerun).

## Usage

``` r
kit_next_step(
  text = NULL,
  button_id = NULL,
  label = NULL,
  button = NULL,
  kind = "primary"
)
```

## Arguments

- text:

  Small text on the left; `NULL` shows nothing.

- button_id:

  The button id; when `NULL` no button is drawn (unless `button` is
  given).

- label:

  The button text, e.g. "下一步：橫向資料串接" ("Next step: wide join");
  " →" is added automatically.

- button:

  A button to use directly instead of an actionButton (e.g. a link to
  another app).

- kind:

  The button kind: primary button by default; use `"secondary"` when the
  page already has another main action (e.g. a download).

## Value

`<div class="kit-next">`.

## Examples

``` r
kit_next_step("串接好了，可以接著做 kits 作答檔。", "next", "下一步：kits 作答檔")
#> <div class="kit-next">
#>   <div class="kit-hint">串接好了，可以接著做 kits 作答檔。</div>
#>   <button class="btn btn-default action-button btn-primary" id="next" type="button"><span class="action-label">下一步：kits 作答檔 →</span></button>
#> </div>
# "Join done; you can go on to the kits response file." / "Next step: kits response file"
```
