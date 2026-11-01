# 互動資料表（kit_dt()）與範圍選擇列（kit_scope_bar()）

items <- data.frame(
  itemID = c("a1", "a2", "a3"),
  label = c("睡眠時間", "午睡", "會自己穿脫衣服"),
  n = c(3389L, 1250L, 12L),
  p = c(0.5, 0.25, 0.125),
  stringsAsFactors = FALSE
)

# 某一欄的 columnDefs（kit_dt() 每一欄只有一個）
col_def <- function(w, j) {
  defs <- w$x$options$columnDefs
  hit <- Filter(function(d) identical(as.integer(d$targets), as.integer(j)) && !is.null(d$className),
                defs)
  hit[[1]]
}

test_that("kit_dt() returns a datatables widget with the KIT class and Chinese text", {
  skip_if_not_installed("DT")
  w <- kit_dt(items)
  expect_s3_class(w, "datatables")
  expect_s3_class(w, "htmlwidget")
  expect_match(w$x$container, "kit-dt", fixed = TRUE)
  expect_match(w$x$container, "compact", fixed = TRUE)
  expect_false(grepl("kit-dt-selectable", w$x$container, fixed = TRUE))
  lang <- w$x$options$language
  expect_equal(lang$info, "共 _TOTAL_ 列，第 _START_–_END_ 列")
  expect_equal(lang$paginate$previous, "上一頁")
  expect_equal(lang$paginate$`next`, "下一頁")
  expect_equal(lang$search, "搜尋：")
  expect_equal(lang$zeroRecords, "沒有符合的資料")
  expect_false("rownames" %in% names(w$x$options))
  expect_equal(w$x$options$pageLength, 20L)
  expect_true(w$x$options$paging)
  expect_false(w$x$options$autoWidth)
})

test_that("kit_dt() pages, or shows every row when page_length = 0", {
  skip_if_not_installed("DT")
  w <- kit_dt(items, page_length = 10)
  expect_true(w$x$options$paging)
  expect_equal(w$x$options$pageLength, 10L)
  expect_match(w$x$options$dom, "<\"kit-dt-foot\"ip>", fixed = TRUE)

  all_rows <- kit_dt(items, page_length = 0)
  expect_false(all_rows$x$options$paging)
  expect_equal(all_rows$x$options$pageLength, -1L)
  expect_match(all_rows$x$options$dom, "<\"kit-dt-foot\"i>", fixed = TRUE)
})

test_that("kit_dt() shows the search box only when asked", {
  skip_if_not_installed("DT")
  expect_false(grepl("f", gsub("\"[^\"]*\"", "", kit_dt(items)$x$options$dom)))
  w <- kit_dt(items, search = TRUE)
  expect_match(w$x$options$dom, "<\"kit-dt-top\"f>", fixed = TRUE)
  expect_match(w$x$options$dom, "<\"kit-dt-scroll\"t>", fixed = TRUE)
})

test_that("kit_dt() wraps only wrap_cols and right-aligns numeric columns", {
  skip_if_not_installed("DT")
  w <- kit_dt(items, wrap_cols = "label", min_widths = c(label = "24rem"))
  # 每一欄只有一個 columnDef（DataTables 只用第一個 className）
  targets <- vapply(w$x$options$columnDefs, function(d) {
    if (is.null(d$className)) NA_integer_ else as.integer(d$targets)
  }, integer(1))
  expect_equal(sort(targets[!is.na(targets)]), 0:3)
  expect_equal(col_def(w, 0)$className, "kit-dt-nowrap")
  expect_equal(col_def(w, 1)$className, "kit-dt-wrap")
  expect_equal(col_def(w, 1)$width, "24rem")
  expect_equal(col_def(w, 2)$className, "kit-dt-nowrap dt-right")
  expect_equal(col_def(w, 3)$className, "kit-dt-nowrap dt-right")
  # 沒有 wrap_cols：每一欄都不換行
  plain <- kit_dt(items)
  expect_equal(col_def(plain, 1)$className, "kit-dt-nowrap")
  # 不存在的欄名不會出錯
  expect_s3_class(kit_dt(items, wrap_cols = "nope", min_widths = c(nope = "3rem")), "datatables")
})

