# KIT 標誌檔

| 檔案 | 內容 | 用在 |
|---|---|---|
| `kit-logo.svg` | 完整標誌（豆子＋KIT 字樣），向量 | 頁首（`kit_header()`，放大縮小都清楚） |
| `kit-mark.svg` | 只有豆子，向量 | 瀏覽器分頁圖示（favicon） |
| `kit-logo-h512.png`、`kit-logo-h1024.png` | 完整標誌，高 512、1024 px，由 SVG 轉出 | 文件、簡報 |
| `kit-mark-h512.png`、`kit-mark-h1024.png` | 豆子，高 512、1024 px，由 SVG 轉出 | 文件、簡報 |
| `kit-logo-128.png`、`kit-logo-192.png` | 完整標誌，舊的 PNG | `kit_logo_uri(128 或 192, "logo")` |
| `kit-mark-32.png`…`kit-mark-256.png` | 豆子，舊的 PNG | `kit_logo_uri()`、舊瀏覽器的分頁圖示 |
| `kit-logo-original.png` | 作者提供的原圖（600×656） | 原始檔，不直接用 |
| `kit-logo.png`、`kit-mark.png` | 原圖的透明底版本 | 原始檔 |

**SVG 是描出來的**：KIT 沒有向量原始檔，`kit-logo.svg` 與 `kit-mark.svg` 是從 600×656 的原圖
（`kit-logo-original.png`）描成向量，再和原圖逐點比對（不同的像素約 0.006%），顏色是標誌原本的
`#006835`（深綠）、`#aad05f`（豆子）、`#fff57f`（葉子），透明底。之後如果拿到設計師的向量原始檔，
請換掉這兩個 SVG，再重新轉出 PNG。

使用規則（大小、留白、可以放在哪些底色上）見 `../KIT設計語言.md` 的「標誌」一節。
`kitDesign` 套件裡的標誌在 `inst/logo/`（頁首用的 SVG 由 htmlDependency 提供，不是 base64）。
