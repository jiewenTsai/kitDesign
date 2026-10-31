# Open a collapsible section (for example, open the advanced settings after applying a preset)

Open a collapsible section (for example, open the advanced settings
after applying a preset).

## Usage

``` r
kit_open_details(id, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- id:

  The id of the `<details>` (the id inside the module; the namespace is
  added automatically), for example the `id` of
  [`kit_advanced()`](https://jiewentsai.github.io/kitDesign/reference/kit_advanced.md).

- session:

  Defaults to the current session.

## Value

The full id, invisibly; `NULL` when there is no session.

## Examples

``` r
if (interactive()) kit_open_details("advanced")
```
