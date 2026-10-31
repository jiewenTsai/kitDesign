test_that("kit_tab_guide() is a collapsed details with goal, steps, output", {
  out <- html(kit_tab_guide("把檔案接起來。", kit_steps("選檔案", "按執行"), "一張表。",
                            technical = "用 left_join()。", note = "補充。"))
  expect_match(out, "^<details class=\"kit-guide kit-guide-page\">")
  expect_false(grepl("<details[^>]*open", out))
  expect_match(out, "<strong>這一頁做什麼：</strong>", fixed = TRUE)
  expect_match(out, "<span class=\"kit-guide-more\"></span>", fixed = TRUE)
  expect_match(out, "<div class=\"kit-guide-body\">", fixed = TRUE)
  expect_match(out, "<ol class=\"kit-steps\">", fixed = TRUE)
  expect_match(out, "<p class=\"kit-guide-note\">補充。</p>", fixed = TRUE)
  expect_match(out, "技術說明（給想了解原理的人）", fixed = TRUE)
  # kitsUI 的 mod_guide() 直接給字串向量
  expect_match(html(kit_tab_guide("目標", c("一", "二"), "結果")), "<li>二</li>", fixed = TRUE)
})

test_that("kit_tab_guide() with a diagram wraps it in .kit-guide-wrap", {
  dg <- kit_diagram(kit_dg_table(data.frame(id = 1), "前"), kit_dg_table(data.frame(id = 1), "後"), "說明")
  out <- html(kit_tab_guide("目標", kit_steps("一"), "結果", diagram = dg))
  expect_match(out, "^<div class=\"kit-guide kit-guide-wrap\">\\s*<details class=\"kit-guide-page\">")
  expect_match(out, "<figure class=\"kit-diagram\">", fixed = TRUE)
})

test_that("kit_steps() is an ordered list", {
  out <- html(kit_steps("選檔案", c("選 ID", "按執行")))
  expect_match(out, "<ol class=\"kit-steps\">", fixed = TRUE)
  expect_equal(lengths(regmatches(out, gregexpr("<li>", out))), 3)
})

test_that("kit_dg_table() marks added columns, empty cells and row headers", {
  out <- html(kit_dg_table(data.frame(id = 1:2, wave = c("1", NA)), "結果", added = "wave"))
  expect_match(out, "<table class=\"kit-dg-table\">", fixed = TRUE)
  expect_match(out, "<caption>結果</caption>", fixed = TRUE)
  expect_match(out, "<th scope=\"col\" class=\"kit-dg-added\">\\s*wave\\s*<span class=\"kit-dg-new\">（新）</span>")
  expect_match(out, "<span class=\"kit-dg-empty\">（空）</span>", fixed = TRUE)
  rh <- html(kit_dg_table(data.frame(方式 = "全樣本", 人 = "1 號"), "比較", row_header = TRUE))
  expect_match(rh, "<th scope=\"row\">全樣本</th>", fixed = TRUE)
})

test_that("kit_diagram() lays out before -> after with a caption", {
  out <- html(kit_diagram(list(kit_dg_table(data.frame(a = 1), "t1"), kit_dg_table(data.frame(a = 2), "t2")),
                          kit_dg_table(data.frame(a = 1:2), "結果"), "接起來。"))
  expect_match(out, "<div class=\"kit-dg-flow\">", fixed = TRUE)
  expect_match(out, "<div class=\"kit-dg-before\">", fixed = TRUE)
  expect_match(out, "<div class=\"kit-dg-arrow\" aria-hidden=\"true\">→</div>", fixed = TRUE)
  expect_match(out, "<figcaption class=\"kit-dg-caption\">接起來。</figcaption>", fixed = TRUE)
  expect_equal(lengths(regmatches(out, gregexpr("kit-dg-table", out))), 3)
})

test_that("kit_button() and kit_btn_class() use the three kinds", {
  expect_equal(kit_btn_class("primary"), "btn-primary")
  expect_equal(kit_btn_class(), "btn-sm btn-outline-secondary")
  expect_equal(kit_btn_class("danger"), "btn-sm btn-danger")
  expect_error(kit_btn_class("huge"))
  p <- html(kit_button("run", "執行串接", "primary"))
  expect_match(p, "class=\"btn btn-default action-button btn-primary\"", fixed = TRUE)
  expect_match(p, "id=\"run\"", fixed = TRUE)
  expect_match(html(kit_button("all", "全選")), "btn-sm btn-outline-secondary", fixed = TRUE)
  expect_match(html(kit_button("x", "移除", "danger", class = "me-2")), "btn-sm btn-danger me-2", fixed = TRUE)
  expect_match(html(kit_button("run", "執行", "primary", disabled = TRUE)), "disabled", fixed = TRUE)
})

test_that("kit_callout() is info by default and warn on request", {
  expect_match(html(kit_callout("資訊")), "^<div class=\"kit-callout\">資訊</div>$")
  expect_match(html(kit_callout("注意", warn = TRUE)), "class=\"kit-callout kit-callout-warn\"", fixed = TRUE)
  expect_match(html(kit_callout("x", class = "mb-0")), "class=\"kit-callout mb-0\"", fixed = TRUE)
})

