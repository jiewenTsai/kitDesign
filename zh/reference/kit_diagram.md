# 圖解：處理前的小表 → 處理後的小表，下面一行白話說明（Diagram）

放進
[`kit_tab_guide()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_tab_guide.md)
的 `diagram`。窄螢幕（≤ 576px）時「前」在上、箭頭朝下、「後」在下。
每張小表 2–3 列，用一般的名稱（id、score、wave），不用某個資料庫的欄名。

## Usage

``` r
kit_diagram(before, after, caption, arrow = "→")
```

## Arguments

- before:

  處理前的小表：一個
  [`kit_dg_table()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_dg_table.md)
  或它們的 list（並排）。

- after:

  處理後的小表：一個
  [`kit_dg_table()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_dg_table.md)。

- caption:

  一行白話說明（`<figcaption>`）。

- arrow:

  中間的箭頭。

## Value

`<figure class="kit-diagram">`。

## Examples

``` r
kit_diagram(
  list(kit_dg_table(data.frame(id = 1:2, t1 = c(3, 5)), "第 1 波"),
       kit_dg_table(data.frame(id = c(1, 3), t2 = c(4, 6)), "第 2 波")),
  kit_dg_table(data.frame(id = 1:3, t1 = c(3, 5, NA), t2 = c(4, NA, 6)), "結果"),
  "依 id 接起來：沒有出席的那一波是空的。"
)
#> <figure class="kit-diagram">
#>   <div class="kit-dg-flow">
#>     <div class="kit-dg-before">
#>       <table class="kit-dg-table">
#>         <caption>第 1 波</caption>
#>         <thead>
#>           <tr>
#>             <th scope="col">id</th>
#>             <th scope="col">t1</th>
#>           </tr>
#>         </thead>
#>         <tbody>
#>           <tr>
#>             <td>1</td>
#>             <td>3</td>
#>           </tr>
#>           <tr>
#>             <td>2</td>
#>             <td>5</td>
#>           </tr>
#>         </tbody>
#>       </table>
#>       <table class="kit-dg-table">
#>         <caption>第 2 波</caption>
#>         <thead>
#>           <tr>
#>             <th scope="col">id</th>
#>             <th scope="col">t2</th>
#>           </tr>
#>         </thead>
#>         <tbody>
#>           <tr>
#>             <td>1</td>
#>             <td>4</td>
#>           </tr>
#>           <tr>
#>             <td>3</td>
#>             <td>6</td>
#>           </tr>
#>         </tbody>
#>       </table>
#>     </div>
#>     <div class="kit-dg-arrow" aria-hidden="true">→</div>
#>     <div class="kit-dg-after">
#>       <table class="kit-dg-table">
#>         <caption>結果</caption>
#>         <thead>
#>           <tr>
#>             <th scope="col">id</th>
#>             <th scope="col">t1</th>
#>             <th scope="col">t2</th>
#>           </tr>
#>         </thead>
#>         <tbody>
#>           <tr>
#>             <td>1</td>
#>             <td>3</td>
#>             <td>4</td>
#>           </tr>
#>           <tr>
#>             <td>2</td>
#>             <td>5</td>
#>             <td>
#>               <span class="kit-dg-empty">（空）</span>
#>             </td>
#>           </tr>
#>           <tr>
#>             <td>3</td>
#>             <td>
#>               <span class="kit-dg-empty">（空）</span>
#>             </td>
#>             <td>6</td>
#>           </tr>
#>         </tbody>
#>       </table>
#>     </div>
#>   </div>
#>   <figcaption class="kit-dg-caption">依 id 接起來：沒有出席的那一波是空的。</figcaption>
#> </figure>
```
