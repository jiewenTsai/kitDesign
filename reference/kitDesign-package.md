# kitDesign：KIT 研究工具共用的 Shiny 介面

kitJoin、kitsUI 與之後的 KIT Shiny app
共用的介面層：主題（[`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md)）、
樣式與小程式（[`use_kit()`](https://jiewentsai.github.io/kitDesign/reference/use_kit.md)）、頁面（[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)），以及照
「KIT 設計語言」做的元件（`kit_*()`）。設計語言在套件原始碼的 `brand/`
資料夾。

## Details

新的 app 這樣開始：

    library(kitDesign)
    ui <- kit_page("KIT ×× 工具", "臺灣幼兒發展調查資料庫", version = "0.1.0", date = "2026-10-31",
      kit_tab_guide("這一頁做什麼。", kit_steps("第一步", "第二步"), "會得到什麼。")
    )

看所有元件：[`kit_gallery()`](https://jiewentsai.github.io/kitDesign/reference/kit_gallery.md)。

## See also

Useful links:

- <https://github.com/jiewenTsai/kitDesign>

- <https://jiewentsai.github.io/kitDesign/>

- Report bugs at <https://github.com/jiewenTsai/kitDesign/issues>

## Author

**Maintainer**: KIT Join Tool <joinkit@example.com>

Authors:

- KIT Join Tool <joinkit@example.com>
