# 執行分頁（RunTab）

一頁一個主要按鈕的分頁骨架。`kit_run_tab_ui()`
照頁面骨架排好固定的部分，分頁自己的設定放在
`...`；`kit_run_tab_server()` 在分頁的
[`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html)
裡呼叫，做好狀態流：

## Usage

``` r
kit_run_tab_ui(
  id,
  run_label,
  guide = NULL,
  ...,
  gate = TRUE,
  result = FALSE,
  downloads = TRUE,
  details = TRUE,
  code = TRUE,
  next_step = FALSE
)

kit_run_tab_server(
  input,
  output,
  session,
  run_label,
  run,
  done = NULL,
  ready = NULL,
  ready_link = function() NULL,
  settings = NULL,
  stale_on = NULL,
  progress = NULL,
  error = function(e) kit_error_status(e, run_label),
  guard = NULL,
  confirm = list(),
  result_ui = NULL,
  details_ui = NULL,
  code = NULL,
  code_note = KIT_CODE_NOTE
)
```

## Arguments

- id:

  分頁（模組）的 id。

- run_label:

  主要按鈕的字（動詞開頭，例如「執行串接」）。

- guide:

  最上面的「這一頁做什麼」（[`kit_tab_guide()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_tab_guide.md)）。

- ...:

  分頁自己的設定（輸入元件、提示），放在設定摘要上面。

- gate:

  `TRUE`：主要按鈕一開始停用，上面是「還差」；`FALSE`：一直能按（沒有
  `ready`）。

- result, downloads, next_step:

  狀態框下面的重點、下載區、最下面的下一步：`TRUE` 是
  [`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)（id 是
  `result`、`downloads`、`next_step`），也可以直接給 tag；`FALSE` 不放。

- details:

  細節列：`TRUE` 放 `uiOutput("result_details")`（結果的預覽與核對）；
  `details` 與 `code` 都是 `FALSE` 時沒有細節列。

- code:

  UI（`kit_run_tab_ui()`）：`TRUE` 放「用 R
  怎麼做」（[`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_panel.md)，output
  `code`）。
  server（`kit_run_tab_server()`）：傳回程式碼的函式（[`kit_render_code_panel()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_render_code_panel.md)
  的 `code`）； `NULL` 時分頁自己畫。

- input, output, session:

  分頁的
  [`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html) 的
  input、output、session。

- run:

  執行的函式：傳回結果（任何物件），或一個
  [`kit_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_status.md)（沒有結果，例如有問題要先處理）。
  要停下來時
  [`kit_abort()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_abort.md)（白話的原因）。

- done:

  `function(result)`：執行完的狀態（[`kit_done_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_done_status.md)）；結果在呼叫前已經存好。

- ready:

  reactive：還差的事（字串向量；長度 0 = 可以執行）；`NULL`
  時沒有「還差」（`gate = FALSE`）。

- ready_link:

  函式：跟在「還差」後面的連結（tag 或 `NULL`）。

- settings:

  函式：設定摘要的幾段（字串向量；`NULL` 時不顯示）；`NULL`
  時沒有設定摘要。

- stale_on:

  函式：改了會讓結果過期的東西（例如 `list(input$method, data())`）；
  `NULL` 時分頁自己處理（用回傳的 `result`、`status`）。

- progress:

  進度條的訊息（「正在串接資料…」）；`NULL` 時沒有進度條。

- error:

  `function(e)`：出錯時的狀態；預設 `kit_error_status(e, run_label)`。

- guard:

  函式：執行前的檢查，傳回
  [`kit_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_status.md)
  時不執行（狀態框與通知，不捲動）；`NULL` 不檢查。

- confirm:

  要使用者確認的錯誤：具名 list，名字是 condition 的 class，值是
  `function(e)`，
  跳出確認視窗、傳回狀態（不通知、不捲動，視窗就是回應）。確認以後用回傳的
  `run(...)` 再執行。

- result_ui:

  `function(result)`：狀態框下面的重點（output `result`）；`NULL`
  時分頁自己畫。

- details_ui:

  `function(result)`：細節列的第一格（output `result_details`，例如
  [`kit_detail()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_detail.md)「結果預覽」）；`NULL`
  時分頁自己畫。

- code_note:

  「用 R 怎麼做」最上面的一行說明。

## Value

`kit_run_tab_ui()`：[`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)。

`kit_run_tab_server()`：list，

- `result`：`reactiveVal`，這一次的結果（還沒有、或過期了是 `NULL`）；

- `status`：`reactiveVal`，狀態框的
  [`kit_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_status.md)；

- `state`：reactive，狀態框的狀態（步驟分頁打 ✓
  用，[`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_tab_states.md)）；

- `run(...)`：照按主要按鈕一樣執行一次（`...` 給
  `run()`，例如確認視窗的「仍要執行」）。

## Details

- 主要按鈕：還差的事（`ready()`）不是空的時停用，上面一行「還差：…」（[`kit_run_gate()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_run_gate.md)）。

- 設定摘要：`settings()`
  的幾段接成一行（[`kit_settings_line()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_settings_line.md)）。

- 按主要按鈕：清掉舊結果 → `guard()` → 進度條裡 `run()` →
  結果存起來、`done(result)` 是狀態； 出錯時 `error(e)` 是狀態 →
  狀態框、通知（[`kit_notify()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_notify.md)）、捲到狀態框（[`kit_scroll_to()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_scroll_to.md)）。

- 改了設定或資料（`stale_on()`
  變了）而且有結果時：結果清掉，狀態是【要重新執行】。

- 結果的重點、細節列的第一格、用 R 怎麼做：有結果時才畫。

固定的 output id（不加
namespace）：`settings_line`、`ready`、`run`（按鈕）、`status`、
`result`、`downloads`、`result_details`、`code`、`next_step`。

## See also

[`kit_run_gate()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_run_gate.md)、[`kit_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_status.md)、[`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_panel.md)

## Examples

``` r
if (interactive()) {
  mod_stack_ui <- function(id) {
    kit_run_tab_ui(
      id, "執行疊加",
      guide = kit_tab_guide("把各波資料上下疊起來。", c("按「執行疊加」", "看狀態框與預覽"), "一張長格式的資料。"),
      shiny::numericInput(shiny::NS(id, "n"), "幾個波次", 2),
      downloads = FALSE
    )
  }
  mod_stack_server <- function(id) {
    shiny::moduleServer(id, function(input, output, session) {
      tab <- kit_run_tab_server(
        input, output, session, "執行疊加",
        ready = shiny::reactive(if (input$n < 2) "至少 2 個波次"),
        settings = function() paste0(input$n, " 個波次"),
        stale_on = function() input$n,
        progress = "正在疊加資料…",
        run = function() data.frame(wave = seq_len(input$n)),
        done = function(res) kit_done_status(paste0("疊加完成：", nrow(res), " 列。")),
        details = function(res) kit_detail("結果預覽", kit_static_table(res)),
        code = function() "stacked <- dplyr::bind_rows(t1, t2, .id = \"wave\")"
      )
      list(state = tab$state)
    })
  }
  shiny::shinyApp(kit_page("KIT 示範", NULL, mod_stack_ui("stack")),
                  function(input, output, session) mod_stack_server("stack"))
}
```
