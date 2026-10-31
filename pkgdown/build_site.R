# 建雙語網站：英文（預設）在 docs/，中文在 docs/zh/。
# 函式說明：R/ 的 roxygen 與 man/ 是英文（R 裡的 ?kit_page 也是英文）；中文說明在 pkgdown/zh/man/。
# 文章、NEWS、_pkgdown.yml、brand/*.md：中文是原稿，英文翻譯在 pkgdown/en/（路徑和套件一樣）與
# brand/en/。建網站時在一份暫存的套件副本裡，用 pkgdown/en/ 或 pkgdown/zh/ 蓋過同名的檔案。
# 改了一種語言，另一種要跟著改（同一個檔名）。
# 用法（在套件根目錄）：Rscript pkgdown/build_site.R
# 文件開頭切換語言的那一行（README 與 brand/ 的文件都有）
lang_line <- "^\\[?English\\]?(\\(.*\\))? \\| \\[?繁體中文"

build_lang <- function(lang, dest) {
  src <- tempfile("kitDesign-")
  dir.create(src)
  keep <- setdiff(list.files(".", all.files = TRUE, no.. = TRUE), c(".git", "docs"))
  file.copy(keep, src, recursive = TRUE)
  overlay <- file.path("pkgdown", lang)
  for (f in list.files(overlay, recursive = TRUE, all.files = TRUE)) {
    dir.create(dirname(file.path(src, f)), recursive = TRUE, showWarnings = FALSE)
    file.copy(file.path(overlay, f), file.path(src, f), overwrite = TRUE)
  }
  if (lang == "zh") file.copy("README.zh-TW.md", file.path(src, "README.md"), overwrite = TRUE)
  file.remove(file.path(src, "README.zh-TW.md"))
  # README 開頭的「English | 繁體中文」是給 GitHub 看的；網站用導覽列切換
  readme <- file.path(src, "README.md")
  md <- readLines(readme, encoding = "UTF-8")
  md <- md[!grepl(lang_line, md)]
  md <- gsub("](NEWS.md)", "](news/index.html)", md, fixed = TRUE)  # 網站上的更新紀錄
  writeLines(md, readme, useBytes = TRUE)
  pkgdown::build_site(src, override = list(destination = dest),
                      new_process = FALSE, install = FALSE, preview = FALSE)
}

docs <- file.path(getwd(), "docs")
unlink(docs, recursive = TRUE)  # 每次從頭建：英文版建完，中文版才放進 docs/zh/
build_lang("en", docs)
build_lang("zh", file.path(docs, "zh"))
# GitHub Pages：不要跑 Jekyll（pkgdown::build_site_github_pages() 也會放這個檔）
file.create(file.path(docs, ".nojekyll"))
