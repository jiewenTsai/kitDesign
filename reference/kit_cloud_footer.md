# Cloud version usage notes (bottom of the page, small gray text)

A title, a few sections (bold section title followed by a period, then
the body), and a final line of reference links (opening in new tabs).
Section titles run into the body and body pieces are joined into one
paragraph, with no spaces inserted by HTML. The header banner can link
here with `<a href="#kit-cloud-terms">`.

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

  The sections: a named list or character vector; names are section
  titles ("一、資料傳輸與儲存", "1. Data transfer and storage"), values
  are the body text (a character vector, joined directly).

- links:

  Reference links: a named character vector, names are the link text and
  values are URLs; `NULL` omits this line.

- title:

  The title at the top.

- id:

  The footer's id (used by the banner's link).

## Value

`<footer id="kit-cloud-terms" class="kit-cloud-footer">`.

## See also

[`kit_cloud_banner()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_banner.md),
[`kit_is_cloud()`](https://jiewentsai.github.io/kitDesign/reference/kit_is_cloud.md)

## Examples

``` r
# Sections: "1. Data transfer and storage", "2. Disclaimer"
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
