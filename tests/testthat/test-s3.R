# S3 值物件：建構時檢查、as.tags()、format()、print()

test_that("kit_status() validates its fields", {
  expect_error(kit_status("weird", "x"), "`state` must be one of idle, success, warning, error, stale")
  expect_error(kit_status("success", c("a", "b")), "`message` must be one string or a tag")
  expect_error(kit_status("success", NA_character_), "`message`")
  expect_error(kit_status("success", "x", warnings = 1:2), "`warnings` must be")
  expect_error(kit_status("success", "x", points = list("a", 1)), "`points` must be")
  expect_error(kit_status("error", "x", details = c("a", "b")), "`details` must be one string")
  expect_error(kit_status("error", "x", action = "not a tag"), "`action` must be a tag")
  expect_error(kit_status("error", "x", details_title = NULL), "`details_title`")
  expect_s3_class(kit_status("success", shiny::tags$b("粗體結論")), "kit_status")
  expect_s3_class(kit_status("stop", "x", action = shiny::actionLink("a", "怎麼辦")), "kit_status")
})

test_that("kit_status objects render through as.tags(), tagList() and renderUI()", {
  st <- kit_done_status("串接完成。", warnings = "有 1 格是空的。")
  expect_identical(html(htmltools::as.tags(st)), html(kit_status_ui(st)))
  expect_match(html(shiny::tagList(shiny::p("前"), st)), "【完成，但請注意】", fixed = TRUE)
  expect_equal(html(htmltools::as.tags(kit_status())), "")
  shiny::testServer(function(id) shiny::moduleServer(id, function(input, output, session) {
    output$status <- shiny::renderUI(kit_stale_status("執行串接"))
  }), {
    expect_match(as.character(output$status$html), "【要重新執行】", fixed = TRUE)
  })
})

test_that("format() and print() give a text version of a status", {
  st <- kit_status("error", "停下來了。", warnings = "怎麼辦：再試一次。", points = shiny::tags$b("重點"),
                   notes = "補充", details = "Error: boom")
  txt <- format(st)
  expect_equal(txt[1], "【停下來】 停下來了。")
  expect_true("- 怎麼辦：再試一次。" %in% txt)
  expect_true("- 重點" %in% txt)
  expect_true(any(grepl("原始訊息：Error: boom", txt, fixed = TRUE)))
  expect_equal(format(kit_status()), "<kit_status: idle>")
  expect_output(print(st), "【停下來】 停下來了。", fixed = TRUE)
})

test_that("kit_check() validates and renders", {
  expect_error(kit_check("maybe", "x"))
  expect_error(kit_check("ok"), "`title` must be one non-empty string")
  expect_error(kit_check("ok", ""), "`title`")
  expect_error(kit_check("ok", c("a", "b")), "`title`")
  expect_error(kit_check("ok", "x", why = 1), "`why` must be a character vector")
  expect_error(kit_check("ok", "x", actions = "按鈕"), "`actions` must be a tag")
  ch <- kit_check("todo", "分數從 1 開始", "kits 要 0 開始。", actions = list(kit_button("a", "減 1")))
  expect_s3_class(ch, "kit_check")
  expect_match(html(ch), "^<li class=\"kit-check todo\">")
  expect_equal(format(ch), "! 分數從 1 開始（kits 要 0 開始。）")
  expect_equal(format(kit_check("ok", "都是整數")), "✓ 都是整數")
  expect_output(print(kit_check("note", "提醒一下")), "i 提醒一下", fixed = TRUE)
})

test_that("kit_checklist() only takes kit_check items, also as a list", {
  expect_error(kit_checklist("x"), "made with kit_check")
  expect_error(kit_checklist(kit_check("ok", "a"), shiny::tags$li("b")), "made with kit_check")
  items <- list(kit_check("ok", "a"), NULL, kit_check("note", "b"))
  cl <- kit_checklist(items)
  expect_s3_class(cl, "kit_checklist")
  expect_length(cl, 2)
  expect_identical(html(cl), html(kit_checklist(kit_check("ok", "a"), kit_check("note", "b"))))
  expect_match(html(cl), "^<ul class=\"kit-checklist\">\\s*<li class=\"kit-check ok\">")
  expect_equal(format(cl), c("✓ a", "i b"))
  expect_equal(format(kit_checklist()), "<kit_checklist: empty>")
  expect_output(print(cl), "✓ a", fixed = TRUE)
  expect_match(html(kit_checklist()), "<ul class=\"kit-checklist\"></ul>", fixed = TRUE)
})
