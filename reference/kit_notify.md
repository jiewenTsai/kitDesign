# Show a notification (Shiny's showNotification)

【停下來】 (stopped) is red and shows for 10 seconds; everything else
uses the regular style and shows for 6 seconds.

## Usage

``` r
kit_notify(st, session = shiny::getDefaultReactiveDomain(), duration = NULL)
```

## Arguments

- st:

  A
  [`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
  object, or a string (a plain notification).

- session:

  The Shiny session (defaults to the current session).

- duration:

  How many seconds to show it; when `NULL`, the defaults above apply.

## Value

The notification id (invisible); `NULL` for `"idle"` or when there is no
session.

## Examples

``` r
if (interactive()) {
  kit_notify(kit_done_status("串接完成。"))  # "Join done."
}
```
