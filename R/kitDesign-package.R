#' kitDesign: the shared Shiny interface of the KIT research tools
#'
#' The interface layer shared by kitJoin, kitsUI and future KIT Shiny apps: the theme
#' ([kit_theme()]), styles and scripts ([use_kit()]), the page ([kit_page()]), and components
#' (`kit_*()`) that follow the KIT design language. The design language is in the `brand/`
#' folder of the package source and on the website, <https://jiewentsai.github.io/kitDesign/>.
#'
#' A new app starts like this:
#'
#' ```r
#' library(kitDesign)
#' ui <- kit_page("KIT ×× 工具", "臺灣幼兒發展調查資料庫", version = "0.1.0", date = "2026-10-31",
#'   package = "kitXxx",
#'   kit_tab_guide("這一頁做什麼。", kit_steps("第一步", "第二步"), "會得到什麼。")
#' )
#' ```
#'
#' The on-screen text of the components is Traditional Chinese (the apps are for researchers in
#' Taiwan). See every component: [kit_gallery()].
#'
#' @keywords internal
"_PACKAGE"

#' 元件樣張 app
#'
#' 一個 app 裡放了每一個元件，內容是 KIT 的例子。
#' 原始碼在 `system.file("examples/gallery", package = "kitDesign")`。
#'
#' @param ... 傳給 [shiny::runApp()] 的參數（例如 `port = 7551`、`launch.browser = FALSE`）。
#' @param brand 用哪個品牌看：`NULL`（預設）是現在的品牌（[kit_current_brand()]，通常是 KIT）；
#'   `"demo"` 是一個藍色系的示範品牌（看換品牌以後的樣子）；或一個 [kit_brand()]。
#' @return [shiny::runApp()] 的結果（app 關掉時）。
#' @examples
#' if (interactive()) kit_gallery()
#' if (interactive()) kit_gallery(brand = "demo")
#' @export
kit_gallery <- function(..., brand = NULL) {
  dir <- system.file("examples", "gallery", package = "kitDesign")
  if (!nzchar(dir)) stop("Could not find the gallery app. Try re-installing kitDesign.", call. = FALSE)
  if (identical(brand, "demo")) brand <- kit_brand_demo()
  if (!is.null(brand)) {
    old <- options(kitDesign.brand = kit_check_brand(brand))
    on.exit(options(old), add = TRUE)
  }
  shiny::runApp(dir, ...)
}
