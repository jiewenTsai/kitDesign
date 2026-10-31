# Versions and releases

English | [繁體中文](../版本與發布.md)

kitDesign is the shared interface for kitJoin, kitsUI, and future KIT apps. Each of the three packages
has its own version. They stay in step because each app states which version of kitDesign it uses.

## Version numbers: semantic versioning (X.Y.Z)

| What changed | Which number goes up | Example |
|---|---|---|
| A fix; neither the screen nor any function changed | **patch** (0.1.0 → 0.1.1) | Fix a JavaScript bug, fix the docs, fix a test |
| A new component or option; existing apps need no changes | **minor** (0.1.1 → 0.2.0) | Add `kit_xxx()`; add an argument with a default value to an existing function |
| A function renamed or removed, an argument's meaning changed, **a visible design change** | **major** (0.2.0 → 1.0.0) | Change the status box color, change the button size, remove `kit_status_ui()` |

- Before 1.0.0 (0.x), the same rules apply. We suggest releasing 1.0.0 as the first version that both apps use.
- Any visible change counts as major: what users see on screen is part of the design language, so a change must be announced to both apps.
- [`design-language.md`](design-language.md) has its own version, separate from kitDesign. When the design language gets a new version, write the matching kitDesign version in NEWS.md.

## Every release

1. Update `Version` and `Date` in `DESCRIPTION`.
2. Add a section at the top of `NEWS.md`: `# kitDesign X.Y.Z (YYYY-MM-DD)`, with the subsections "元件" (components), "修正" (fixes), and "看得到的改變" (visible changes).
3. Checks (all must pass):
   ```sh
   LC_ALL=en_US.UTF-8 Rscript tools/escape_non_ascii.R
   LC_ALL=en_US.UTF-8 Rscript -e 'roxygen2::roxygenise()'
   LC_ALL=en_US.UTF-8 R CMD build .
   LC_ALL=en_US.UTF-8 R CMD check --no-manual kitDesign_X.Y.Z.tar.gz   # 0 errors, 0 warnings
   LC_ALL=en_US.UTF-8 Rscript tools/check_gallery.R                     # screenshots; no horizontal scrolling
   ```
4. Look at the screenshots from `tools/check_gallery.R` (1280 and 390 wide) and compare them with the previous version.
5. Commit and tag: `git tag vX.Y.Z`, then push to GitHub (`git push origin main --tags`).

## Upgrading kitDesign in an app

1. In the app's `DESCRIPTION`:
   - `Imports: kitDesign (>= X.Y.Z)`
   - `Remotes: jiewenTsai/kitDesign@vX.Y.Z` (pinned to the tag, not following main)
2. Install that version: `remotes::install_github("jiewenTsai/kitDesign@vX.Y.Z")`.
3. Run the app's tests. For a major upgrade, update the code following "看得到的改變" (visible changes) in NEWS.md and [`migration.md`](migration.md), and compare screenshots.
4. Regenerate `manifest.json` (`rsconnect::writeManifest()`) and deploy.
5. Bump the app's own version too (usually patch; minor if the screen changed), and write "改用 kitDesign X.Y.Z" ("Now uses kitDesign X.Y.Z") in NEWS.md.

## When reporting a problem

The version line in the header shows both versions (`kit_page(..., show_kitdesign = TRUE)`):
"v0.5.0 · 2026-10-31 · kitDesign 0.1.0". In R, use `kit_versions("kitJoin")`.

## Pre-release checklist

- [ ] Version and Date updated in `DESCRIPTION`
- [ ] `NEWS.md` has this version
- [ ] R code is ASCII only (`tools/escape_non_ascii.R`)
- [ ] `R CMD check`: 0 errors, 0 warnings
- [ ] `tools/check_gallery.R`: no horizontal scrolling at 1280 or 390 wide; screenshots reviewed
- [ ] Visible changes: the version is major, and [`migration.md`](migration.md) or NEWS.md explains how to update
- [ ] Tag `vX.Y.Z`
- [ ] Tell kitJoin and kitsUI whether to upgrade and what to change
