# kitDesign: the shared Shiny interface of the KIT research tools

The interface layer shared by kitJoin, kitsUI and future KIT Shiny apps:
the theme
([`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md)),
styles and scripts
([`use_kit()`](https://jiewentsai.github.io/kitDesign/reference/use_kit.md)),
the page
([`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)),
and components (`kit_*()`) that follow the KIT design language. The
design language is in the `brand/` folder of the package source and on
the website, <https://jiewentsai.github.io/kitDesign/>.

## Details

A new app starts like this:

    library(kitDesign)
    ui <- kit_page("KIT ×× 工具", "臺灣幼兒發展調查資料庫", version = "0.1.0", date = "2026-10-31",
      package = "kitXxx",
      kit_tab_guide("這一頁做什麼。", kit_steps("第一步", "第二步"), "會得到什麼。")
    )

The on-screen text of the components is Traditional Chinese (the apps
are for researchers in Taiwan). See every component:
[`kit_gallery()`](https://jiewentsai.github.io/kitDesign/reference/kit_gallery.md).

## See also

Useful links:

- <https://github.com/jiewenTsai/kitDesign>

- <https://jiewentsai.github.io/kitDesign/>

- Report bugs at <https://github.com/jiewenTsai/kitDesign/issues>

## Author

**Maintainer**: Jie-Wen Tsai <tsai.jiewen@gmail.com>

Authors:

- Jie-Wen Tsai <tsai.jiewen@gmail.com>
