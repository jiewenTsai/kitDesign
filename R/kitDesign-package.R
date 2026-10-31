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

#' Component gallery app
#'
#' One app holding every component, filled with KIT examples.
#' The source is in `system.file("examples/gallery", package = "kitDesign")`.
#'
#' @param ... Arguments passed to [shiny::runApp()] (e.g. `port = 7551`, `launch.browser = FALSE`).
#' @param brand Which brand to view: `NULL` (default) is the current brand ([kit_current_brand()],
#'   usually KIT); `"demo"` is a blue demo brand (to see how a different brand looks); or a
#'   [kit_brand()].
#' @return The result of [shiny::runApp()] (when the app closes).
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