test_that("kit_next_step() puts a hint and a primary button with an arrow", {
  out <- html(kit_next_step("串接好了。", "next", "下一步：kits 作答檔"))
  expect_match(out, "^<div class=\"kit-next\">")
  expect_match(out, "<div class=\"kit-hint\">串接好了。</div>", fixed = TRUE)
  expect_match(out, "btn-primary", fixed = TRUE)
  expect_match(out, "下一步：kits 作答檔 →", fixed = TRUE)
  expect_match(html(kit_next_step(NULL, "n", "下一步", kind = "secondary")), "btn-sm btn-outline-secondary", fixed = TRUE)
  only_text <- html(kit_next_step("只有一句。"))
  expect_false(grepl("<button", only_text, fixed = TRUE))
  custom <- html(kit_next_step(button = shiny::tags$a(href = "#", "連結")))
  expect_match(custom, "<a href=\"#\">連結</a>", fixed = TRUE)
})

test_that("kit_app_link() opens a new tab, as a link or a button", {
  link <- html(kit_app_link("開啟 kitsUI", "https://example.org/"))
  expect_match(link, "target=\"_blank\"", fixed = TRUE)
  expect_match(link, "rel=\"noopener noreferrer\"", fixed = TRUE)
  expect_false(grepl("kit-ext-btn", link, fixed = TRUE))
  btn <- html(kit_app_link("開啟 kitsUI", "https://example.org/", kind = "secondary", note = "（雲端版）"))
  expect_match(btn, "class=\"btn kit-ext-btn btn-sm btn-outline-secondary\"", fixed = TRUE)
  expect_match(btn, "<small class=\"kit-hint\">（雲端版）</small>", fixed = TRUE)
})

test_that("kit_cloud_banner() is a yellow alert", {
  out <- html(kit_cloud_banner("此為雲端版。"))
  expect_match(out, "class=\"alert alert-warning kit-cloud-banner\"", fixed = TRUE)
  expect_match(out, "role=\"alert\"", fixed = TRUE)
})

test_that("kit_is_cloud(): KIT_DEPLOY first, then R_CONFIG_ACTIVE = rsconnect", {
  old <- Sys.getenv(c("KIT_DEPLOY", "R_CONFIG_ACTIVE"), unset = NA)
  on.exit(for (n in names(old)) {
    if (is.na(old[[n]])) Sys.unsetenv(n) else do.call(Sys.setenv, as.list(old[n]))
  })
  Sys.setenv(KIT_DEPLOY = "cloud")
  expect_true(kit_is_cloud())
  Sys.setenv(KIT_DEPLOY = "Local", R_CONFIG_ACTIVE = "rsconnect")
  expect_false(kit_is_cloud())
  Sys.unsetenv("KIT_DEPLOY")
  expect_true(kit_is_cloud())
  Sys.setenv(R_CONFIG_ACTIVE = "default")
  expect_false(kit_is_cloud())
})

test_that("kit_cloud_footer(): title, sections (bold name + text, no spaces), links in new tabs", {
  out <- html(kit_cloud_footer(
    list("一、資料" = c("第一句，", "第二句。"), "二、聲明" = "照現況提供。"),
    links = c("Posit 安全說明" = "https://example.org/a", "GitHub" = "https://example.org/b")
  ))
  expect_match(out, '<footer id="kit-cloud-terms" class="kit-cloud-footer">', fixed = TRUE)
  expect_match(out, '<div class="kit-cloud-footer-title">雲端版使用須知</div>', fixed = TRUE)
  expect_match(out, "<strong>一、資料。</strong>第一句，第二句。", fixed = TRUE)
  expect_match(out, "<strong>二、聲明。</strong>照現況提供。", fixed = TRUE)
  expect_match(out, paste0(
    '參考連結：\n    <a href="https://example.org/a" target="_blank" rel="noopener noreferrer">',
    "Posit 安全說明</a>\n     · \n    ",
    '<a href="https://example.org/b" target="_blank" rel="noopener noreferrer">GitHub</a>'
  ), fixed = TRUE)
  out <- html(kit_cloud_footer(c("一、資料" = "x"), title = "使用須知", id = "terms"))
  expect_match(out, '<footer id="terms"', fixed = TRUE)
  expect_false(grepl("參考連結", out))
  expect_error(kit_cloud_footer(list("x")))
})

test_that("kit_advanced(), kit_details_row() and kit_detail() are collapsed details", {
  adv <- html(kit_advanced(shiny::p("x"), id = "adv"))
  expect_match(adv, "<details id=\"adv\" class=\"kit-advanced\">", fixed = TRUE)
  expect_match(adv, "<summary>進階設定</summary>", fixed = TRUE)
  expect_match(adv, "<div class=\"kit-advanced-body\">", fixed = TRUE)
  expect_match(html(kit_advanced("x", open = TRUE)), "<details class=\"kit-advanced\" open>", fixed = TRUE)
  row <- html(kit_details_row(kit_detail("預覽", "內容"), kit_detail("紀錄", "內容", open = TRUE)))
  expect_match(row, "^<div class=\"kit-details\">")
  expect_match(row, "<details class=\"kit-detail\">\\s*<summary>預覽</summary>\\s*<div class=\"kit-detail-body\">內容</div>")
  expect_match(row, "<details class=\"kit-detail\" open>", fixed = TRUE)
})

test_that("kit_settings_line() joins parts with a dot and drops empty ones", {
  expect_match(html(kit_settings_line(list("5 個檔案", NULL, "", NA, "全勤樣本"))),
               "<p class=\"kit-settings-line\">本次：5 個檔案 · 全勤樣本</p>", fixed = TRUE)
  expect_match(html(kit_settings_line("本回合 R1：M03", prefix = NULL)), ">本回合 R1：M03<", fixed = TRUE)
  expect_null(kit_settings_line(c("", NA)))
})
