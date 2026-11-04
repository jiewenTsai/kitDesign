# kitDesign validation report

Standard: [KIT validation standard](criteria.md) (`kit_validation("kitDesign", "criteria")`), which
kitDesign keeps for every KIT package. Version validated: kitDesign 0.8.0. Date: 2026-11-04.

## Summary

kitDesign is the shared interface layer; almost nothing it does reaches a report as a number, so
the engine, metamorphic and mutation layers were not run on it. Its faults are interface faults:
15 recorded, 5 after 2026-11-01, mostly downloads and plots in the browser, found by using the apps.

## Acceptance criteria (written before generation)

None dated before the code. The design rules in `brand/KIT設計語言.md` (the author's decisions 1 to
9, 2026-10-31) were committed with the code and say the code wins where they differ.

## Scope

| Function | Output that reaches a report | Error types asked |
|---|---|---|
| `kit_num` | Numbers printed in app tables | Formula (rounding) |
| `kit_fix_utf8_df`, `kit_fix_utf8_chr` | Text columns of uploaded files | Data management |
| `kit_sav_safe_names` | Column names written to SAV files | Variable mapping |
| Everything else (pages, buttons, code panels, downloads) | Out of scope: covered by unit tests and browser checks | |

The three in-scope functions are tested in `tests/testthat/` (18 files); they have no engine and no
metamorphic layer yet.

## Faults and regression tests

| Version | Fault | Caught by | Regression test |
|---|---|---|---|
| 0.7.1 | The r-universe build timed out building the PDF manual | r-universe | not needed |
| 0.7.0 | Widgets inside an opened details row sometimes stayed thin | Not stated | unknown |
| 0.6.1 | Plotly inside a closed details row was drawn at 76 px and blocked other outputs | Manual use | no (browser only) |
| 0.5.2 | Firefox add-ons hijacked download links | Manual use | yes |
| 0.5.1 | Firefox download warning closed the session (4 attempts to fix) | Manual use | no (browser only) |

## Metrics

| Metric | Value |
|---|---|
| Acceptance criteria written beforehand | 0 (one spec, not dated before the code) |
| First-generation pass rate | 6 of 11 versions (55%) |
| Faults caught per layer | Manual use 3, r-universe 1, not stated 1 (after release) |
| Faults found after release | 5 (strict: after 2026-11-01), 6 (broad) |

## What kitDesign gives other packages

- `criteria.md`: the standard.
- `use_kit_validation()`: starts `inst/validation/validation.md` in a new package.
- `kit_validation()`, `kit_validation_url()`: open a package's report.
- `kit_page(validation = TRUE)`: the link "驗證報告" on an app's version line.
