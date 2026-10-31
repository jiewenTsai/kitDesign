# 建雙語網站：英文（預設）在 docs/，中文在 docs/zh/。
# 中文是原稿（R/ 的 roxygen、man/、vignettes/、NEWS.md、_pkgdown.yml、brand/*.md）。
# 英文翻譯放在 pkgdown/en/（路徑和套件一樣）與 brand/en/；建英文版時在一份暫存的
# 套件副本裡蓋過中文的檔案。中文改了，英文要跟著改（同一個檔名）。
# 用法（在套件根目錄）：Rscript pkgdown/build_site.R
# 文件開頭切換語言的那一行（README 與 brand/ 的文件都有）
lang_line <- "^\\[?English\\]?(\\(.*\\))? \\| \\[?繁體中文"

build_lang <- function(lang, dest) {
  src <- tempfile("kitDesign-")
  dir.create(src)
  keep <- setdiff(list.files(".", all.files = TRUE, no.. = TRUE), c(".git", "docs"))
  file.copy(keep, src, recursive = TRUE)
  if (lang == "en") {
    en <- file.path("pkgdown", "en")
    files <- list.files(en, recursive = TRUE, all.files = TRUE)
    for (f in files) {
      dir.create(dirname(file.path(src, f)), recursive = TRUE, showWarnings = FALSE)
      file.copy(file.path(en, f), file.path(src, f), overwrite = TRUE)
    }
  } else {
    file.copy("README.zh-TW.md", file.path(src, "README.md"), overwrite = TRUE)
  }
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
