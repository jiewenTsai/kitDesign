# {{package}} validation report

Standard: [KIT validation standard](https://github.com/jiewenTsai/kitDesign/blob/main/inst/validation/criteria.md)
(`kitDesign::kit_validation("kitDesign", "criteria")`). Version validated: {{package}} {{version}}.
Date: {{date}}.

## Summary

One paragraph: what was validated, the four metrics, and what failed.

## Acceptance criteria (written before generation)

1. ...
2. ...
3. ...

## Scope

| Function | Output that reaches a report | Error types asked |
|---|---|---|

## Engine equivalence

| Function | Reference engine | Quantity | Max abs. difference | Pass |
|---|---|---|---|---|

## Metamorphic relations

| Function | Relation | Error type | Pass |
|---|---|---|---|

## Report snapshot

Scenario, files compared, result of two runs.

## Mutation testing

| Error type | Mutants | Killed | Surviving (and the missing test) |
|---|---|---|---|

## Faults and regression tests

| Version | Fault | Error type | Caught by | After release | Regression test |
|---|---|---|---|---|---|

## Metrics

| Metric | Value |
|---|---|
| Acceptance criteria written beforehand | |
| First-generation pass rate | |
| Faults caught per layer | |
| Faults found after release | |

## Reproduce

```r
source(system.file("validation", "engine.R", package = "{{package}}"))
source(system.file("validation", "metamorphic.R", package = "{{package}}"))
```