test_that("kit_dt() passes selection and lets options override the defaults", {
  skip_if_not_installed("DT")
  w <- kit_dt(items, selection = "single")
  expect_equal(w$x$selection$mode, "single")
  expect_match(w$x$container, "kit-dt-selectable", fixed = TRUE)
  m <- kit_dt(items, selection = list(mode = "multiple", selected = 2))
  expect_equal(m$x$selection$mode, "multiple")
  expect_equal(m$x$selection$selected, 2)
  expect_match(m$x$container, "kit-dt-selectable", fixed = TRUE)

  o <- kit_dt(items, ordering = FALSE,
              options = list(pageLength = 5L, columnDefs = list(list(targets = 0, visible = FALSE))))
  expect_false(o$x$options$ordering)
  expect_equal(o$x$options$pageLength, 5L)
  # columnDefs from options come first (DataTables lets the first one win)
  expect_false(o$x$options$columnDefs[[1]]$visible)
  expect_equal(col_def(o, 0)$className, "kit-dt-nowrap")
})

test_that("kit_scope_bar() builds the scope bar markup", {
  bar <- kit_scope_bar(
    shiny::radioButtons("bank", "題庫", c("TDCYP" = "tdcyp", "上傳" = "own"), inline = TRUE),
    line = "目前：TDCYP 題庫 · 412 題",
    actions = list(kit_button("dl", "下載題庫"), kit_button("new", "新增題庫")),
    panel = shiny::tags$p("確認的內容")
  )
  out <- html(bar)
  expect_match(out, "^<div class=\"kit-scopebar\">")
  expect_match(out, "shiny-input-radiogroup", fixed = TRUE)
  expect_match(out, "<div class=\"kit-scopebar-line\">\\s*目前：TDCYP 題庫 · 412 題\\s*<div class=\"kit-scopebar-actions\">")
  expect_match(out, "id=\"dl\"", fixed = TRUE)
  expect_match(out, "id=\"new\"", fixed = TRUE)
  expect_match(out, "<div class=\"kit-scopebar-panel\">\\s*<p>確認的內容</p>")
  # 輸入在 line 前面，line 在 panel 前面
  expect_lt(regexpr("bank", out), regexpr("kit-scopebar-line", out))
  expect_lt(regexpr("kit-scopebar-line", out), regexpr("kit-scopebar-panel", out))
})

test_that("kit_scope_bar() leaves out the parts it is not given", {
  only_input <- html(kit_scope_bar(shiny::selectInput("bank", "題庫", c("a", "b"))))
  expect_match(only_input, "kit-scopebar", fixed = TRUE)
  expect_false(grepl("kit-scopebar-line", only_input, fixed = TRUE))
  expect_false(grepl("kit-scopebar-panel", only_input, fixed = TRUE))
  # 只有按鈕（單一個 tag 也可以）：有 line、沒有 hint 文字
  one_button <- html(kit_scope_bar(shiny::selectInput("bank", "題庫", "a"),
                                   actions = kit_button("dl", "下載題庫")))
  expect_match(one_button, "<div class=\"kit-scopebar-line\">\\s*<div class=\"kit-scopebar-actions\">")
  # 只有 hint：沒有按鈕區
  hint_only <- html(kit_scope_bar(shiny::selectInput("bank", "題庫", "a"),
                                  line = shiny::tags$span(class = "kit-scopebar-todo", "還沒選題庫")))
  expect_match(hint_only, "<span class=\"kit-scopebar-todo\">還沒選題庫</span>", fixed = TRUE)
  expect_false(grepl("kit-scopebar-actions", hint_only, fixed = TRUE))
})

test_that("kit_dt() text is marked UTF-8 and renders in testServer without encoding warnings", {
  skip_if_not_installed("DT")
  txt <- unlist(kit_dt_language())
  non_ascii <- txt[grepl("[^\\x01-\\x7F]", txt, perl = TRUE)]
  expect_true(length(non_ascii) > 0)
  expect_true(all(Encoding(non_ascii) == "UTF-8"))
  srv <- function(input, output, session) {
    output$t <- DT::renderDT(kit_dt(data.frame(a = 1:30), page_length = 10))
  }
  expect_no_warning(shiny::testServer(srv, {
    out <- output$t
    expect_match(out, "kit-dt", fixed = TRUE)
  }))
})
