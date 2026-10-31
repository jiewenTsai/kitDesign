# 雲端版使用須知（頁面最下面，灰色小字）

一個標題、幾段（粗體的段名接句號，後面是內文）、最後一行參考連結（開新分頁）。
段名接內文、內文串成一段，HTML 不會在中間插入空白。頁首的橫幅可以用
`<a href="#kit-cloud-terms">` 連到這裡。

## Usage

``` r
kit_cloud_footer(
  sections,
  links = NULL,
  title = "雲端版使用須知",
  id = "kit-cloud-terms"
)
```

## Arguments

- sections:

  每一段：具名 list 或字串向量，名字是段名（「一、資料傳輸與儲存」），
  值是內文（字串向量，直接接起來）。

- links:

  參考連結：具名字串向量，名字是連結的字、值是網址；`NULL` 不放這一行。

- title:

  最上面的標題。

- id:

  頁尾的 id（橫幅的連結用）。

## Value

`<footer id="kit-cloud-terms" class="kit-cloud-footer">`。

## See also

[`kit_cloud_banner()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_banner.md)、[`kit_is_cloud()`](https://jiewentsai.github.io/kitDesign/reference/kit_is_cloud.md)

## Examples

``` r
kit_cloud_footer(
  sections = list(
    "一、資料傳輸與儲存" = c("本雲端版部署於 Posit Connect Cloud。",
                             "本工具不另行保存您的資料。"),
    "二、免責聲明" = "本工具以現況提供。"
  ),
  links = c("Posit Trust Center" = "https://trust.posit.co")
)
#> <footer id="kit-cloud-terms" class="kit-cloud-footer">
#>   <div class="kit-cloud-footer-title">雲端版使用須知</div>
#>   <p>
#>     <strong>一、資料傳輸與儲存。</strong>本雲端版部署於 Posit Connect Cloud。本工具不另行保存您的資料。
#>   </p>
#>   <p>
#>     <strong>二、免責聲明。</strong>本工具以現況提供。
#>   </p>
#>   <p>
#>     參考連結：
#>     <a href="https://trust.posit.co" target="_blank" rel="noopener noreferrer">Posit Trust Center</a>
#>   </p>
#> </footer>
```
