test_that("kit_code_panel() is a collapsed detail with a uiOutput", {
  out <- html(kit_code_panel("code"))
  expect_match(out, "<details class=\"kit-detail\">\\s*<summary>用 R 怎麼做</summary>")
  expect_match(out, "id=\"code\" class=\"shiny-html-output\"", fixed = TRUE)
  expect_match(html(kit_code_panel("c", title = "R 程式", open = TRUE)), "<details class=\"kit-detail\" open>", fixed = TRUE)
})

test_that("kit_code_blocks() has a note, a label + copy row and escaped code per version", {
  out <- html(kit_code_blocks(list(tidy = "x <- a |> f()", base = "y <- b[b > 1]")))
  expect_match(out, "<p class=\"kit-hint\">以下程式碼依你目前的設定產生，是簡化的示範。</p>", fixed = TRUE)
  expect_match(out, "<div class=\"kit-code-head\">\\s*<strong>tidyverse 版</strong>")
  expect_match(out, "<strong>base R 版</strong>", fixed = TRUE)
  expect_match(out, "<button type=\"button\" class=\"btn btn-sm btn-outline-secondary kit-copy\">複製</button>",
               fixed = TRUE)
  expect_match(out, "<pre><code>x &lt;- a |&gt; f()</code></pre>", fixed = TRUE)
  expect_match(out, "<pre><code>y &lt;- b[b &gt; 1]</code></pre>", fixed = TRUE)
  # base = NULL：只有 tidyverse 版
  one <- html(kit_code_blocks(list(tidy = "x", base = NULL), note = NULL))
  expect_false(grepl("base R", one, fixed = TRUE))
  expect_false(grepl("kit-hint", one, fixed = TRUE))
  named <- html(kit_code_blocks(c("kits 版" = "fit <- 1")))
  expect_match(named, "<strong>kits 版</strong>", fixed = TRUE)
  plain <- html(kit_code_blocks(c("a <- 1", "b <- 2")))
  expect_match(plain, "<strong>R</strong>", fixed = TRUE)
  expect_match(plain, "<pre><code>a &lt;- 1\nb &lt;- 2</code></pre>", fixed = TRUE)
})

test_that("kit_code() validates its input", {
  expect_s3_class(kit_code("x <- 1"), "kit_code")
  expect_equal(kit_code(c("a <- 1", "b <- 2"), "kits 版")$code, "a <- 1\nb <- 2")
  expect_error(kit_code(1), "`code` must be a character vector")
  expect_error(kit_code(NA_character_), "`code` must be")
  expect_error(kit_code("x", label = ""), "`label` must be one non-empty string")
  expect_error(kit_code("x", label = c("a", "b")), "`label`")
  expect_error(kit_code("x", width = 5), "`width`")
  expect_null(kit_code("x", width = NULL)$width)
})

test_that("kit_code() renders head, copy button and wrapped code via as.tags()", {
  long <- paste0("picks <- c(", paste(sprintf("\"M%02d\"", 1:16), collapse = ", "), ")")
  x <- kit_code(long, "tidyverse 版")
  out <- html(x)
  expect_match(out, "<div class=\"kit-code-head\">\\s*<strong>tidyverse 版</strong>")
  expect_match(out, "kit-copy", fixed = TRUE)
  code <- regmatches(out, regexpr("(?s)<pre><code>.*</code></pre>", out, perl = TRUE))
  lines <- strsplit(gsub("</?(pre|code)>", "", code), "\n", fixed = TRUE)[[1]]
  expect_gt(length(lines), 1)
  expect_true(all(kit_code_cols(lines) <= 70))
  # 放進 tagList() 也一樣
  expect_match(html(shiny::tagList(shiny::p("前"), x)), "kit-code-head", fixed = TRUE)
  # 不換行
  expect_match(html(kit_code(long, width = NULL)), '"M15", "M16")', fixed = TRUE)
})

test_that("kit_code() warns (does not stop) when a line stays too long after wrapping", {
  long <- paste0("df <- readr::read_csv(\"", strrep("a", 80), ".csv\")")
  expect_warning(out <- html(kit_code(long)), "still longer than 70 columns")
  expect_match(out, strrep("a", 80), fixed = TRUE)
  expect_warning(kit_code_blocks(list(tidy = long)), "still longer than 70")
  expect_no_warning(kit_code_blocks(list(tidy = long), width = NULL))
  expect_no_warning(kit_code_blocks(list(tidy = "x <- 1")))
})

test_that("format() and print() show the label and the wrapped code", {
  x <- kit_code("x <- 1", "kits 版")
  expect_equal(format(x), c("## kits 版", "x <- 1"))
  expect_output(print(x), "## kits 版")
})

test_that("kit_code_blocks() accepts kit_code objects", {
  out <- html(kit_code_blocks(list(kit_code("a <- 1", "第一版"), kit_code("b <- 2", "第二版"))))
  expect_match(out, "<strong>第一版</strong>", fixed = TRUE)
  expect_match(out, "<strong>第二版</strong>", fixed = TRUE)
  expect_match(html(kit_code_blocks(kit_code("z <- 3"))), "z &lt;- 3", fixed = TRUE)
})

test_that("the gallery's code examples fit in 70 columns", {
  app <- system.file("examples", "gallery", "app.R", package = "kitDesign")
  env <- new.env()
  source(app, local = env, encoding = "UTF-8")
  snippets <- c(
    "joined <- dplyr::left_join(t1, t2, by = \"subj_id\")",
    "joined <- merge(t1, t2, by = \"subj_id\", all.x = TRUE)"
  )
  expect_true(all(kit_code_cols(snippets) <= 70))
  # 故意很長的那一個（測試程式碼框不撐破版面）：有一行換不開
  expect_true(any(kit_code_cols(strsplit(kit_code_wrap(env$long_code), "\n")[[1]]) > 70))
})

test_that("kit_render_code_panel() shows the code, or one line when there is none", {
  shiny::testServer(function(id) shiny::moduleServer(id, function(input, output, session) {
    code <- shiny::reactiveVal(NULL)
    output$code <- kit_render_code_panel(function() code())
    session$userData$code <- code
  }), {
    out <- output$code$html
    expect_match(as.character(out), "先選資料，這裡才會有程式碼。", fixed = TRUE)
    session$userData$code(list(tidy = "x <- 1"))
    session$flushReact()
    out <- as.character(output$code$html)
    expect_match(out, "<strong>tidyverse 版</strong>", fixed = TRUE)
    expect_match(out, "x &lt;- 1", fixed = TRUE)
  })
  shiny::testServer(function(id) shiny::moduleServer(id, function(input, output, session) {
    output$code <- kit_render_code_panel(function() stop("not ready"), empty = "還沒有。")
  }), {
    expect_match(as.character(output$code$html), "還沒有。", fixed = TRUE)
  })
})
