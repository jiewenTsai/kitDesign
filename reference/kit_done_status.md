# Status after a run: 【完成，但請注意】 (done, but take note) when something needs attention, otherwise 【完成】 (done)

Anything unusual must be seen: when there are `warnings`, the status
cannot be a plain 【完成】 (done).

## Usage

``` r
kit_done_status(
  message,
  warnings = character(0),
  notes = character(0),
  points = character(0)
)
```

## Arguments

- message:

  The conclusion on the first line (one sentence, with numbers and
  units): a string or tag.

- warnings:

  Things to watch out for (a character vector, or a list of strings and
  tags). Listed first.

- notes:

  Additional notes (small gray text).

- points:

  Key results (listed after `warnings`; they do not turn the status into
  "請注意", "please note").

## Value

A `kit_status` object.

## Examples

``` r
kit_done_status("串接完成：3,389 人。")  # "Join done: 3,389 children."
#> 【完成】 串接完成：3,389 人。
kit_done_status("串接完成：3,389 人。", warnings = "有 12 人的 ID 重複，只留第一筆。")
#> 【完成，但請注意】 串接完成：3,389 人。
#> - 有 12 人的 ID 重複，只留第一筆。
# warning: "12 children have duplicate IDs; only the first record is kept."
```
