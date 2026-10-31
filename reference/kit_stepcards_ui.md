# Step card module

Use when a page has several steps that must be done in order: only one
step is open at a time; finished steps collapse to one line (✓, summary,
"改" ("Edit")), and steps not yet available are gray. Each step ends
with "對，下一步" ("Yes, next step") (a regular button); pressing it
marks the step done and opens the next unfinished step. Press "改" on a
finished step to go back.

## Usage

``` r
kit_stepcards_ui(id, ..., next_label = "對，下一步")

kit_stepcards_server(
  id,
  titles,
  summaries = list(),
  checks = list(),
  start = 1L
)
```

## Arguments

- id:

  The module id.

- ...:

  The content of each step (one tag or
  [`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)
  per step, in order).

- next_label:

  The button text at the bottom of each step.

- titles:

  The title of each step (character vector, length = number of steps).

- summaries:

  The summary shown when each step is done: a list, one per step (a
  string, function, or reactive; `NULL` shows nothing).

- checks:

  Checks before "對，下一步" ("Yes, next step") is pressed: a list, one
  function per step, returning what is still needed (character vector;
  length 0 = can move on). While something is still needed, the step is
  not done, and "還差：…" ("Still needed: …") is listed above the button
  ([`kit_problems()`](https://jiewentsai.github.io/kitDesign/reference/kit_problems.md)).

- start:

  Which step is open at the start.

## Value

`kit_stepcards_ui()`: a
[`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)
of
[`kit_step_card()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_card.md)s.

`kit_stepcards_server()`: a list,

- `current`: a reactive, which step is open now (0 when all are done);

- `done`: a reactive, whether each step is done (logical vector);

- `open(k)`: opens step k (for example, back to step 1 when the data
  change);

- `reset()`: marks all steps as not done and opens step 1.

## Details

`kit_stepcards_ui()` holds the content of each step (in order);
`kit_stepcards_server()` gives each step's title, its summary when done,
and the check before "對，下一步" is pressed.

## See also

[`kit_step_card()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_card.md),
[`kit_step_head()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_head.md)
(low-level)

## Examples

``` r
if (interactive()) {
  ui <- kit_page("KIT 示範", NULL,
    kit_stepcards_ui("steps",
      shiny::p("每個檔案是哪個世代、哪個波次。"),
      shiny::p("哪些欄是題目。"),
      shiny::p("計分檢查。")
    )
  )
  server <- function(input, output, session) {
    steps <- kit_stepcards_server("steps",
      titles = c("每個檔案是哪個世代、哪個波次", "哪些欄是題目", "計分檢查"),
      summaries = list("5 個檔案", function() "45 題", "沒有要決定的事")
    )
  }
  shiny::shinyApp(ui, server)
}
```
