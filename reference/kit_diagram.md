# Diagram: small table before → small table after, with a plain-language line below

Goes in the `diagram` of
[`kit_tab_guide()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_guide.md).
On narrow screens (≤ 576px) "before" is on top, the arrow points down,
and "after" is below. Each small table has 2–3 rows and uses generic
names (id, score, wave), not column names from a particular database.

## Usage

``` r
kit_diagram(before, after, caption, arrow = "→")
```

## Arguments

- before:

  The small table(s) before: one
  [`kit_dg_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_dg_table.md)
  or a list of them (side by side).

- after:

  The small table after: one
  [`kit_dg_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_dg_table.md).

- caption:

  One plain-language line (`<figcaption>`).

- arrow:

  The arrow in the middle.

## Value

`<figure class="kit-diagram">`.

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
# "Wave 1", "Wave 2", "Result";
# caption: "Joined by id: a wave the child missed is empty."
```
