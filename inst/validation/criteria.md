# KIT validation standard

Version 1 (2026-11-04). This is the standard every KIT package follows when it is planned,
generated (with or without an AI assistant) and released. Each package keeps its report in
`inst/validation/validation.md`; `kitDesign::kit_validation("<package>")` opens it, and the apps
link to it from the version line of the header.

Testing cannot be exhaustive. The goal is not to test everything but to fix, **before**
generation, a bounded list of checks, and to let that list grow only with evidence.

## Why a bounded list

Four results from software testing support this; none of them was developed for end-user
development (EUD) or AI-assisted EUD, so the standard is an application, not a proven method.

1. **Test adequacy.** An adequacy criterion says when testing is enough
   ([Zhu et al., 1997, ACM Computing Surveys](https://consensus.app/papers/details/4edccf2e56925183867a46c49ff9530d/)).
   Full coverage does not mean no faults
   ([Hutchins et al., 1994](https://consensus.app/papers/details/b6012d55daea5bba9efc7607c902befb/);
   [Antinyan et al., 2019](https://consensus.app/papers/details/ff91d4a31f345e3dbcd304a135196cc3/)),
   so coverage is not the criterion here.
2. **The oracle problem.** Whether an output is right is judged against a specification, a
   metamorphic relation or a human
   ([Barr et al., 2015, IEEE TSE](https://consensus.app/papers/details/9716980f602d5a37bf848d09189acd4f/)).
   In psychometrics, an established estimation engine (TAM, mirt, dexter, psychotools) is a
   ready-made oracle.
3. **Risk-based testing.** What to test, and when to stop, follow from risk
   ([Craig & Jaskiel, 2002](https://consensus.app/papers/details/df3b281dfb985f6985827309afb13176/)).
   The risk here is a wrong number in a report.
4. **Mutation testing.** Deliberately planted faults measure how good the tests are
   ([Papadakis et al., 2019](https://consensus.app/papers/details/95a98c14a6805f609af4a8181d82587b/));
   mutants are coupled to real faults
   ([Petrović et al., 2021](https://consensus.app/papers/details/cb90a0681f0959c5b0c8de38e6c5f3c8/)).

## The six rules

1. **Scope by output.** Validate only the functions whose numbers reach a report: the files an app
   writes (fixed set, score tables, logs), the tables a user copies into a paper, and the code an
   app hands out. Interface code is covered by ordinary tests, not by this standard.
2. **List by error type.** For every in-scope function ask once for each of four error types, plus
   boundaries:

   | Error type | Question |
   |---|---|
   | Formula composition | Is every term, sign, denominator and index right? |
   | Interval estimation | Are SEs, CIs and their propagation (e.g. linking error) right? |
   | Data management | Are rows kept, dropped, merged, reshaped and recoded as stated? |
   | Variable mapping | Does each column, ID and item end up where the next step expects it? |
   | Boundary | Missing values, empty score categories, one item, one person, one wave |

3. **A fixed quantity per layer.**

   | Layer | Quantity |
   |---|---|
   | Engine equivalence | One comparison per function, on fixed data, against TAM, mirt, dexter or psychotools (or a hand formula when no engine exists) |
   | Metamorphic relations | Three relations per function |
   | Report snapshot | The whole report of one fixed demo scenario, run twice and compared byte for byte |
   | Unit tests | As the package needs; not counted toward adequacy |

4. **Write only acceptance criteria before generation.** Three to five sentences of "this is right
   when ...", written before the code is generated, in the package's `validation.md`. They are not
   the full test list.
5. **Add a test only when a fault is found.** Every fault becomes one regression test, committed with
   its fix and listed in the report. The list grows with the evidence.
6. **Measure the tests with mutants.** Plant small faults (sign, denominator, index, comparison,
   dropped term, `na.rm`) in a copy of the package and count how many the existing tests catch.
   Every surviving mutant is either an equivalent mutant (say why) or a missing test (add it).

## The four metrics

Every package reports, for each release cycle:

| Metric | Meaning |
|---|---|
| Acceptance criteria written beforehand | Count of criteria in `validation.md` dated before the code |
| First-generation pass rate | Share of generated changes that passed their acceptance criteria and tests without a follow-up fix |
| Faults caught per layer | Count by layer (engine, metamorphic, snapshot, unit test, mutation, check, manual use) |
| Faults found after release | Count, with each fault listed; the most important metric, because it shows what the list missed |

## Files in each package

```
inst/validation/
  validation.md         the report (template: kitDesign/inst/templates/validation.md)
  engine.R              engine equivalence, reproducible (simulated or demo data only)
  metamorphic.R         metamorphic relations, reproducible
  results/              CSV results written by the scripts
```

`kitDesign::use_kit_validation()` copies the template into a new package. Data rules: only
simulated data and the demo data (`kits::kitm03`, `kits::kitm36`); restricted (IRB) data never
enters a package, a report or a test fixture.

## When to run

- Before a release that changes an in-scope function: engine, metamorphic and snapshot layers.
- Once per minor version, or after a large change: mutation testing.
- After every fault found in use: one regression test, and the post-release count in the report.
