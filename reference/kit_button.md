# Button

A
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
with a class set by the button kind:

## Usage

``` r
kit_button(id, label, kind = "secondary", ..., class = NULL)
```

## Arguments

- id:

  The button's input id.

- label:

  The text on the button.

- kind:

  `"primary"`, `"secondary"`, or `"danger"`.

- ...:

  Other arguments passed to
  [`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
  (e.g. `disabled = TRUE`, `icon`).

- class:

  An extra class.

## Value

`<button class="btn ...">`.

## Details

- `"primary"`: primary button, lime background, large text, card shadow.
  One per page, plus the "下一步" ("Next step") at the bottom.

- `"secondary"`: secondary button, white background, thin border, no
  shadow. For download, select all, example files, move up/down, copy.

- `"danger"`: danger button, salmon background. For delete, remove, skip
  this round.

For a regular button (white background, black border, small shadow, e.g.
"對，下一步" ("Yes, next step")) use
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
directly. Start the text with a verb and say clearly what pressing it
does; if it leaves the page, add "→" after the text.

## Examples

``` r
kit_button("run", "執行串接", "primary")       # "Run join"
#> <button class="btn btn-default action-button btn-primary" id="run" type="button"><span class="action-label">執行串接</span></button>
kit_button("all", "全選")                     # "Select all"
#> <button class="btn btn-default action-button btn-sm btn-outline-secondary" id="all" type="button"><span class="action-label">全選</span></button>
kit_button("drop", "這一回合不做", "danger")  # "Skip this round"
#> <button class="btn btn-default action-button btn-sm btn-danger" id="drop" type="button"><span class="action-label">這一回合不做</span></button>
```
