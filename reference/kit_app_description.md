# Read the app's version and date (Version and Date in DESCRIPTION)

The cloud version, the local run.bat, and the package's `run_xxx()` all
take Version and Date from DESCRIPTION, so all three show the same thing
(file modification times are not used: unzipping, installing, and
deploying all change the mtime).

## Usage

``` r
kit_app_description(package = NULL, path = NULL)
```

## Arguments

- package:

  The app's package name, e.g. `"kitJoin"`; when `NULL`, only
  DESCRIPTION files are searched.

- path:

  Path to a DESCRIPTION file; when `NULL`, searched in the order below.

## Value

`list(version = , date = )`; anything not found is `NA`.

## Details

Search order:

1.  `path` is given: read that DESCRIPTION file.

2.  `package` is already loaded
    ([`library()`](https://rdrr.io/r/base/library.html), `run_xxx()`,
    `load_all()`): read the loaded copy.

3.  `DESCRIPTION` in the working directory, then one and two levels up
    (in tests the working directory is `tests/testthat`); when `package`
    is given, only a file whose `Package:` matches counts. The cloud
    version and run.bat use `runApp(folder)`, the package is not loaded,
    and this is the copy that gets read.

4.  `package` is installed (but not loaded): read the installed copy.
    This comes last because it may be an old version.

## Examples

``` r
kit_app_description("kitDesign")
#> $version
#> [1] "0.4.0"
#> 
#> $date
#> [1] "2026-10-31"
#> 
```
