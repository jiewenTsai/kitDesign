test_that("each state has its label and colour class", {
  expected <- list(
    success = c("alert-success", "【完成】"),
    warning = c("alert-warning", "【完成，但請注意】"),
    error = c("alert-danger", "【停下來】"),
    stale = c("alert-warning", "【要重新執行】")
  )
  for (state in names(expected)) {
    out <- html(kit_status_ui(kit_status(state, "一句結論。")))
    expect_match(out, paste0("class=\"alert ", expected[[state]][1], " kit-status\""), fixed = TRUE)
    expect_match(out, "role=\"alert\"", fixed = TRUE)
    expect_match(out, paste0("<div class=\"kit-status-line\">\\s*<strong>", expected[[state]][2],
                             "</strong>\\s*一句結論。"))
  }
  expect_null(kit_status_ui(kit_status()))
  expect_null(kit_status_ui(NULL))
  expect_error(kit_status_ui(list(state = "weird", message = "x")), "Unknown status state")
})

test_that("kitsUI state names (done, warn, stop) are accepted", {
  expect_equal(kit_status("done")$state, "success")
  expect_equal(kit_status("warn")$state, "warning")
  expect_equal(kit_status("stop")$state, "error")
  expect_match(html(kit_status_ui(kit_status("stop", "x"))), "【停下來】", fixed = TRUE)
})

test_that("at most 3 points are shown; the rest go in 「還有 N 點」", {
  st <- kit_status("warning", "x", warnings = c("w1", "w2"), points = c("p1", "p2", "p3"))
  out <- html(kit_status_ui(st))
  first <- sub("<details class=\"kit-status-more\">.*$", "", out)
  expect_equal(lengths(regmatches(first, gregexpr("<li>", first))), 3)
  # 要注意的事在前
  expect_match(first, "<li>w1</li>\\s*<li>w2</li>\\s*<li>p1</li>")
  expect_match(out, "<details class=\"kit-status-more\">\\s*<summary>還有 2 點</summary>")
  expect_match(out, "<li>p2</li>\\s*<li>p3</li>")
  three <- html(kit_status_ui(kit_status("success", "x", points = c("a", "b", "c"))))
  expect_false(grepl("還有", three, fixed = TRUE))
  many <- html(kit_status_ui(kit_status("success", "x", points = as.character(1:1004))))
  expect_match(many, "還有 1,001 點", fixed = TRUE)
  two <- html(kit_status_ui(kit_status("success", "x", points = c("a", "b", "c", "d")), max_points = 2))
  expect_match(two, "還有 2 點", fixed = TRUE)
})

test_that("points can be tags; action, notes, raw message and extra content render", {
  st <- kit_status(
    "error", "停了。", points = list(shiny::tags$b("粗"), "字"),
    action = shiny::actionLink("fix", "怎麼辦 →"), notes = c("補充一", "補充二"),
    details = "Error: boom", details_title = "kits 的原文"
  )
  out <- html(kit_status_ui(st, shiny::tags$p(class = "extra", "更多")))
  expect_match(out, "<li>\\s*<b>粗</b>\\s*</li>")
  expect_match(out, "<div class=\"kit-status-action\">", fixed = TRUE)
  expect_match(out, "<div class=\"kit-status-notes\">\\s*<div>補充一</div>\\s*<div>補充二</div>")
  expect_match(out, "<details class=\"kit-status-raw\">\\s*<summary>kits 的原文</summary>\\s*<code>Error: boom</code>")
  expect_match(out, "<p class=\"extra\">更多</p>", fixed = TRUE)
  single_tag <- html(kit_status_ui(kit_status("success", "x", warnings = shiny::tags$em("一點"))))
  expect_equal(lengths(regmatches(single_tag, gregexpr("<li>", single_tag))), 1)
})

test_that("kit_done_status() becomes a warning when there are warnings", {
  expect_equal(kit_done_status("好了。")$state, "success")
  st <- kit_done_status("好了。", warnings = "注意", points = "重點", notes = "註")
  expect_equal(st$state, "warning")
  expect_equal(st$points, "重點")
  expect_equal(st$notes, "註")
  expect_s3_class(st, "kit_status")
})

test_that("kit_error_status() shows user errors as they are and hides raw messages", {
  user <- tryCatch(kit_abort("至少要 2 個檔案。"), error = identity)
  st <- kit_error_status(user, "串接", todo = shiny::tags$a("去上傳"))
  expect_equal(st$state, "error")
  expect_equal(st$message, "至少要 2 個檔案。")
  expect_null(st$details)
  expect_false(is.null(st$action))
  other <- tryCatch(stop("subscript out of bounds"), error = identity)
  st2 <- kit_error_status(other, "串接")
  expect_equal(st2$message, "串接時發生沒有預期到的問題，沒有做完。")
  expect_match(st2$warnings, "^怎麼辦：")
  expect_equal(st2$details, "subscript out of bounds")
  out <- html(kit_status_ui(st2))
  expect_match(out, "<summary>原始訊息</summary>", fixed = TRUE)
})

test_that("kit_stale_status() asks to run again", {
  st <- kit_stale_status("執行串接")
  expect_equal(st$state, "stale")
  expect_equal(st$message, "檔案或設定改過了，舊的結果已清除：請再按一次「執行串接」。")
  expect_equal(kit_stale_status("x", message = "資料改了。")$message, "資料改了。")
})

test_that("kit_abort() raises a kit_user_error with extra class and data", {
  e <- tryCatch(kit_abort("少了 ", 2, " 個檔案。"), error = identity)
  expect_s3_class(e, "kit_user_error")
  expect_equal(conditionMessage(e), "少了 2 個檔案。")
  expect_null(conditionCall(e))
  expect_true(kit_is_user_error(e))
  e2 <- tryCatch(kit_abort("要確認。", class = "kit_confirm", data = list(n = 3)), error = identity)
  expect_s3_class(e2, "kit_confirm")
  expect_s3_class(e2, "kit_user_error")
  expect_equal(e2$n, 3)
  expect_false(kit_is_user_error(simpleError("x")))
  expect_error(kit_abort("停"), class = "kit_user_error")
})

test_that("kit_notify() uses error type and 10 s for stops, message and 6 s otherwise", {
  s <- fake_session()
  kit_notify(kit_status("error", "停下來了。"), session = s)
  kit_notify(kit_done_status("好了。"), session = s)
  kit_notify("一般訊息", session = s, duration = 2)
  kit_notify(kit_status(), session = s)
  expect_length(s$notes, 3)
  expect_equal(s$notes[[1]]$message$type, "error")
  expect_equal(s$notes[[1]]$message$duration, 10000)
  expect_equal(s$notes[[2]]$message$type, "message")
  expect_equal(s$notes[[2]]$message$duration, 6000)
  expect_equal(s$notes[[3]]$message$duration, 2000)
  expect_null(kit_notify(kit_done_status("x"), session = NULL))
})
