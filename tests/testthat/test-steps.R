test_that("kit_step_card() and kit_step_body() wrap the head and content", {
  out <- html(kit_step_card(kit_step_head(1, "第一步", title_id = "t1"),
                            kit_step_body(shiny::p("內容")), title_id = "t1"))
  expect_match(out, "^<section class=\"kit-stepcard\" aria-labelledby=\"t1\">")
  expect_match(out, "<div class=\"kit-stepbody\">\\s*<p>內容</p>")
})

test_that("kit_step_head() renders current, done and locked states", {
  cur <- html(kit_step_head(1, "每個檔案是哪個世代", "current", summary = "不顯示", title_id = "t1"))
  expect_match(cur, "class=\"kit-stephead is-current\" aria-current=\"step\"", fixed = TRUE)
  expect_match(cur, "<span class=\"kit-stepnum\" aria-hidden=\"true\">1</span>", fixed = TRUE)
  expect_match(cur, "<span class=\"visually-hidden\">第 1 步，現在這一步：</span>", fixed = TRUE)
  expect_match(cur, "<span class=\"kit-steptitle\" id=\"t1\">每個檔案是哪個世代</span>", fixed = TRUE)
  expect_false(grepl("kit-stepsum", cur, fixed = TRUE))

  done <- html(kit_step_head(1, "每個檔案是哪個世代", "done", summary = "5 個檔案", edit_id = "edit1"))
  expect_match(done, "class=\"kit-stephead is-done\"", fixed = TRUE)
  expect_false(grepl("aria-current", done, fixed = TRUE))
  expect_match(done, "<span class=\"kit-stepnum\" aria-hidden=\"true\">✓</span>", fixed = TRUE)
  expect_match(done, "第 1 步，做完了：", fixed = TRUE)
  expect_match(done, "<span class=\"kit-stepsum\">5 個檔案</span>", fixed = TRUE)
  expect_match(done, "class=\"action-button kit-stepedit\"", fixed = TRUE)
  expect_match(done, "aria-label=\"改第 1 步：每個檔案是哪個世代\"", fixed = TRUE)

  locked <- html(kit_step_head(3, "計分檢查", "locked", summary = "不會顯示", edit_id = "edit3"))
  expect_match(locked, "class=\"kit-stephead is-locked\"", fixed = TRUE)
  expect_match(locked, "<span class=\"kit-stepsum\">先完成第 2 步</span>", fixed = TRUE)
  expect_match(locked, "第 3 步，還不能做：", fixed = TRUE)
  expect_false(grepl("kit-stepedit", locked, fixed = TRUE))
  expect_error(kit_step_head(1, "x", "other"))
})

test_that("kit_checklist() and kit_check() carry marks with hidden text", {
  out <- html(kit_checklist(
    kit_check("todo", "分數從 1 開始", "kits 要 0 開始。", actions = kit_button("shift", "全部減 1（建議）")),
    kit_check("ok", "都是整數"),
    kit_check("note", "有 2 題沒有人作答")
  ))
  expect_match(out, "^<ul class=\"kit-checklist\">")
  expect_match(out, "<li class=\"kit-check todo\">\\s*<span class=\"kit-check-mark\" aria-hidden=\"true\">!</span>\\s*<span class=\"visually-hidden\">要決定：</span>")
  expect_match(out, "<li class=\"kit-check ok\">\\s*<span class=\"kit-check-mark\" aria-hidden=\"true\">✓</span>\\s*<span class=\"visually-hidden\">沒問題：</span>")
  expect_match(out, "<li class=\"kit-check note\">\\s*<span class=\"kit-check-mark\" aria-hidden=\"true\">i</span>\\s*<span class=\"visually-hidden\">提醒：</span>")
  expect_match(out, "<div class=\"kit-check-text\">\\s*<strong>分數從 1 開始</strong>\\s*<span>kits 要 0 開始。</span>")
  expect_match(out, "<div class=\"kit-check-actions\">", fixed = TRUE)
  # 沒有說明、沒有按鈕時不畫空的 span 與 div
  ok <- html(kit_check("ok", "都是整數"))
  expect_false(grepl("<span></span>", ok, fixed = TRUE))
  expect_false(grepl("kit-check-actions", ok, fixed = TRUE))
  expect_error(kit_check("maybe", "x"))
})

test_that("kit_problems() lists problems, or nothing", {
  out <- html(kit_problems("第 2 列沒有選世代", "第 4 列的波次不是數字", head = "還差："))
  expect_match(out, "^<div class=\"kit-problems\">\\s*<strong>還差：</strong>\\s*<ul>")
  expect_equal(lengths(regmatches(out, gregexpr("<li>", out))), 2)
  expect_null(kit_problems())
})
