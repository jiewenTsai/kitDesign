# KIT design language

> This page is `brand/en/design-language.md` in kitDesign (the English
> translation of `brand/KIT設計語言.md`, which is the source of truth).
> To see what the components look like, see
> [Components](https://jiewentsai.github.io/kitDesign/articles/components.md).

> **Easy to see, safe to click, results first.**

The design language shared by the KIT research tools (kitJoin, kitsUI,
and future Shiny apps). New apps follow this document, so once people
learn one tool, they can use the others.

- **Companions**:
  - Implementation: the R package **kitDesign**
    ([`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md),
    components, modules, the CSS in `inst/www/`). This document lives in
    kitDesign’s `brand/`, and this copy is the source of truth.
  - Design system (live samples, tokens, logo):
    <https://claude.ai/artifact/GFN5Q5ie9jAHKwmsBaxb2M> (private;
    visible only when shared)
  - [\_brand.yml](https://github.com/jiewenTsai/kitDesign/blob/main/brand/_brand.yml):
    design variables such as colors and fonts;
    [logo/](https://github.com/jiewenTsai/kitDesign/tree/main/brand/logo):
    the logo (SVG, PNG)
  - What every component looks like:
    [`kitDesign::kit_gallery()`](https://jiewentsai.github.io/kitDesign/reference/kit_gallery.md)
- **Status**: v1.1 (2026-10-31). v1.0 merged v0.2’s “additions after
  design review” into the main text; v1.1 adds kitDesign 0.2.0’s charts
  ([`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)),
  the danger button, the heatmap color scale, the step card rule “choose
  first, refine later”, and “Author’s decisions” 6–9. Where the spec and
  the code differ, this document follows the code; the differences are
  listed in the last section.

------------------------------------------------------------------------

## Who we design for

|  |  |
|----|----|
| **Who** | Researchers and research assistants, mostly aged 40–60; they use SPSS and Excel, and may not write R |
| **How often** | A few times a year, an hour or two each time; every return feels like the first time |
| **Doing what** | Working with real research data: joining, converting, calibrating, scoring. **Wrong results end up in papers** |
| **Where** | Desktops or laptops in the office, 13–27 inch screens; sometimes a phone to check results |
| **Biggest fears** | Not knowing what to click next; clicking and not knowing whether it worked; results that look right but are wrong |

Priority: **correct \> clear \> good-looking**. Looking good makes
people willing to use the tool and comfortable reading it, but it must
never cost the first two. Keep the design simple and clean.

## Seven principles

1.  **One lead per page.** Each page has exactly one primary button
    (`nb-lime`), for example “開始校準” (“Start calibration”).
    Everything else is supporting cast and steps back visually.
2.  **Results first, details later.** After a click, the first thing
    people see is the status box: a one-sentence conclusion, two or
    three key points, and one table or one chart. Parameter tables,
    logs, check tables, and R code go in the details row, opened on
    demand.
3.  **Problems must be seen.** The most dangerous case is “looks
    successful but is actually wrong”. If anything needs attention, the
    status cannot be a plain 【完成】 (“Done”). Actions that change
    results (skipping a scale, treating codes as missing values) are
    clicked by the user, never done automatically.
4.  **A frame is a unit.** Anything with a black frame is either
    something you can operate or a complete unit (a button, an input,
    one result, one chart). No frames inside frames, and no decorative
    frames.
5.  **Quiet supporting cast.** Explanations, hints, and technical
    details use the `hint` size and `text-hint` color, no frame, and are
    collapsed by default. First-time users can find them; experienced
    users are not slowed down.
6.  **Every page looks the same.** The same page skeleton, the same
    components, the same wording. Learn one page and you can use the
    others; learn kitJoin and you can use kitsUI.
7.  **Plain language first.** The main screen uses short sentences in
    the Chinese commonly used in Taiwan. English terms (function names,
    column names) go in the details or in downloaded files.

## Visual foundations

### Style: restrained neo-brutalism

We keep three traits: black frames, offset shadows with zero blur, and
flat color blocks with black text. Everything is toned down for
middle-aged users and long reading sessions:

| Typical neo-brutalism | The KIT way | Why |
|----|----|----|
| 3–5px frames | `bw-frame` 2px | Matches the stroke weight of the rounded typeface; easy on the eyes over time |
| 6–8px shadows | `shadow-header` 4px, `shadow-card` 3px, `shadow-sm` 2px | Shadows only mean “clickable” or “a result” |
| Large areas of saturated color | Saturated color only on the header, the primary button, and the current step | Large bright areas are tiring over time |
| Deliberate misalignment | Aligned, regular spacing | A tool should be predictable |

### Color

Colors are defined by role, and each role has exactly one color.

- **Background**: the whole page is `nb-page` (off-white); cards,
  inputs, tables, and charts use `nb-card`. Light only; there is no dark
  mode.
- **Ink**: all text, frames, and shadows are `nb-ink`. **Text on color
  blocks is always `nb-ink`**, never white. The only white text is the
  black header row of the main data table.
- **Lead**: `nb-lime` is used only for the header, the primary button,
  the current tab, the current step number, and the selected item in a
  dropdown. Never use it as a text color.
- **Brand and links**: `nb-green` (the same color as the logo’s dark
  green) is for links, progress bars, ✓, and checkboxes. On hover,
  `nb-green-hover`. Never use it as a large background.
- **Four semantic colors**; seeing the color tells you the meaning:
  - `nb-mint` done
  - `nb-yellow` needs attention (also used for 【要重新執行】 (“Run
    again”))
  - `nb-salmon` stopped (also used for the danger button)
  - `nb-sky` information
- **Color must never be the only signal.** The status box always has a
  text label: 【完成】 (“Done”), 【完成，但請注意】 (“Done, but note”),
  【停下來】 (“Stopped”), 【要重新執行】 (“Run again”); the ✓ on tabs
  and the ! in checklists both carry hidden text.
- **These are the only grays**:
  - Supporting text `text-hint`
  - Disabled text `text-disabled`
  - Lines `line`, `line-soft`
  - Disabled frames `border-disabled`
- **Emphasis text**: “還差：…” (“Still needed: …”) uses `text-todo`; the
  checklist ! uses `text-decide`; a single problem in a list uses
  `text-stop`.
- **Logo colors** (`logo-bean`, `logo-leaf`) are only for the logo and
  illustrations, never for the interface.
- **Charts**: categorical colors use the colorblind-friendly Okabe–Ito
  palette, taken in order: `chart-blue`, `chart-orange`, `chart-green`,
  `chart-purple`, `chart-sky`, `chart-vermillion`. Reference lines and
  bands use `chart-neutral`; continuous values use `chart-sequential`.

### Typography

- One rounded typeface throughout: **Chiron GoRound TC** (`sans`, Google
  Fonts, weights 400, 700, 900).
  - Hierarchy comes from weight and size, not from switching typefaces.
  - Use weights 400 and 700; the header h1 may go to 900. Secondary
    buttons and “no problem” checklist items use 500.
- Code, raw messages, and values in diagrams: **JetBrains Mono**
  (`mono`), falling back to the rounded typeface for Chinese. Ligatures
  are always off (`font-variant-ligatures: none`), so `<-` and `|>`
  display as typed.
- Six type sizes, base **17px** (`html { font-size: 17px }`):
  - `display`: header h1
  - `h4`: section titles
  - `h5`: subtitles, step card titles, the primary button, the first
    line of the status box
  - `body`: body text
  - `small`: tables, step summaries
  - `hint`: hints, collapsible titles, group labels, the version line
- The smallest size is `hint` (about 14px); anything smaller is for
  chart tick labels only.
- Put a half-width space between Chinese and English or numbers: 「688
  人」, 「依 SPSS 數值標籤」. Numbers of four digits or more get
  thousands separators: 「3,389 人」.

### Frames, shadows, corners

- **Frames**:
  - Top-level components use `bw-frame` (2px) `nb-ink`.
  - Table row dividers and secondary buttons use `bw-line` (1.5px).
  - Diagram grid lines use `bw-hair` (1px).
- **Corners**: everything `radius` (8px); progress bars `radius-bar`;
  step numbers `radius-round`.
- **Shadows**, from largest to smallest:
  - `shadow-header`: the header only.
  - `shadow-card`: results, including the status box, charts, the
    current step card, and the primary button.
  - `shadow-sm`: clickable things, including tabs, regular buttons,
    dropdowns, and focused inputs.
  - No shadow: callouts, code, inputs (when not focused), finished or
    not-yet-available step cards, tables, secondary buttons. A callout
    is not a result, so it has no shadow; that keeps the status box
    always the most prominent box on the page.
- **Interaction**:
  - On hover, move 1px down and to the right; the shadow becomes
    `shadow-hover`.
  - On press, move all the way and drop the shadow; animation 80ms.
  - The current tab looks “pressed”: lime, no shadow, offset 2px.
  - When the user has set “reduce motion”, no offset and no animation.
- **Keyboard focus**: 3px `focus` outline, offset 3px outward. Tabs,
  file buttons, and checkboxes all need it.

### Spacing and layout

- Spacing uses a 0.25rem unit, from `sp-1` (0.25rem) to `sp-5` (2.4rem).
  - Between sections: `sp-5`.
  - Between components in the same section: `sp-3`.
  - Between buttons in a row: `sp-2`.
- Content is at most `content-max` (1140px) wide, centered; `gutter` on
  the left and right, 1rem at ≤ `bp-tablet`.
- When settings and results sit side by side: settings on the left 1/3,
  results on the right 2/3; at ≤ `bp-tablet` they stack, settings on
  top.
- Tables are as wide as their content, not stretched; at most the layout
  width, and they scroll sideways inside their own frame when wider.

## Icons

- Text symbols only:
  - ✓: done, no problem
  - !: needs a decision
  - i: reminder
  - →: next step, leaves this page
  - ▸／▾: collapse
  - ↑↓: sort
  - ⬇: download
  - ①–④: only for tabs of an ordered workflow
- No emoji and no other icon fonts.
- Icons always come with text; symbols next to text get
  `aria-hidden="true"`.
- Each symbol has exactly one meaning.

## Logo

- The header uses the full logo `kit-logo` (bean + KIT wordmark), 5.6rem
  tall; 3.6rem on phones. The browser tab icon uses only the bean,
  `kit-mark`.
- Leave clear space of at least 1/4 of the logo height on all sides. It
  may sit on `nb-lime`, `nb-page`, or `nb-card`; not on status colors or
  `nb-green`.
- Do not change its colors or proportions, and do not add frames or
  shadows. Use `alt=""` when the tool name is already next to it.

## Components

Each component lists its purpose, R function, appearance, rules, and
don’ts. Live samples are on the design system’s components page.

### Header

The header tells users which tool this is and which version; an app has
exactly one, at the very top.

- **R**:
  [`kit_header()`](https://jiewentsai.github.io/kitDesign/reference/kit_header.md)
  (kit_theme.R), reads Version and Date from DESCRIPTION.
- **Appearance**:
  - `nb-lime` block, `bw-frame` frame, `shadow-header`.
  - Full logo on the left (5.6rem tall); on the right the tool name
    (`display`), one line of tagline (bold), and one line of version
    (`hint`).
- **You provide**: the tool name (“KIT ×× 工具”, “KIT ×× tool”) and the
  tagline (database name · what this tool does).
- **Rules**:
  - The version line is always there; it is needed when reporting
    problems.
  - Do not change the tool name when testing with other data.
  - Phones (≤ 576px): logo 3.6rem, h1 1.35rem.
- **Don’t**: put buttons or navigation in the header; change the logo’s
  colors or proportions, or put a frame around it.

### Step tabs (NavTabs)

Step tabs are the main navigation inside a tool: a row of clickable
blocks; the current one is lime, finished ones get a ✓, and
not-yet-available ones are gray.

- **Two kinds**:
  - **Ordered workflow** (kitsUI): ① 資料 → ② 題目校準 → ③ 連結 → ④
    受試者評分 (① Data → ② Item calibration → ③ Linking → ④ Respondent
    scoring), with circled numbers.
  - **Not every page is required** (kitJoin): three groups, unnumbered,
    each with a `hint` group label above it:
    - 準備 (Prepare)
    - 做出資料（選一個） (Make the data (pick one))
    - 其他工具 (Other tools)
- **R**: kitsUI uses `navset_tab` plus the states from `kit_tabs_js()`;
  kitJoin draws the tab bar with
  [`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md),
  and the real tabs are a `tabsetPanel(type = "hidden")`, so
  [`updateTabsetPanel()`](https://rdrr.io/pkg/shiny/man/updateTabsetPanel.html)
  works as usual.
- **Appearance**:
  - White background, `bw-frame` frame, `shadow-sm`.
  - Current tab `nb-lime`, no shadow, moved 2px down and to the right
    (the pressed look).
  - Standalone small tools and “使用手冊” (“User guide”): dashed frame,
    no shadow, placed at the far right.
- **States**:
  - Done: ✓ (`nb-green`), plus hidden text 「（已完成）」 (“(done)”).
  - Not yet available: `bg-disabled` background, `text-disabled` text;
    on hover, explains what must be done first.
  - Needs re-running: the ✓ is removed.
- **Rules**:
  - Tab names are “noun + verb”: 檔案上傳 (file upload), 遺漏值處理
    (missing value handling).
  - At ≤ 768px the tabs stay in one row and scroll sideways; they do not
    wrap.
- **Don’t**: wrap the tabs in another big frame; use numbers that imply
  every step is required when the steps are actually alternatives.

### Page guide (“What this page does”) (PageGuide)

“這一頁做什麼” (“What this page does”) is a one-line explanation at the
top of each tab, collapsed by default; first-time users open it to see
the steps.

- **R**:
  `kit_tab_guide(goal, steps, output, technical = NULL, note = NULL, diagram = NULL)`.
- **Appearance**:
  - No frame, `hint` size, `text-hint` color, with a faint `line` rule
    below.
  - “看步驟 ▸” (“See steps ▸”) is underlined `nb-green` text.
- **You provide**:
  - `goal`: one sentence, at most 30 characters.
  - `steps`: 3–6 points.
  - `output`: what you get.
  - Optional: `note` for extra notes, `technical` (one more collapsed
    level), `diagram` (see Diagram).
- **Don’t**: open it by default; put settings or buttons inside it; make
  it a card.

### Button

There are four kinds of buttons, and each page has only one primary
button; labels start with a verb and say clearly what happens on click.

- **R**: `kit_button(id, label, kind = "secondary")`, where `kind` is
  `"primary"`, `"secondary"`, or `"danger"`; a regular button is just
  the default look of
  [`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html).
- **Primary button** (`btn-primary`):
  - `nb-lime` background, `h5` size, `shadow-card`, height ≥ 48px.
  - One per page, plus the “下一步” (“Next step”) at the bottom.
- **Regular button**
  ([`actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
  default): white background, `bw-frame` frame, `shadow-sm`, height ≥
  40px. Used for in-flow buttons such as “對，下一步” (“Yes, next
  step”).
- **Secondary button** (`kind = "secondary"`,
  `btn-sm btn-outline-secondary`):
  - White background, `bw-line` frame, no shadow, 0.85rem, weight 500,
    height ≥ 36px.
  - Used for download, select all, example files, move up/down, copy.
- **Danger button** (`kind = "danger"`, `btn-sm btn-danger`):
  - `nb-salmon` background, `nb-ink` text, `bw-line` frame, same size as
    the secondary button; stays `nb-salmon` on hover and press.
  - When disabled it uses the disabled look (`bg-disabled` background),
    not salmon.
  - Used for delete, remove, and “這一回合不做” (“Skip this round”).
- **Disabled**: `bg-disabled` background, `text-hint` text,
  `border-disabled` frame, no shadow; do not use opacity. A disabled
  primary button always has a “還差：…” (“Still needed: …”) line above
  it (see ReadyLine).
- **Rules**:
  - Buttons or links that leave the page end with “→”.
  - The recommended option goes first and says 「（建議）」
    (“(recommended)”).
  - When a download is the lead of the page (for example, a response
    file), use `kit-download btn-primary`.
- **Don’t**: write 「確定」 (“OK”) or 「送出」 (“Submit”); put two lime
  buttons on one page; use white text.

### Download button (DownloadButton)

The download button looks the same as a secondary button (⬇ icon +
「下載 CSV」, “Download CSV”), but the file name is saved correctly in
every browser, Chinese names included.

- **R**:
  `kit_download_button(session, id, label, filename, content, class = NULL)`,
  placed inside
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html); in tests,
  click download with `kit_test_download(session, id)`.
- **Appearance**: `<a class="btn btn-default kit-download">`, styled as
  a secondary button; add `class = "btn-primary"` when it is the lead of
  the page.
- **Rules**:
  - The file name is decided when the button is drawn; the last segment
    of the URL, `Content-Disposition` (`filename` and the UTF-8
    `filename*`), and the `download` attribute all use the same file
    name.
  - The file is written only when download is clicked; if it cannot be
    written, a red notification appears (it does not disappear on its
    own) with the plain-language message from
    [`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md)
    as is.
  - `.csv`, `.zip`, and `.html` use their own MIME types; everything
    else (`.sav`, `.csv.gz`) is `application/octet-stream`, so the
    browser does not add an extra extension.
  - The app sets `options(kitDesign.app = "kitJoin")` once in
    `.onLoad()`: it tells the log which app wrote it; when a file name
    is all Chinese, the ASCII fallback name for older browsers is the
    lowercase app name (「第一波.sav」 → 「kitjoin.sav」).
- **Don’t**: use
  [`shiny::downloadHandler()`](https://rdrr.io/pkg/shiny/man/downloadHandler.html)
  (Chinese file names become `missing-download_sav` in some browsers).

### Input

Inputs are white with a black frame, the label above and a small hint
below; the default value is the most common and safest one.

- **R**: Shiny’s own
  [`selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html),
  [`textInput()`](https://rdrr.io/pkg/shiny/man/textInput.html),
  [`radioButtons()`](https://rdrr.io/pkg/shiny/man/radioButtons.html),
  [`checkboxInput()`](https://rdrr.io/pkg/shiny/man/checkboxInput.html);
  hints use `.kit-hint`.
- **Appearance**:
  - White background, `bw-frame` frame, `radius`.
  - `shadow-sm` appears on focus; when a dropdown is open, the selected
    item is `nb-lime`.
  - Checkboxes and radio buttons are always 20px, `nb-green` when
    selected.
- **Rules**:
  - 2–5 options: radio buttons, so all are visible at once; more than 5:
    a dropdown.
  - For required fields, write 「（必填）」 (“(required)”); no red
    asterisks.
  - Advanced options go under 「進階設定 ▸」 (“Advanced settings ▸”)
    (see Details).
  - Values guessed from column names get the pale yellow `bg-guess`
    background, reminding users to check them.
  - **One field, two uses**: for the same column, some files need “pick
    a column in the file” and others need “the same value for every row”
    (cohort TDCYP, wave 2009). Use one dropdown you can type into; do
    not add a separate mode choice.
  - A group of checkboxes needs a group name; more than 8 in a row
    becomes a table or gets “select all”.
- **Don’t**: give inputs a shadow (except on focus); put dropdowns in a
  table without an `aria-label`.

### Status box (StatusBox)

The status box is the first thing to look at after clicking the primary
button: four fixed labels, colors, and wordings.

- **R**:
  [`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md),
  [`kit_done_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_done_status.md)
  (switches to needs-attention automatically when there are warnings),
  `kit_error_status(e, action, todo)`, `kit_stale_status(run_label)`;
  rendered with `make_status_ui()`.
- **Four states**:

| State           | Label                                 | Background  |
|-----------------|---------------------------------------|-------------|
| Done            | 【完成】 (“Done”)                     | `nb-mint`   |
| Needs attention | 【完成，但請注意】 (“Done, but note”) | `nb-yellow` |
| Stopped         | 【停下來】 (“Stopped”)                | `nb-salmon` |
| Needs redoing   | 【要重新執行】 (“Run again”)          | `nb-yellow` |

- **Appearance**: `bw-frame` frame, `shadow-card`; the most prominent
  box on the page.
- **Content**:
  - **First line**: label + one-sentence conclusion, bold, about `h5`
    size. For example 「【完成】串接完成：結果共 3,389 列 × 2,058 欄。」
    (“\[Done\] Join complete: 3,389 rows × 2,058 columns.”)
  - **Then**: at most 3 points, things needing attention first, key
    results after; the rest go under 「還有 N 點」 (“N more”).
  - **When stopped**: always say what to do, with a button or link; R’s
    original message goes under 「原始訊息」 (“Original message”).
- **Rules**:
  - After a run, scroll the status box to the top of the screen
    ([`kit_scroll_to()`](https://jiewentsai.github.io/kitDesign/reference/kit_scroll_to.md)).
  - The key output below the status box is one table or one chart; do
    not add another “result summary” box.
- **Don’t**: invent new labels; put the raw error message at the top
  level.

### Callout

A callout is a reminder you should know before clicking; it is not a
result, so it has no shadow.

- **R**: `kit_callout(..., warn = FALSE)`. Cloud-version reminders look
  the same: the banner below the header
  [`kit_cloud_banner()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_banner.md),
  and the usage notes at the very bottom of the page
  `kit_cloud_footer(sections, links)` (small gray text; the wording
  comes from the app); check whether it is the cloud version with
  [`kit_is_cloud()`](https://jiewentsai.github.io/kitDesign/reference/kit_is_cloud.md).
- **Two kinds**:
  - **Information** (`nb-sky`): general extra notes, for example
    「外部連結不適用：……這不是錯誤」 (“External linking does not apply:
    … this is not an error”).
  - **Attention** (`warn = TRUE`, `nb-yellow`): for example
    「資料裡有疑似遺漏值代碼，建議先到遺漏值處理」 (“The data contain
    what look like missing-value codes; we suggest going to missing
    value handling first”).
- **Appearance**: `bw-frame` frame, no shadow; links inside are bold
  `nb-ink`.
- **Rules**:
  - At most one callout per block.
  - If it can go in the status box, do not open a separate callout.
  - When there is a button, put it outside the frame.
- **Don’t**: use a callout to report results; put a frame inside the
  frame.

### Data table (DataTable)

The data table is one of the leads of the results: white background,
black header row, width follows content; long tables show only the first
rows.

- **R**: `kit_static_table(df)` (integers get thousands separators
  automatically), `kit_preview_table(df, priority_cols, n)`,
  `kit_rows_note(nrow, ncol, shown_rows)`.
- **Appearance**:
  - White background, `bw-frame` outer frame, `nb-ink` header row with
    white text.
  - Thin `bw-line` lines between rows, `bg-stripe` zebra stripes,
    `small` size.
  - Numbers right-aligned, tabular figures.
- **Rules**:
  - An `h4` title above, plus one `hint` line: 「共 157 列，以下前 20
    列。」 (“157 rows; the first 20 are shown below.”). The full table
    is downloadable, or under 「▸ 全部（157 列）」 (“▸ All (157 rows)”).
  - Width follows content, up to the layout width; when wider, it
    scrolls sideways inside `.kit-table-scroll` and does not break the
    layout.
  - **Column names**: function output and the data itself keep English
    names; summary tables the app builds itself may use Chinese;
    downloaded files keep the original column names.
  - Tables inside step cards have no outer frame and use a `bg-stripe`
    (pale) header row, not the black one.
- **Don’t**: stretch to full page width; show hundreds of rows at once.

### Chart

Charts sit in a white card, and each chart answers only one question;
categorical colors use Okabe–Ito, taken in order. A plotly chart is
always passed to
[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
last, so it looks like part of the same app.

- **R**:
  - Colors:
    [`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_colors.md)
    (categorical),
    [`kit_chart_neutral()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_neutral.md)
    (neutral),
    [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md)
    (color scale for continuous values).
  - Look: `kit_plotly_style(p)` (plotly is in Suggests; the app needs
    its own `Imports: plotly`); a downloaded single HTML file needs the
    app’s fonts: `kit_plotly_fonts(p)`
    ([`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
    already attaches them by default).
  - kitsUI’s `kit_chart.R`: `kit_chart_categorical()` (recolors charts
    drawn by kits with the categorical colors), `kit_chart_role()` (role
    colors).
- **Order when used with kits**: kits’
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html) → kitsUI
  recoloring (`kit_chart_categorical()`, `kit_chart_role()`) →
  [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md).
  What kits draws is what you get; the app only applies colors and look.
  - Recoloring and
    [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
    can be swapped: it does not touch colors set by kits or kitsUI.
  - The on-screen chart and the downloaded HTML use the same reactive
    (styled once), so both are identical.

  ``` r

  p <- plot(x$item, type = "category", items = shown)          # kits
  p <- kit_chart_categorical(p)                                 # kitsUI
  kitDesign::kit_plotly_style(p, filename = "item_category")    # last
  ```
- **Appearance** (what
  [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
  does):
  - Card: `nb-card` background, `bw-frame` frame, `shadow-card` (CSS
    `.js-plotly-plot`); the chart itself has a white background, and so
    does the downloaded PNG.
  - Text: all in the rounded typeface (`sans`), `nb-ink`; body 15px,
    legend and hover box 14px, tick labels 13px in `text-hint`.
  - Title: left-aligned, bold, about `h5` (18px); wraps in the browser
    when the chart is too narrow. The kits subtitle (`<sup>`) stays on
    the next line.
  - Axes (every axis, including side-by-side panels): axis line `nb-ink`
    1.5px, only left and bottom (no box on four sides), ticks pointing
    outward, grid lines `line-soft`, zero line `line`. With a single
    chart, the kits outer frame is removed; for side-by-side panels
    (category probability curves, Wright map) the outer frames become
    faint `line` rules, so the panels stay distinguishable.
  - Hover box: white background, `nb-ink` frame, rounded typeface.
  - Legend: no frame; with more than 4 items, or when the longest item
    is wider than 20 columns (a Chinese character counts as 2), it goes
    below the chart, horizontal, left-aligned; otherwise on the right.
    When the chart is narrower than 600px (phones) it always goes below.
    `legend = "keep"` leaves the position unchanged.
  - Color scale: heatmap-type traces switch to
    [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md)
    (very pale lime → `bg-new` → `nb-green`, darker for larger values;
    the minimum is not white, so 0% and empty no-data cells stay
    distinguishable); `colorscale = FALSE` keeps the original scale.
    Color bar text and frame follow the sizes and colors above.
  - Toolbar: no plotly logo; only “download as PNG”, zoom in, zoom out,
    and reset to the original range; in Traditional Chinese.
  - Margins: equally small on all sides; grows automatically when axes,
    legend, or color bar do not fit; axis titles and the legend are at
    least 16px from the card edge, so text is never cut off.
  - Left unchanged: data, axis ranges and ticks, specified colors,
    marker shapes, line widths and dashes, hover and legend text, chart
    height.
- **Palette**:
  - Cohorts, scales, and scores take `chart-blue`, `chart-orange`,
    `chart-green`, `chart-purple`, `chart-sky`, `chart-vermillion` in
    order. plotly’s own default colors are replaced by the Okabe–Ito
    color in the same position.
  - Reference lines, bands, and unjudged points use `chart-neutral`.
  - Continuous values (pass rates and so on) use `chart-sequential`.
- **Rules**:
  - The title above the chart states the question it answers.
  - Text on the chart follows kits’ original (English) and is not
    translated: the screen, the downloaded chart, and the chart from
    running kits in R are identical and can go straight into a paper.
    Labels the user typed (item IDs, domains, cohorts, waves, scale
    names) display as typed, Chinese included.
  - Below the chart, one `hint` line in Chinese explains how to read it;
    legend entries needed for a decision (for example Kept and Dropped
    in the linking chart) get their Chinese meaning in that line.
  - Leave at least 1.2rem between the chart and the explanation below
    it; the explanation must not overlap the x axis.
  - Download the chart with a secondary button (HTML via
    [`htmlwidgets::saveWidget()`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html);
    the toolbar can also save a PNG).
- **Don’t**: use plotly’s default colors or default toolbar; change
  plotly fonts and axis lines separately in the app; answer two
  questions in one chart.

### Details row, advanced settings, settings summary (Details)

The details row holds the “details” in “results first, details later”: a
row of collapsed small-text titles; the open one takes a full line.

- **R**: `kit_details_row(...)` wraps a row of
  `kit_detail(title, ..., open = FALSE)`; advanced options in the
  settings area use `kit_advanced(..., title = "進階設定")`; the
  one-line settings summary above results uses
  `kit_settings_line(parts)`.
- **Appearance**:
  - Titles are small `text-hint` text with ▸, no frame.
  - Opened content has no frame either; opened advanced settings get a
    faint `line` rule on the left.
- **You provide**: a title for each detail (a noun: 「題目參數」 (“Item
  parameters”), 「這一回合的紀錄」 (“Log for this round”), 「用 R
  怎麼做」 (“How to do it in R”)) and its content.
- **Rules**:
  - Collapsed by default.
  - “用 R 怎麼做” (“How to do it in R”) is always the last item in the
    details row.
  - The settings summary goes above the primary button or the results,
    one line of small text: 「本回合 R1：M03、M36 · 參照世代 M03 ·
    沒有固定檔」 (“This round R1: M03, M36 · reference cohort M03 · no
    anchor file”).
- **Don’t**: use accordion cards; stack frames inside details.

### “How to do it in R” panel (CodePanel)

“用 R 怎麼做” (“How to do it in R”) turns the current settings into R
code you can run as is, and always lives in the details row.

- **R**: kitJoin’s `kit_code_blocks(snips)`,
  `kit_code_panel(output_id)`; kitsUI’s component of the same name.
- **Appearance**:
  - Collapsed, it is one line of small text in the details row: 「▸ 用 R
    怎麼做」.
  - Opened, from top to bottom:
    1.  One line of explanation:
        「以下程式碼依你目前的設定產生，是簡化的示範。」 (“The code
        below is generated from your current settings and is a
        simplified example.”)
    2.  The version name (bold) and a 「複製」 (“Copy”) secondary
        button, on the same line.
    3.  The code.
  - Only the code itself has a frame: `bg-code` background, `bw-frame`
    frame, no shadow, `code` size.
  - The code frame is at most the content width of the layout (inside
    the gutters) and must not break the layout when opened.
- **Rules**:
  - When there are two versions (tidyverse, base R), the two “version
    name + code” pairs are stacked.
  - Ligatures are always off: `<-` and `|>` display as typed, so copying
    by hand does not introduce mistakes.
  - **At most about 70 columns per line**: for both code examples and
    explanations, letters, digits, and symbols count as 1 column,
    Chinese characters as 2. Break lines when writing templates; before
    display,
    [`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
    wraps automatically with
    [`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_wrap.md)
    (after commas inside parentheses, and in comments at spaces or
    between Chinese characters; the parse result must be the same before
    and after wrapping), and
    [`kit_code_cols()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_cols.md)
    counts columns per line; lines still too long after wrapping
    (unbreakable long strings) raise a warning (they do not stop).
  - Code that is still long scrolls sideways inside the frame and is not
    wrapped.
- **Don’t**: open it by default; use cards, icons, or a green header;
  stack frames inside the frame.

### Step card (StepCard)

Use step cards when a page has several steps in order: only one step is
open at a time, and finished steps collapse to one line.

- **R**: module
  [`kit_stepcards_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md)／`kit_stepcards_server(id, titles, summaries, checks)`;
  low level
  [`kit_step_card()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_card.md),
  [`kit_step_head()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_head.md),
  [`kit_step_body()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_body.md)
  (steps 1–3 of kitJoin’s 「kits 作答檔」 (“kits response file”)).
  [`kit_steps()`](https://jiewentsai.github.io/kitDesign/reference/kit_steps.md)
  is the step list in the page guide, not a step card.
- **Three states**:
  - **Current step**: white background, `bw-frame` frame, `shadow-card`;
    round number `nb-lime`.
  - **Finished**:
    - Collapsed to one line: round ✓ in `nb-mint`, followed by a
      one-sentence summary (for example 「5 個檔案 · 世代 TDCYP ·
      2009、2011（年）」 (“5 files · cohort TDCYP · 2009, 2011
      (year)”)), and 「改」 (“Edit”) at the far right.
    - Frame `border-disabled`, no shadow.
  - **Not yet available**: `border-disabled` frame, `text-disabled`
    text, says 「先完成第 1 步」 (“Finish step 1 first”).
- **Rules**:
  - Move forward only by clicking 「對，下一步」 (“Yes, next step”) (a
    regular button); go back to a finished step with 「改」 (“Edit”).
  - The primary button sits below all steps, only one; above it a
    「還差：…」 (“Still needed: …”) line (see ReadyLine).
  - Tables in cards have no outer frame and a pale header row; on phones
    each row becomes a block (see FileTable).
  - The clickable area of 「改」 is at least 32px, with `aria-label`
    「改第 N 步：標題」 (“Edit step N: title”); the current step gets
    `aria-current="step"`.
- **Choose first, refine later**: earlier steps ask only for the minimum
  choices (for example step 2 only picks “which columns are items”);
  detailed settings are edited later in a table (for example the item
  table in step 3 sets domain and scoring). The explanation in the
  earlier step must say 「之後在第 N 步還能改」 (“You can still change
  this in step N”), so users do not think everything must be set at
  once.
- **Tables to edit are open directly**: when the lead of a step is a
  table to edit (for example the item table), show the table directly,
  not inside the details row; put a 「下載這張表」 (“Download this
  table”) secondary button next to it, so it can be downloaded at any
  time.
- **Don’t**: open several steps at once; put cards inside cards.

### Checklist

The checklist lists “things to decide” together with “things that are
already fine”, placed before a conversion or a run.

- **Appearance**: one item per row, with a mark on the left:
  - **!** (`text-decide`): needs a decision. One bold sentence, one line
    of small text below saying why, and the decision buttons below that.
  - **✓** (`nb-green`): fine, or already decided. Weight 500; decisions
    the user made say 「（你選的）」 (“(your choice)”), with 「改回來」
    (“Change back”) next to it.
  - **i** (`text-hint`): reminder, no decision needed.
  - Thin `line-soft` lines between rows.
- **Rules**:
  - The recommended option goes first, and its button says 「（建議）」
    (“(recommended)”).
  - A problem only counts as decided after a click (suspected
    missing-value codes, insufficient information); once decided, the
    result’s status box does not remind again.
  - List only what is needed; the per-item table goes under 「▸
    逐題看、逐題改（45 欄）」 (“▸ Review and edit item by item (45
    columns)”), 25 rows per page, searchable.
  - Marks get `aria-hidden="true"`, preceded by hidden text 「要決定：」
    (“To decide:”), 「沒問題：」 (“OK:”), 「提醒：」 (“Note:”).
- **Don’t**: list per-item reminders for hundreds of items.

### Ready line (“what’s still needed”) (ReadyLine)

When the primary button cannot be clicked yet, one line above it says
what is still needed and gives a link to fix it.

- **R**: `kit_ready_line(missing, link = NULL)`; in the server,
  `kit_run_gate(session, output, missing, link)` also disables the
  button; when there are not enough files,
  `kit_need_files(n_files, need = 2L)`.
- **Appearance**: one line of bold `text-todo` 「還差：…」 (“Still
  needed: …”), followed by an `nb-green` link 「到「檔案上傳」加入檔案
  →」 (“Go to ‘File upload’ to add files →”); the disabled primary
  button is below.
- **Rules**:
  - Show the primary button (disabled) from the start, so people know
    what they will click at the end of the page.
  - “Still needed” names the concrete thing and number: 「至少要 2
    個波次的檔案，目前只有 1 個。」 (“Files from at least 2 waves are
    needed; there is only 1 now.”)
  - The server must still check; do not rely only on the disabled
    button.
- **Don’t**: hide the button; repeat the same thing in a yellow callout.

### Next step (NextStep)

“下一步” (“Next step”) sits at the bottom right of the page, appears
only after results are out, and takes the user to the next tab.

- **R**:
  `kit_next_step(text = NULL, button_id = NULL, label = NULL, button = NULL)`.
- **Appearance**: a `hint` sentence on the left (can be a list of
  destinations), and a primary button 「下一步：××× →」 (“Next step: ×××
  →”) on the right.
- **Rules**:
  - When it appears: the status is 【完成】 (“Done”) or
    【完成，但請注意】 (“Done, but note”).
  - Removed when results are outdated (【要重新執行】, “Run again”).
  - The button text names the next page.
- **Don’t**: show it before results are out; place it in the middle of
  the page.

### Diagram

A diagram uses a few small tables to show what the page does (before →
after), placed below “這一頁做什麼” (“What this page does”).

- **R**: `kit_diagram(before, after, caption, arrow = "→")`, with tables
  from `kit_dg_table(df, title, added = NULL)`.
- **Appearance**:
  - Supporting cast: no frame, tables as wide as their content,
    `bw-hair` grid lines, pale `nb-page` header row.
  - Values in the `mono` typeface.
  - Newly added columns have a `bg-new` background and 「（新）」
    (“(new)”) after the column name, so color is not the only cue.
  - Empty cells say 「（空）」 (“(empty)”) in gray.
- **Rules**:
  - Each small table has 2–3 rows and uses generic names (id, score,
    wave), not column names from a specific database.
  - One `hint` line of plain-language explanation below.
  - At ≤ 576px, “before” is on top, the arrow points down, and “after”
    is below.
- **Don’t**: use real data; use the black header row of large data
  tables.

### File table (FileTable)

The file table is the settings table in step cards or upload pages with
“one row per file, one column per setting”; on phones each row becomes a
block.

- **R**: `table.table.kit-file-table`, with `data-label` (the column
  name) on each `<td>`; used in kitJoin’s upload page, step 1 of the
  kits response file, and kitsUI’s item bank selection table.
- **Appearance**:
  - Desktop: a regular table; inside step cards, no outer frame and a
    pale header row.
  - ≤ 576px: the table and every row fill the card width; each row is a
    block, each cell preceded by a `hint` line with the column name,
    with `line` dividers between rows.
- **Rules**:
  - Button positions are fixed in every row: unused 「上移」「下移」
    (“Move up”, “Move down”) get invisible placeholders
    (`btn invisible`, `aria-hidden`), so buttons do not jump sideways.
  - Cells guessed from column names use `bg-guess`.
  - Inputs are at most the layout width.
- **Don’t**: let the whole page scroll sideways on phones.

## Page skeleton

Every tab follows this order from top to bottom (tabs with one primary
button use
[`kit_run_tab_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_tab_ui.md)／[`kit_run_tab_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_tab_ui.md),
which handle the fixed parts and the state flow; the tab only writes its
own settings, run, and results):

    Header (one per app)
    Step tabs (current is lime, finished get ✓, not yet available are gray)
    What this page does: one sentence                         See steps ▸
    Settings (left 1/3)          │ Settings summary and preview (right 2/3)
    Advanced settings ▸
    Still needed: … (while it cannot be clicked)
    [ Primary button ]
    Status box: [Done] one-sentence conclusion + at most 3 points
    Key output: one table (with an h4 title) or one chart
    ▸ Detail 1   ▸ Detail 2   ▸ How to do it in R
                                           [ Next step: ××× → ]

## State flow

    Not available ──(previous step done)──▶ Available ──(click primary button)──▶ Running
           ┌───────────────┬───────────────┬────────────┘
           ▼               ▼               ▼
        [Done]     [Done, but note]     [Stopped]
           └───────┬───────┘     (fix and click again, or click "Skip this round")
                   ▼
       "Next step" button appears; tab gets ✓
    (later changes to settings or files → [Run again]; the tab's ✓ is removed, later tabs turn gray)

- After a run, scroll the status box to the top of the screen (no smooth
  scrolling when motion is reduced).
- Show the first successful result by default; do not preselect one that
  stopped.
- Actions that change results are clicked by the user; the button states
  the consequence clearly (「這一回合不做（題庫與連結不會改變）」, “Skip
  this round (item bank and linking will not change)”), and doing it
  leaves a log entry.

## Phones (≤ 576px)

- The page must never scroll sideways:
  `document.documentElement.scrollWidth` must equal the window width.
  Inputs and tables get `max-width: 100%`.
- Tabs stay in one row and scroll sideways; do not wrap into several
  rows.
- Tables in cards become “one row per block, column name on top”
  (`data-label`).
- The header shrinks, so the first screen shows the page guide and the
  first setting.

## Wording

- Taiwanese Traditional Chinese, short sentences, conversational but not
  casual; one sentence says one thing. The subject is 「你」 (“you”) or
  omitted; never 「使用者」 (“the user”).
- Conclusion first, then the reason:
  「這一回合資訊不足，無法估計：每個人在要估的題只剩一題。」 (“Not
  enough information to estimate this round: each person has only one
  item left to estimate.”)
- Numbers always carry units: 「688 人」 (“688 people”), 「3 個量尺」
  (“3 scales”), 「2,058 欄」 (“2,058 columns”).
- Buttons start with a verb and say clearly what will happen:
  「開始校準」 (“Start calibration”), 「下載 CSV」 (“Download CSV”),
  「到遺漏值處理頁改掉 →」 (“Fix it on the missing value page →”); never
  「確定」 (“OK”) or 「送出」 (“Submit”).
- Error messages always say what to do; R’s original message goes under
  「▸ 原始訊息」 (“▸ Original message”).
- The recommended option goes first, and its button says 「（建議）」
  (“(recommended)”).
- Word list (one word per concept):

| Use this | Not these |
|----|----|
| 停下來 (stopped) | 沒有完成、失敗、錯誤、中止 (not completed, failed, error, aborted) |
| 要注意 (needs attention) | 警告、warning |
| 遺漏值 (missing value) | 缺失值、missing |
| 世代 (cohort) | cohort (English may be added in details) |
| 波次 (wave) | wave (English may be added in details) |
| 這一回合不做 (skip this round) | 略過、排除、skip (skip, exclude) |

- Tab names are “noun + verb”: 檔案上傳 (file upload), 遺漏值處理
  (missing value handling), 資料串接 (data join), 格式轉換 (format
  conversion).
- Table column names: function output and the data itself keep English
  column names; summary tables the app builds itself may use Chinese;
  downloaded files always keep the original column names.

## Accessibility checklist

`<html lang="zh-Hant-TW">`

Body text 17px, smallest text 14px

Text contrast ≥ 4.5:1; frames, focus outlines, graphics ≥ 3:1

Primary button ≥ 48px tall, regular button ≥ 40px, secondary button ≥
36px, collapsible titles and text links ≥ 32px, checkboxes 20px

Keyboard operable, focus has a 3px `focus` outline

State never relies on color alone; there is always text

No offsets or animation under “reduce motion”

Ligatures off in code

At 390px wide the page does not scroll sideways

## Using it in a new Shiny app

New apps no longer copy files: just load the **kitDesign** package. The
theme, styles (`inst/www/*.css`), browser-side scripts
(`inst/www/kit.js`), and logo are all in the package, and every app uses
the same copy.

``` r

# Install
remotes::install_github("jiewenTsai/kitDesign")
```

Add `kitDesign` to `Imports:` in the app package’s DESCRIPTION. Start
the page like this:

``` r

library(kitDesign)

ver <- kit_app_description("kitJoin")   # reads the app's own Version, Date
ui <- kit_page(
  "KIT ×× 工具", "臺灣幼兒發展調查資料庫",  # "KIT ×× tool", "KIT database"
  tagline = "這個工具做什麼",              # "What this tool does"
  version = ver$version, date = ver$date,
  kit_navgroups(groups, "tabs"),          # or kit_flow_tabs(...)
  shiny::tabsetPanel(id = "tabs", type = "hidden", ...)
)
```

[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)
already sets `lang = "zh-Hant-TW"`,
[`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md),
the styles and scripts
([`use_kit()`](https://jiewentsai.github.io/kitDesign/reference/use_kit.md)),
and the header
([`kit_header()`](https://jiewentsai.github.io/kitDesign/reference/kit_header.md)).
When you build the page yourself with `bslib::page_*()`, add
`theme = kit_theme()` and
[`use_kit()`](https://jiewentsai.github.io/kitDesign/reference/use_kit.md).
To start a brand-new app: `kit_new_app(path, title, subtitle)` (it
includes the header, step tabs, an example tab written to the page
skeleton, and tests).

Components come in three kinds:

- **Value objects** (S3): `kit_status` (status box),
  `kit_check`／`kit_checklist` (checklist), `kit_code` (one version of
  code). They check their content when constructed (for example, the
  state can only be idle／success／warning／error／stale), render when
  placed directly in the page or passed to
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html), and
  [`print()`](https://rdrr.io/r/base/print.html) shows a text version.
- **Modules** (stateful components, `*_ui(id)` + `*_server(id)`): step
  tabs `kit_step_tabs_*`, step cards `kit_stepcards_*`, primary button +
  still needed `kit_run_gate_*`, How to do it in R `kit_code_panel_*`.
  One line per page; no state to manage yourself.
- **Markup functions**: all other components, plus low-level versions of
  the two kinds above (older apps can switch over gradually).

Which function to use for each component:

| Component | Functions |
|----|----|
| Header | Already included by [`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md); on its own [`kit_header()`](https://jiewentsai.github.io/kitDesign/reference/kit_header.md), [`kit_app_meta()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_meta.md); version and date [`kit_app_description()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_description.md) |
| Step tabs (NavTabs) | Module `kit_step_tabs_ui(id, ..., groups = )`／`kit_step_tabs_server(id, states, tips)`; low level: [`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md) + [`kit_navgroup()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroup.md), `kit_flow_tabs(aside = )`, [`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_states.md), [`kit_watch_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_watch_tab_states.md) |
| Page guide (PageGuide) | [`kit_tab_guide()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_guide.md), [`kit_steps()`](https://jiewentsai.github.io/kitDesign/reference/kit_steps.md) |
| Button | `kit_button(id, label, kind)`, [`kit_btn_class()`](https://jiewentsai.github.io/kitDesign/reference/kit_btn_class.md) |
| Download button (DownloadButton) | `kit_download_button(session, id, label, filename, content)`; tests [`kit_test_download()`](https://jiewentsai.github.io/kitDesign/reference/kit_test_download.md) |
| Status box (StatusBox) | Value objects [`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md), [`kit_done_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_done_status.md), [`kit_error_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_error_status.md), [`kit_stale_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_stale_status.md) (place directly in the page); low-level rendering [`kit_status_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_status_ui.md); notifications [`kit_notify()`](https://jiewentsai.github.io/kitDesign/reference/kit_notify.md); plain-language errors [`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md) |
| Callout | `kit_callout(..., warn = )`; cloud-version banner [`kit_cloud_banner()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_banner.md), usage notes [`kit_cloud_footer()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_footer.md), detection [`kit_is_cloud()`](https://jiewentsai.github.io/kitDesign/reference/kit_is_cloud.md) |
| Data table (DataTable) | [`kit_static_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_static_table.md), [`kit_preview_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_preview_table.md), [`kit_rows_note()`](https://jiewentsai.github.io/kitDesign/reference/kit_rows_note.md), [`kit_table_scroll()`](https://jiewentsai.github.io/kitDesign/reference/kit_table_scroll.md), [`kit_num()`](https://jiewentsai.github.io/kitDesign/reference/kit_num.md), [`kit_dims()`](https://jiewentsai.github.io/kitDesign/reference/kit_dims.md) |
| Chart | [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md) (look of plotly charts), [`kit_plotly_fonts()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_fonts.md); colors [`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_colors.md), [`kit_chart_neutral()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_neutral.md), [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md) |
| Details row (Details) | [`kit_details_row()`](https://jiewentsai.github.io/kitDesign/reference/kit_details_row.md), [`kit_detail()`](https://jiewentsai.github.io/kitDesign/reference/kit_detail.md), [`kit_advanced()`](https://jiewentsai.github.io/kitDesign/reference/kit_advanced.md), [`kit_settings_line()`](https://jiewentsai.github.io/kitDesign/reference/kit_settings_line.md) |
| How to do it in R (CodePanel) | Module [`kit_code_panel_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md)／[`kit_code_panel_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md); value object `kit_code(code, label)`; wrapping [`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_wrap.md), line width [`kit_code_cols()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_cols.md); low level [`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel.md), [`kit_render_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_render_code_panel.md), [`kit_code_blocks()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_blocks.md) |
| Step card (StepCard) | Module [`kit_stepcards_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md)／`kit_stepcards_server(id, titles, summaries, checks)`; low level [`kit_step_card()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_card.md), [`kit_step_head()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_head.md), [`kit_step_body()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_body.md) |
| Checklist | Value objects [`kit_checklist()`](https://jiewentsai.github.io/kitDesign/reference/kit_checklist.md), `kit_check(state, title, why, actions)`; single problems [`kit_problems()`](https://jiewentsai.github.io/kitDesign/reference/kit_problems.md) |
| Ready line (ReadyLine) | Module [`kit_run_gate_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate_ui.md)／`kit_run_gate_server(id, missing, link)`; low level [`kit_ready_line()`](https://jiewentsai.github.io/kitDesign/reference/kit_ready_line.md), [`kit_run_gate()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate.md), [`kit_need_files()`](https://jiewentsai.github.io/kitDesign/reference/kit_need_files.md) |
| Next step (NextStep) | [`kit_next_step()`](https://jiewentsai.github.io/kitDesign/reference/kit_next_step.md); link to another app [`kit_app_link()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_link.md) |
| Diagram | [`kit_diagram()`](https://jiewentsai.github.io/kitDesign/reference/kit_diagram.md), [`kit_dg_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_dg_table.md) |
| Scroll to results, open collapsibles, warn before leaving | [`kit_scroll_to()`](https://jiewentsai.github.io/kitDesign/reference/kit_scroll_to.md), [`kit_open_details()`](https://jiewentsai.github.io/kitDesign/reference/kit_open_details.md), [`kit_unload_guard()`](https://jiewentsai.github.io/kitDesign/reference/kit_unload_guard.md) |
| Page skeleton + state flow (RunTab) | `kit_run_tab_ui(id, run_label, guide, ...)`／`kit_run_tab_server(input, output, session, run_label, run, done, ...)`: still needed, settings summary, run, status box, notification, scrolling, run again, result details, How to do it in R |

- What every component looks like:
  [`kit_gallery()`](https://jiewentsai.github.io/kitDesign/reference/kit_gallery.md).
- The tool name stays “KIT ×× 工具” (“KIT ×× tool”); do not rename it
  when testing with other data (for example TDCYP).
- The version line is always in the header and reads Version and Date
  from the app’s own DESCRIPTION
  ([`kit_app_description()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_description.md));
  with `show_kitdesign = TRUE` the kitDesign version follows, so both
  versions are visible when reporting problems.
- Versioning rules and release steps:
  [release.md](https://jiewentsai.github.io/kitDesign/articles/release.md);
  old names in kitJoin and kitsUI:
  [migration.md](https://github.com/jiewenTsai/kitDesign/blob/main/brand/en/migration.md).
- For new components or style changes, change kitDesign
  (`inst/www/kit-design.css` and `R/`); do not write separate CSS in the
  app. Use only this system’s tokens (colors, `sp-*`, type sizes), and
  check for an existing component before writing a new one.

### Switching to another brand

kitDesign defaults to KIT (lime header, KIT green, bean logo). Projects
other than KIT can use it too: change the **logo** and **colors**, and
follow this design language for everything else (fonts, frames, shadows,
spacing, components, wording rules). From kitDesign 0.3.0:

``` r

options(kitDesign.brand = kit_brand(
  "示範實驗室",          # "Demo lab"
  logo = "logo.svg",     # full logo for the header (SVG or PNG)
  mark = "mark.svg",     # browser tab icon (square; falls back to logo if missing)
  colors = list(accent = "#9cc0ff", primary = "#1f4fa3", page = "#f5f7fa")
))
```

- Set it once and
  [`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md),
  [`kit_header()`](https://jiewentsai.github.io/kitDesign/reference/kit_header.md),
  [`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md),
  [`kit_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_colors.md),
  [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md),
  and
  [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
  all use it; for a single page use `kit_page(..., brand = )`.
- The colors you can change are the ones with a `--nb-*` variable in the
  appendix below (see the note below the appendix “Color” table for the
  mapping); anything not given stays KIT. If only `accent` is given,
  `accent_light` is computed automatically (mixed with white); if only
  `primary` is given, `primary_hover` is computed automatically
  (darkened).
- When changing colors, keep this document’s rules: text on color blocks
  is always `ink`, so `ink` on `accent` and on the four status colors
  needs 4.5:1; `primary` is link text and also needs 4.5:1 on `page`.
  Better not to change the four status colors; if you do, their meanings
  must not change.
- Grays (`text-hint`, `line`, and so on), the focus outline, and the
  chart categorical colors (Okabe–Ito) do not change with the brand.
- To see the result: `kit_gallery(brand = "demo")` (a blue demo brand).

## Author’s decisions (2026-10-31)

1.  **Tool name**: stays “KIT”. TDCYP is only test data.
2.  **Status labels**: unified as
    【完成】【完成，但請注意】【停下來】【要重新執行】 (“Done”, “Done,
    but note”, “Stopped”, “Run again”).
3.  **Table column names**: function output and the data itself keep
    English column names; summary tables the package builds itself may
    use Chinese; downloaded files keep the original column names.
4.  **kitJoin tabs**: three groups, unnumbered (準備 ·
    做出資料（選一個）· 其他工具; Prepare · Make the data (pick one) ·
    Other tools).
5.  **Table width**: follows content, not stretched to the full page.
6.  **Text on charts**: follows kits’ original (English), not
    translated; labels typed by the user stay as typed (may be Chinese).
    The app only applies colors and
    [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md).
7.  **Danger button**: salmon (`nb-salmon`), black text.
8.  **Heatmap color scale**: the minimum is a very pale lime, not white,
    so 0% and no-data cells are distinguishable.
9.  **kits response file**: step 2 only picks the item columns; domain
    and scoring are set in the item table in step 3; the default domain
    is the item group name with a trailing `_`, `.`, or `-` removed.

## Where the code still differs

The sections above follow the code; check here when changing the code or
the spec.

- **Recommended option**: v0.2 proposed a mint-background button; the
  code never did it. Now it is only “goes first, text says
  (recommended)”.
- **Secondary button**: section 9 of v0.2 proposed a 2px frame plus a
  2px shadow; the code’s `kit_button(kind = "secondary")` is the small
  button (1.5px, no shadow, 0.85rem, weight 500). The white button with
  a shadow is only the default look of
  [`actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html).
- **Type sizes**: the spec has six sizes; `inst/www/kit-brite.css` still
  has values such as 0.85, 0.88, 0.9, 0.92, and 1.08rem, and the first
  line of the status box is 1.08rem.
- **Weight 500**: the spec says only 400 and 700, but secondary buttons
  and “no problem” checklist items use 500.
- **Old grays**: `#4d4d4d`, `#6b6b6b`, `#9a9a9a`, `#c9c3b6` remain in
  some rules in `inst/www/kit-brite.css` (mostly overridden by later
  rules); the background of not-yet-available tabs is `#ece8dc`, not
  `bg-disabled`.

## Appendix: tokens

In code, the CSS variable is `--` plus the name, for example
`var(--nb-lime)`, `var(--sp-3)`.

### Color

| Name | Value | Used for |
|----|----|----|
| `nb-ink` | `#141414` | Ink: all text, 2px frame lines, hard shadows, the header background of the main data table. Text on color blocks always uses it. |
| `nb-page` | `#faf7f0` | Paper: the whole page background (off-white). nb-ink on it is 17.2:1. |
| `nb-card` | `#ffffff` | Card: background of cards, inputs, tables, charts, and buttons (except the primary button). |
| `nb-lime` | `#c6d033` | KIT lime, the lead color: header, primary button, current tab and step number, dropdown selection. Not a text color (only 1.57:1 on paper); put nb-ink on it (10.9:1). |
| `nb-green` | `#006835` | KIT green (the same as the logo’s dark green): link text, progress bars, ✓ marks, selected checkboxes. 6.5:1 on paper, 6.9:1 on white. Not for large backgrounds or the primary button. |
| `nb-green-hover` | `#004d27` | Link color on hover. |
| `nb-sky` | `#a8dcff` | Information: background of the sky-blue callout (kit_callout()), with nb-ink on it. |
| `nb-yellow` | `#ffde59` | Needs attention: 【完成，但請注意】 and 【要重新執行】 status boxes, attention callouts, the cloud-version banner. nb-ink on it. |
| `nb-salmon` | `#ff9b8f` | Stopped: the 【停下來】 status box, danger buttons (delete, skip this round). nb-ink on it. |
| `nb-mint` | `#b9f0a8` | Done: the 【完成】 status box, finished step numbers, the stripes of the upload progress bar. nb-ink on it. |
| `text-hint` | `#5a5a5a` | Supporting text: small hints, explanations, collapsible titles, group labels, secondary information in tables. 6.45:1 on paper, 6.9:1 on white. |
| `text-disabled` | `#6e6a60` | Disabled text: not-yet-available step cards and tabs, disabled rows. 5.0:1 on paper. |
| `text-todo` | `#8a4a00` | The “還差：…” (“Still needed: …”) line above the primary button, reminder text in per-item tables (bold). 6.4:1 on paper. |
| `text-decide` | `#a14a00` | The ! mark for “needs a decision” in checklists. About 6.0:1 on white. |
| `text-stop` | `#8a2a00` | Single problems in tables or lists (.kit-problems). 8.1:1 on paper. |
| `line` | `#d9d4c5` | Faint line: the bottom edge of “What this page does”, the left rule of advanced settings, dividers in the phone file table. Lines only, never text. |
| `line-soft` | `#e3ded2` | Faintest line: between checklist rows, top edge of the composite item ID block. |
| `border-disabled` | `#8a8a8a` | Disabled frames: not-yet-available or finished step cards, disabled buttons, not-yet-available tabs. 3.2:1 on paper (the threshold for frames and graphics is 3:1). |
| `bg-disabled` | `#e8e4d8` | Background of disabled buttons (do not use opacity); not-yet-available tabs use the similar \#ece8dc. |
| `bg-stripe` | `#f3f0e6` | Zebra stripes in data tables; pale header row inside step cards. |
| `bg-soft-hover` | `#f1eee4` | Background of secondary buttons on hover. |
| `bg-code` | `#fffdf5` | Background of code frames (with a 2px nb-ink frame, no shadow). |
| `bg-guess` | `#fffbe6` | Cells guessed from column names (pale yellow), reminding users to check them. |
| `bg-new` | `#e8f0a0` | Newly added columns in diagrams (pale lime); not sky blue, which means “information”. |
| `focus` | `#0044ff` | Keyboard focus: 3px outline, offset 3px outward. Visible against black frames; 6.0:1 on paper. |
| `logo-bean` | `#aad05f` | Logo and illustrations only. Not for buttons or backgrounds (only 1.05:1 against lime). |
| `logo-leaf` | `#fff57f` | Logo and illustrations only. Not for any interface component (too close to the “needs attention” yellow). |
| `chart-blue` | `#0072b2` | Chart categorical color 1 (Okabe–Ito): cohorts, scales, and scores take colors in order. |
| `chart-orange` | `#e69f00` | Chart categorical color 2. |
| `chart-green` | `#009e73` | Chart categorical color 3. |
| `chart-purple` | `#cc79a7` | Chart categorical color 4. |
| `chart-sky` | `#56b4e9` | Chart categorical color 5. |
| `chart-vermillion` | `#d55e00` | Chart categorical color 6; beyond 6 categories, start over from the first. |
| `chart-neutral` | `#7f7f7f` | Neutral color for non-categorical elements in charts: reference lines, bands, unjudged points. |
| `chart-sequential` | `#f3f7d3` → `#e8f0a0` → `#006835` | Color scale for continuous values (heatmaps, color bars): very pale lime (not white: white is reserved for no-data cells) → pale lime (`bg-new`, at 0.2) → KIT green (`nb-green`), interpolated in Lab space. [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md). |

**Colors a brand can change** (`kit_brand(colors = )` name → token → CSS
variable): `ink` → `nb-ink` (`--nb-ink`), `page` → `nb-page`
(`--nb-page`), `card` → `nb-card` (`--nb-card`), `accent` → `nb-lime`
(`--nb-lime`), `accent_light` → `bg-new` (`--nb-bg-new`), `primary` →
`nb-green` (`--nb-green`), `primary_hover` → `nb-green-hover`
(`--nb-green-hover`), `success` → `nb-mint`, `warning` → `nb-yellow`,
`danger` → `nb-salmon`, `info` → `nb-sky` (all `--` plus the name). The
values in the table are KIT’s; another brand replaces these, and
`chart-sequential` is computed from `accent_light` and `primary`. Other
tokens do not change with the brand.

### Type sizes (base 17px)

| Name | Size | Line height | Weight | Used for |
|----|----|----|----|----|
| `display` | 1.75rem | 1.25 | 700 | Header h1 (tool name), one per app. Shrinks to 1.35rem on phones (≤ 576px). |
| `h4` | 1.35rem | 1.3 | 700 | Section titles; 2.4rem above. Keep titles short; lists go in small text below. |
| `h5` | 1.1rem | 1.35 | 700 | Subtitles, step card titles, the primary button, the first line of the status box (implemented as 1.08rem for the status box). |
| `body` | 1rem | 1.65 | 400 | Body text, status box bullet points. The html base size is 17px, so 1rem = 17px. |
| `small` | 0.95rem | 1.4 | 400 | Data tables (0.95rem), step summaries and checklist explanations (0.92rem). |
| `hint` | 0.82rem | 1.5 | 400 | Small hints, collapsible titles, group labels, the version line, diagrams. The smallest size, about 14px; anything smaller is for chart tick labels only. |
| `code` | 0.85rem | 1.5 | 400 | “How to do it in R”, raw error messages, values in diagrams. Ligatures always off; \<- and \|\> display as typed. |

Fonts: `sans` = “Chiron GoRound TC”, sans-serif; `mono` = “JetBrains
Mono”, “Chiron GoRound TC”, Menlo, Consolas, monospace.

### Spacing

| Name | Value | Used for |
|----|----|----|
| `sp-1` | `0.25rem` | Between an icon and its text. Spacing uses a 0.25rem unit. |
| `sp-2` | `0.5rem` | Between components in one group, such as a row of buttons or between tabs (0.5–0.6rem). |
| `sp-3` | `1rem` | Between components in one section, card padding, above the header. |
| `sp-4` | `1.6rem` | Between tab groups, from “What this page does” to the first setting, above the details row. |
| `sp-5` | `2.4rem` | Between sections (above h4), from the main content to “Next step”. |
| `gutter` | `2rem` | Left and right page margins; 1rem at ≤ 768px. |
| `content-max` | `1140px` | Content is at most 1140px wide, centered; wide screens get side margins instead of stretching to the window. |

### Corners

| Name | Value | Used for |
|----|----|----|
| `radius` | `8px` | All frames: cards, buttons, inputs, tabs, tables, charts, the header. |
| `radius-bar` | `3px` | The upload progress bar only. |
| `radius-round` | `50%` | The round step number in step cards (2rem square). |

### Shadows

| Name | Value | Used for |
|----|----|----|
| `shadow-header` | `4px 4px 0 0 #141414` | The header only. |
| `shadow-card` | `3px 3px 0 0 #141414` | Results: status box, charts, the current step card, the primary button. |
| `shadow-sm` | `2px 2px 0 0 #141414` | Clickable things: tabs, regular buttons (actionButton default), dropdowns, focused inputs. |
| `shadow-hover` | `1px 1px 0 0 #141414` | Buttons and tabs on hover: move 1px down and to the right (2px for the primary button), leaving a 1px shadow; on press, move all the way with no shadow. |

### Frame widths

| Name | Value | Used for |
|----|----|----|
| `bw-frame` | `2px` | Frames of all top-level components: cards, buttons, inputs, tabs, table outer frames, code frames. |
| `bw-line` | `1.5px` | Table row dividers, secondary button frames, the bottom edge of the explanation area. |
| `bw-hair` | `1px` | Grid lines of diagram tables, the upload progress bar frame, between checklist rows. |

### Breakpoints

| Name | Value | Used for |
|----|----|----|
| `bp-phone` | `576px` | ≤ 576px: smaller header, file table rows become blocks, diagrams stack vertically, main actions take priority. |
| `bp-tablet` | `768px` | ≤ 768px: 1rem side margins, tabs in one row that scrolls sideways, step card content not indented, settings and results stack vertically. |
