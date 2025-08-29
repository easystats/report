# rempsyc: Convenience Functions for Psychology R Package

Always follow these instructions EXACTLY and only search for additional context if the information here is incomplete or found to be in error.

## Overview
The `rempsyc` package is an R package providing convenience functions for psychology research, including statistical analysis, publication-ready tables (APA style), and data visualization. The package is built using R 4.3.3+ and follows standard R package development practices.

**CRITICAL REMINDER**: Every PR must include version number updates in DESCRIPTION and changelog entries in NEWS.md. See the [Version Management section](#version-management-and-changelog-updates) for detailed instructions.

**VERSION MANAGEMENT FREQUENCY**: Version numbers and NEWS.md should be updated **ONCE PER PULL REQUEST**, not once per commit. Multiple commits within the same PR should use the same version number.

## Pre-Configured Environment 

**NEW**: This repository now includes `.github/workflows/copilot-setup-steps.yml` which automatically configures the development environment before GitHub Copilot starts working. This workflow intelligently determines what setup is needed:

**For R package development tasks** (editing .R files, functions, tests, etc.), it pre-installs:
- R and system dependencies
- Core development packages (rlang, dplyr, testthat, lintr, styler, roxygen2, reprex)
- Most commonly used suggested packages (ggplot2, flextable, effectsize, correlation, boot, ggsignif, etc.)
- The rempsyc package itself (built and installed)
- Verified functionality of core functions and reprex

**For documentation/configuration tasks** (editing .md files, .yml files, copilot instructions, etc.), it runs minimal setup:
- Repository checkout only
- Skips time-consuming R installation and package setup
- Saves significant time for non-code changes

**If the pre-configured environment is working**, you can skip most manual installation steps below and go directly to the [Build and Development Workflow](#build-and-development-workflow) section.

**Verification**: Check if the environment is pre-configured by running:
```bash
R --no-restore --no-save -e 'library(rempsyc); packageVersion("rempsyc")'
```

If this works without errors, the environment is ready. If not, follow the manual setup below.

## Environment Setup (Manual - if pre-configuration failed)

### Package Installation Philosophy
**CRITICAL**: Install packages minimally and on-demand to avoid long installation times. Only install packages that are actually required by the specific function you are modifying in your current PR.

### Install R and Required System Dependencies
**CRITICAL**: Always ensure R is properly installed and functional before proceeding with any package development tasks.

```bash
# Ubuntu/Debian systems - ALWAYS run this first in every session
sudo apt update
sudo apt install -y r-base r-base-dev

# Verify R installation is working
R --version
which R

# Install core R packages via system package manager (recommended)
sudo apt install -y r-cran-dplyr r-cran-rlang r-cran-testthat r-cran-lintr

# Install reprex (ESSENTIAL for creating reproducible examples in PRs)
sudo apt install -y r-cran-reprex || R --no-restore --no-save -e 'install.packages("reprex", repos="https://cloud.r-project.org/")'

# Install other essential development packages via system packages when possible
sudo apt install -y r-cran-devtools r-cran-roxygen2 r-cran-styler || echo "Some packages not available via apt, will install via R"

# If styler, roxygen2, or devtools are not available via system packages, install via R:
R --no-restore --no-save -e '
packages_needed <- c("styler", "roxygen2", "devtools")
packages_installed <- rownames(installed.packages())
packages_to_install <- setdiff(packages_needed, packages_installed)
if (length(packages_to_install) > 0) {
  install.packages(packages_to_install, repos="https://cloud.r-project.org/")
}
'
```

### Verify R Installation and Core Packages
**NEVER SKIP**: Always run this verification after installing R:

```bash
# Test R basic functionality
R --no-restore --no-save -e 'print("R is working correctly")'

# Verify core packages are available
R --no-restore --no-save -e '
required_packages <- c("dplyr", "rlang", "testthat", "lintr", "reprex", "styler", "roxygen2")
missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]
if (length(missing_packages) > 0) {
  cat("Missing packages:", paste(missing_packages, collapse = ", "), "\n")
  cat("Run installation commands to install missing packages\n")
} else {
  cat("All core development packages are available\n")
}
'
```

### Essential reprex Package Setup
**CRITICAL**: The reprex package is mandatory for creating reproducible examples in pull requests. Always ensure it's installed and functional.

```bash
# Install reprex if not already installed
R --no-restore --no-save -e '
if (!requireNamespace("reprex", quietly = TRUE)) {
  # Try multiple installation methods
  tryCatch({
    install.packages("reprex", repos="https://cloud.r-project.org/")
  }, error = function(e1) {
    tryCatch({
      install.packages("reprex", repos="https://r-universe.dev")
    }, error = function(e2) {
      install.packages("pak", repos="https://r-lib.github.io/p/pak/stable/")
      pak::pak("reprex")
    })
  })
}
'

# Verify reprex functionality with a simple test
R --no-restore --no-save -e '
library(reprex)
# Test reprex with simple code
test_code <- "
x <- 1:5
mean(x)
"
result <- reprex(input = test_code, venue = "gh", advertise = FALSE, show = FALSE)
if (length(result) > 0) {
  cat("reprex package is working correctly\n")
} else {
  stop("reprex package installation failed - this is required for PR creation")
}
'
```

### Install Function-Specific Dependencies Only
**CRITICAL**: Only install packages that are actually used by the specific function you are modifying. DO NOT install all suggested packages upfront as this causes long installation times.

#### Determine Required Packages for Your Function
```bash
# Step 1: Find which packages your specific function actually requires
# Check the function's rlang::check_installed() calls in the source code
cd /home/runner/work/rempsyc/rempsyc
grep -A2 -B2 "rlang::check_installed" R/[your_function_file].R

# Or search for all function dependencies:
# grep -r "check_installed\|requireNamespace" R/[your_function_file].R
```

#### Install Only Required Packages
```bash
# Step 2: Install ONLY the packages found in Step 1
# Example: If working on nice_scatter(), you only need ggplot2
R --no-restore --no-save -e 'install.packages("ggplot2", repos="https://cloud.r-project.org/")'

# Example: If working on nice_table(), you only need flextable  
R --no-restore --no-save -e 'install.packages("flextable", repos="https://cloud.r-project.org/")'

# Example: If working on nice_violin(), you need multiple packages
R --no-restore --no-save -e 'install.packages(c("ggplot2", "boot", "ggsignif"), repos="https://cloud.r-project.org/")'
```

#### Use rempsyc's Built-in Utility (After Building Package)
```bash
# Alternative: Use rempsyc's install_if_not_installed() for specific packages
R --no-restore --no-save -e '
# First build and install the current rempsyc package to access utility functions
if (file.exists("DESCRIPTION")) {
  system("R CMD build .")
  pkg_file <- list.files(pattern = "rempsyc_.*\\.tar\\.gz")[1]
  if (!is.na(pkg_file)) system(paste("R CMD INSTALL", pkg_file))
}

# Load rempsyc and install only specific packages for your function
library(rempsyc)
# ONLY install packages needed for your specific function:
if (exists("install_if_not_installed")) {
  install_if_not_installed(c("ggplot2"))  # Example: only ggplot2 for nice_scatter
} else {
  install.packages("ggplot2", repos="https://cloud.r-project.org/")  # Fallback
}
'
```

### Set Up R User Library
```bash
# Create user library directory
mkdir -p ~/R/library
echo 'R_LIBS_USER=~/R/library' >> ~/.Renviron
```

## Build and Development Workflow

### Targeted Package Installation Workflow
**ESSENTIAL**: Follow this targeted approach to avoid "The package installation is taking a long time" issues:

1. **Identify your function**: Determine which specific function you're modifying
2. **Find dependencies**: Check what packages that function actually requires:
   ```bash
   cd /home/runner/work/rempsyc/rempsyc
   grep -A2 -B2 "rlang::check_installed\|requireNamespace" R/[your_function].R
   ```
3. **Install only required packages**: Install ONLY the packages found in step 2
4. **Test function**: Test that your specific function works with the installed packages
5. **Proceed with development**: Build, test, and develop normally

### Build the Package
**NEVER CANCEL: Build takes ~19 seconds. Set timeout to 60+ seconds.**
```bash
cd /home/runner/work/rempsyc/rempsyc
R CMD build .
# Creates: rempsyc_0.1.91.tar.gz (version may vary)
```

### Install the Package
**NEVER CANCEL: Install takes ~3 seconds. Set timeout to 60+ seconds.**
```bash
cd /home/runner/work/rempsyc/rempsyc
R CMD INSTALL rempsyc_0.1.91.tar.gz
# Or install from source:
# R CMD INSTALL .
```

### Run Tests
**NEVER CANCEL: Tests take ~11 seconds. Set timeout to 30+ seconds.**
```bash
cd /home/runner/work/rempsyc/rempsyc
R --no-restore --no-save -e 'library(testthat); library(rempsyc); test_local()'
```

Expected results: 
- ~99 tests processed across multiple test files
- ~94 tests should pass
- 3-5 snapshot failures due to minor precision differences (normal and expected)
- Some tests may be skipped if optional packages not available

### Run Linting
**NEVER CANCEL: Linting takes ~20 seconds. Set timeout to 60+ seconds.**
```bash
cd /home/runner/work/rempsyc/rempsyc
R --no-restore --no-save -e 'library(lintr); lint_package()'
```

Expected results:
- Many style warnings (673+ issues found - normal for existing codebase)
- Focus on new code adhering to style guidelines
- Package is functional despite style warnings

### Auto-format Code with Styler
**NEVER CANCEL: Styling takes ~10-30 seconds depending on package size. Set timeout to 60+ seconds.**
```bash
cd /home/runner/work/rempsyc/rempsyc
# Style entire package
R --no-restore --no-save -e 'library(styler); style_pkg()'

# Style specific file
R --no-restore --no-save -e 'library(styler); style_file("R/[function_name].R")'

# Style specific directory
R --no-restore --no-save -e 'library(styler); style_dir("R")'
```

Expected results:
- Automatic code formatting according to tidyverse style guide
- Consistent indentation, spacing, and bracket placement
- Files will be modified in-place if styling changes are needed
- Use after making changes but before committing

### Update Documentation with roxygen2
**NEVER CANCEL: Documentation update takes ~5-15 seconds. Set timeout to 60+ seconds.**
```bash
cd /home/runner/work/rempsyc/rempsyc
# Update documentation after making changes to roxygen2 comments
R --no-restore --no-save -e 'roxygen2::document()'

# Alternative using devtools
R --no-restore --no-save -e 'devtools::document()'
```

Expected results:
- Updates .Rd files in man/ directory from roxygen2 comments
- Updates NAMESPACE file with exports/imports
- Essential step after modifying function documentation or adding/removing exports
- Must be run before building the package if documentation was changed

**When to use**: Always run this after:
- Adding or modifying roxygen2 comments (the `#'` comments above functions)
- Adding new exported functions
- Changing function parameters or return values in documentation
- Adding or removing `@export`, `@import`, or `@importFrom` tags

### Run R CMD Check
**NEVER CANCEL: R CMD check takes ~30 seconds (without suggested packages) to 5 minutes (full). Set timeout to 10+ minutes.**
```bash
cd /home/runner/work/rempsyc/rempsyc
# Without suggested packages (due to network limitations):
_R_CHECK_FORCE_SUGGESTS_=FALSE R CMD check rempsyc_0.1.91.tar.gz --no-manual --no-vignettes

# With all checks (if network access available):
# R CMD check rempsyc_0.1.91.tar.gz
```

Expected results:
- Status: 1 ERROR (missing suggested packages - normal), 2 NOTEs  
- Core functionality passes all checks
- Tests pass correctly
- Examples may fail due to missing optional packages (expected)

## Validation Scenarios

### Always Test Core Functions After Changes
Test the main functions to ensure they work correctly:

```bash
cd /home/runner/work/rempsyc/rempsyc
R --no-restore --no-save -e '
library(rempsyc)

# Test t-test function
result <- nice_t_test(data = mtcars, response = "mpg", group = "am")
print(result)

# Test table formatting
library(testthat)  # If available
if (requireNamespace("flextable", quietly = TRUE)) {
  table <- nice_table(result)
  print("Table creation successful")
} else {
  print("Flextable not available - table creation skipped")
}

# Test basic data functions
data <- extract_duplicates(data.frame(id = c(1,1,2), val = c(1,2,3)), id = "id")
print("Core functions working correctly")
'
```

### MANDATORY: Test reprex Functionality Before Making Changes
**CRITICAL**: Always verify reprex is working before modifying any code that will require a PR:

```bash
cd /home/runner/work/rempsyc/rempsyc
R --no-restore --no-save -e '
# Load required packages
library(reprex)
library(rempsyc)

# Create a test reprex with actual rempsyc function
test_code <- "
library(rempsyc)
data(mtcars)

# Example function test
result <- nice_t_test(data = mtcars, response = \"mpg\", group = \"am\")
print(result)
"

# Generate reprex
cat("Testing reprex functionality...\n")
reprex_result <- reprex(input = test_code, venue = "gh", advertise = FALSE, show = FALSE)

# Verify it worked
if (length(reprex_result) > 0 && any(grepl("library\\(rempsyc\\)", reprex_result))) {
  cat("SUCCESS: reprex is working correctly and can generate examples with rempsyc\n")
  cat("Sample reprex output (first few lines):\n")
  cat(paste(head(reprex_result, 10), collapse = "\n"))
  cat("\n")
} else {
  stop("FAILED: reprex is not working correctly - install reprex before proceeding")
}
'
```

### Manual Function Testing Workflow
After making changes to package functions:

1. **Always rebuild and reinstall the package**:
   ```bash
   cd /home/runner/work/rempsyc/rempsyc
   R CMD build . && R CMD INSTALL rempsyc_*.tar.gz
   ```

2. **Test the specific function you modified**:
   ```bash
   R --no-restore --no-save -e 'library(rempsyc); [your_function_test_here]'
   ```

3. **Run relevant tests**:
   ```bash
   R --no-restore --no-save -e 'library(testthat); library(rempsyc); test_file("tests/testthat/test-[function_name].R")'
   ```

## Key Locations and Files

### Repository Exploration Commands
```bash
# View repository structure
ls -la /home/runner/work/rempsyc/rempsyc/

# View R source files
ls -la /home/runner/work/rempsyc/rempsyc/R/

# View test files
ls -la /home/runner/work/rempsyc/rempsyc/tests/testthat/

# Check package metadata
cat /home/runner/work/rempsyc/rempsyc/DESCRIPTION
```

### Source Code Structure
- `/R/` - All R function source files (34+ files)
- `/tests/testthat/` - Test files using testthat framework
- `/tests/testthat.R` - Test runner entry point  
- `/man/` - Documentation files (auto-generated from roxygen2)
- `/vignettes/` - R Markdown tutorials and documentation

### Configuration Files
- `DESCRIPTION` - Package metadata, dependencies, version
- `NAMESPACE` - Package exports (auto-generated from roxygen2)
- `.github/workflows/` - CI/CD workflows (R-CMD-check, lint, test-coverage)
- `.Rbuildignore` - Files to exclude from package build

### Important Functions by Category
**Statistical Analysis**: `nice_t_test()`, `nice_contrasts()`, `nice_mod()`, `nice_lm()`
**Tables**: `nice_table()` (publication-ready APA tables)
**Visualization**: `nice_violin()`, `nice_scatter()`, `plot_outliers()`
**Data Utilities**: `extract_duplicates()`, `nice_na()`, `scale_mad()`

## Dependencies and Package Management

### Core Dependencies (Always Required)
```r
# In DESCRIPTION file:
Imports: rlang, dplyr (>= 1.1.0)
Depends: R (>= 3.6)
```

### Suggested Packages (Optional)
Many functions require optional packages. The package uses `rlang::check_installed()` to prompt users to install needed packages when functions are called.

**Key suggested packages**: flextable, ggplot2, effectsize, performance, testthat, styler, roxygen2

**ESSENTIAL for development**: reprex (mandatory for creating PR examples)

### Installing Additional Packages (Only When Needed)
**PRIORITY**: Always install reprex first, then install other packages ONLY as needed for the specific function you are modifying:

```bash
# ALWAYS install reprex first (essential for PR creation):
sudo apt install -y r-cran-reprex || R --no-restore --no-save -e 'install.packages("reprex", repos="https://cloud.r-project.org/")'

# Via system packages (recommended for individual packages):
sudo apt install -y r-cran-[package-name]

# Via R (if CRAN network available, for individual packages):
R --no-restore --no-save -e 'install.packages("[package-name]", repos="https://cloud.r-project.org/")'

# Alternative sources when CRAN is blocked:
# Via R-universe (alternative CRAN mirror):
R --no-restore --no-save -e 'install.packages("[package-name]", repos="https://r-universe.dev")'

# Via pak package (faster, handles dependencies better):
R --no-restore --no-save -e 'install.packages("pak", repos="https://r-lib.github.io/p/pak/stable/"); pak::pak("[package-name]")'
```

#### Common Function-Specific Package Requirements
**DO NOT install all of these - only install what you need for your specific function:**

- **nice_table()**: flextable
- **nice_scatter()**: ggplot2  
- **nice_violin()**: ggplot2, boot, ggsignif
- **nice_qq()**: ggplot2, qqplotr, ggrepel
- **cormatrix_excel()**: correlation, openxlsx2
- **nice_lm_slopes()**: effectsize
- **overlap_circle()**: VennDiagram
- **plot_outliers()**: ggplot2

#### Check Function Dependencies Before Installing
```bash
# Find exactly which packages a function requires:
cd /home/runner/work/rempsyc/rempsyc
grep -A2 -B2 "rlang::check_installed\|requireNamespace" R/[function_file].R

# Examples:
# For nice_scatter.R: only requires ggplot2
# For nice_table.R: only requires flextable  
# For nice_violin.R: requires ggplot2, boot, ggsignif
```

#### Targeted Installation Examples
```bash
# Example 1: Working on nice_scatter() function
R --no-restore --no-save -e 'install.packages("ggplot2", repos="https://cloud.r-project.org/")'

# Example 2: Working on nice_table() function  
R --no-restore --no-save -e 'install.packages("flextable", repos="https://cloud.r-project.org/")'

# Example 3: Working on nice_violin() function (multiple dependencies)
R --no-restore --no-save -e 'install.packages(c("ggplot2", "boot", "ggsignif"), repos="https://cloud.r-project.org/")'

# Example 4: Working on cormatrix_excel() function
R --no-restore --no-save -e 'install.packages(c("correlation", "openxlsx2"), repos="https://cloud.r-project.org/")'
```

## Code Quality and Best Practices

### Avoiding Global Variable Binding Issues

**CRITICAL**: Always use proper variable referencing to prevent "no visible binding for global variable" warnings that make CI workflows fail.

#### Recommended Approaches:

1. **For dplyr operations**: Use `.data[[variable_name]]` notation
   ```r
   # CORRECT: Use .data[[var]] notation
   data %>%
     group_by(.data[[group_var]]) %>%
     summarize(mean_val = mean(.data[[response_var]], na.rm = TRUE))
   
   # INCORRECT: Direct variable names (causes binding warnings)
   data %>%
     group_by(group_var) %>%
     summarize(mean_val = mean(response_var, na.rm = TRUE))
   ```

2. **For ggplot2 operations**: Use `.data[[variable_name]]` or `aes_string()`
   ```r
   # CORRECT: Use .data[[var]] in aes()
   ggplot(data, aes(x = .data[[x_var]], y = .data[[y_var]]))
   
   # ALTERNATIVE: Use aes_string() for string variables
   ggplot(data, aes_string(x = x_var, y = y_var))
   ```

3. **Import required functions**: Always explicitly import from other packages
   ```r
   #' @importFrom dplyr group_by summarize
   #' @importFrom ggplot2 ggplot aes
   ```

#### Discouraged Approaches:

- **DO NOT** create `global_variables.R` files with `utils::globalVariables()`
- **DO NOT** use bare variable names in dplyr or ggplot operations
- **DO NOT** rely on global variable declarations to suppress warnings

### Ensuring Documentation-Code Consistency

**CRITICAL**: Documentation must exactly match function arguments to prevent "Codoc mismatches" warnings.

#### Documentation Validation Steps:

1. **Match all parameter names exactly**:
   ```r
   #' @param response The dependent variable name
   #' @param group The grouping variable name  
   function_name <- function(response, group) { ... }
   ```

2. **Update documentation when changing parameters**:
   - Always run `roxygen2::document()` after parameter changes
   - Check that `.Rd` files reflect actual function signatures
   - Verify examples use correct parameter names

3. **Validate before building**:
   ```bash
   # Check for documentation mismatches
   R --no-restore --no-save -e 'roxygen2::document()'
   R CMD build .
   # Look for "Codoc mismatches" warnings
   ```

## Common Development Tasks

### Adding a New Function
1. **FIRST: Update version number and NEWS.md** (see Version Management section - do this ONCE per PR)
2. Create the function in `/R/[function_name].R`
3. **Identify required packages**: Check which packages the function will need using `rlang::check_installed()`
4. **Install only required packages**: Use targeted installation instead of batch installation
5. **Use proper variable referencing**: Use `.data[[var]]` for dplyr/ggplot2 operations
6. Add roxygen2 documentation above the function (ensure parameter names match exactly)
7. Add `@importFrom` statements for all external functions used
8. Add exports to roxygen2 comments if needed (`@export`)
9. Create tests in `/tests/testthat/test-[function_name].R`
10. **Check for global variable issues**: `R CMD check` should show no binding warnings
11. **Lint the code**: `R --no-restore --no-save -e 'library(lintr); lint_package()'`
12. **Style the code**: `R --no-restore --no-save -e 'library(styler); style_file("R/[function_name].R")'`
13. **Update documentation**: `R --no-restore --no-save -e 'roxygen2::document()'`
14. **Validate documentation consistency**: Check for "Codoc mismatches" warnings
15. Rebuild and test: `R CMD build . && R CMD INSTALL rempsyc_*.tar.gz`
16. Run tests: `R --no-restore --no-save -e 'library(testthat); library(rempsyc); test_local()'`
17. **Create reprex examples**: Prepare reproducible examples showing the new function in action for PR description
18. **If making additional commits**: DO NOT update version/NEWS.md again - use same version for all commits in this PR

### Modifying Existing Functions
1. **FIRST: Update version number and NEWS.md** (see Version Management section - do this ONCE per PR)
2. **Identify current function dependencies**: Check which packages the function currently requires
3. Edit the function in appropriate `/R/[file].R`
4. **Check if new packages are needed**: If adding functionality, identify any new package requirements
5. **Install only new required packages**: Install only what's newly needed, not all suggested packages
6. **Ensure proper variable referencing**: Replace bare variable names with `.data[[var]]` notation
7. Update documentation if parameters changed (ensure exact parameter name matches)
8. Update `@importFrom` statements if new external functions are used
9. Update tests if function behavior changes
10. **Check for global variable issues**: `R CMD check` should show no binding warnings
11. **Lint the code**: `R --no-restore --no-save -e 'library(lintr); lint_package()'`
12. **Style the code**: `R --no-restore --no-save -e 'library(styler); style_file("R/[file].R")'`
13. **Update documentation if changed**: `R --no-restore --no-save -e 'roxygen2::document()'`
14. **Validate documentation consistency**: Check for "Codoc mismatches" warnings
15. **Always rebuild and reinstall**: `R CMD build . && R CMD INSTALL rempsyc_*.tar.gz`
16. **Always test the specific function manually**
17. Run full test suite to check for regressions
18. **Create before/after reprexes**: Prepare examples showing the old vs new behavior for PR description
19. **If making additional commits**: DO NOT update version/NEWS.md again - use same version for all commits in this PR

## Version Management and Changelog Updates

**CRITICAL**: Every PR must include version number updates and NEWS.md changelog entries. This is mandatory for all changes.

**IMPORTANT CLARIFICATION**: Version numbers should be bumped **ONCE PER PULL REQUEST**, not once per commit. If you make multiple commits within a single PR, all commits should use the same version number. Only bump the version once at the beginning of your PR work or before submitting the PR for review.

### Version Numbering System

The rempsyc package follows this versioning pattern:
- **Major releases** (CRAN submissions): Two decimals (e.g., 0.1.9, 0.1.8, 0.1.7)
- **Development versions** (between CRAN releases): Three decimals (e.g., 0.1.8.3, 0.1.8.2, 0.1.8.1)

### When to Bump Versions

**ALWAYS** bump the version for ANY change that affects the package:
1. **Bug fixes**: Increment the third decimal (0.1.91 → 0.1.92)
2. **New features**: Increment the third decimal (0.1.91 → 0.1.92) 
3. **Breaking changes**: Increment the second decimal (0.1.91 → 0.2.0) - rare
4. **Documentation-only changes**: Still increment third decimal for tracking

### Multiple Commits Within a Single PR

**CRITICAL RULE**: If your PR involves multiple commits, use the same version number for ALL commits in that PR.

**Correct approach for multi-commit PR**:
1. **At the start of your PR work**: Bump version from 0.1.91 → 0.1.92 and update NEWS.md
2. **First commit**: Contains version bump + your first set of changes
3. **Subsequent commits**: Use the same version (0.1.92) for any additional changes
4. **Do NOT bump version again** until you start a new PR

**Example of correct multi-commit PR**:
- Commit 1: "Bump version to 0.1.92 and add new feature X"
- Commit 2: "Fix bug in feature X (still version 0.1.92)" 
- Commit 3: "Update documentation for feature X (still version 0.1.92)"
- All commits use version 0.1.92, NEWS.md updated once in commit 1

**NEVER do this** (incorrect approach):
- Commit 1: "Add feature X, bump to 0.1.92"
- Commit 2: "Fix bug in feature X, bump to 0.1.93" ❌ WRONG
- Commit 3: "Update docs, bump to 0.1.94" ❌ WRONG

### How to Update Version Number

1. **Edit the DESCRIPTION file**:
   ```bash
   cd /home/runner/work/rempsyc/rempsyc
   # Find current version
   grep "Version:" DESCRIPTION
   # Update to next version (example: 0.1.91 → 0.1.92)
   ```

2. **Version update pattern**:
   ```r
   # Current version: 0.1.91
   # For your PR: 0.1.92
   # Next PR: 0.1.93
   # etc.
   ```

### How to Update NEWS.md

**MANDATORY**: Add your changes to the top of NEWS.md following this exact format:

1. **For first change after a major release** (e.g., after 0.1.9 was released):
   ```markdown
   # rempsyc 0.1.10
   * CRAN submission (when ready)
   
   ## rempsyc 0.1.9.1
   * Your change description here
   ```

2. **For subsequent development changes** (when 0.1.9.1 already exists):
   ```markdown
   # rempsyc 0.1.10
   * CRAN submission (when ready)
   
   ## rempsyc 0.1.9.2
   * Your new change description here
   
   ## rempsyc 0.1.9.1  
   * Previous change description here
   ```

3. **Change description guidelines**:
   - Use function names in backticks: `nice_table()`
   - Be specific about what changed
   - Include issue references if applicable: (#28)
   - Examples:
     - `nice_table()`: fix bug with grouped tibbles leading to an error
     - `nice_scatter()`: add new `color_by` argument for categorical coloring  
     - `cormatrix_excel()` now relies entirely on `correlation::cormatrix_to_excel()` to reduce maintenance

### Automated Version Management Workflow

**Follow this exact sequence ONCE PER PR** (not per commit):

```bash
cd /home/runner/work/rempsyc/rempsyc

# Step 1: Check current version
grep "Version:" DESCRIPTION
grep -A5 "^# rempsyc" NEWS.md | head -10

# Step 2: Determine new version number
# Current: 0.1.91 → New: 0.1.92 (example)

# Step 3: Update DESCRIPTION file (ONCE per PR)
sed -i 's/Version: 0.1.91/Version: 0.1.92/' DESCRIPTION

# Step 4: Update NEWS.md (ONCE per PR - add entry at the top)
# Use your preferred text editor or str_replace_editor

# Step 5: Verify updates
grep "Version:" DESCRIPTION
head -10 NEWS.md

# Step 6: Proceed with normal build/test workflow
# Step 7: Make your code changes and commit everything together
# Step 8: Any additional commits in this PR should NOT change version numbers again
```

### Version Update Examples

#### Example 1: Bug Fix
```markdown
# In DESCRIPTION: Version: 0.1.91 → 0.1.92
# In NEWS.md (add at top):
## rempsyc 0.1.91.1  
* `nice_table()`: fix column alignment issue with long variable names
```

#### Example 2: New Feature  
```markdown
# In DESCRIPTION: Version: 0.1.92 → 0.1.93
# In NEWS.md (add at top):
## rempsyc 0.1.92.1
* `nice_scatter()`: add `theme_preset` argument for quick plot styling options
```

#### Example 3: Multiple Changes
```markdown
# In DESCRIPTION: Version: 0.1.93 → 0.1.94  
# In NEWS.md (add at top):
## rempsyc 0.1.93.1
* `nice_violin()`: improve error messages for invalid grouping variables
* `plot_outliers()`: add support for custom outlier detection methods
* Documentation updates for improved clarity across all visualization functions
```

### Before Submitting Your PR (Final Validation)
**CRITICAL**: Always run this complete validation sequence to ensure workflow checks pass on first try. This should be done once before submitting your PR for review, not before every individual commit.

```bash
cd /home/runner/work/rempsyc/rempsyc

# 0. ENSURE: Version number and NEWS.md were already updated once at the beginning of this PR
#    (Do NOT update them again if this is a subsequent commit in the same PR)

# 1. Check for global variable binding issues first (look for "no visible binding" warnings)
R --no-restore --no-save -e 'warnings(); R CMD check rempsyc_*.tar.gz --no-manual --no-vignettes 2>&1 | grep -i "binding"'

# 2. Lint code to identify style issues (20 seconds)
R --no-restore --no-save -e 'library(lintr); lint_package()'

# 3. Style code to automatically fix issues (10-30 seconds) - optional but recommended
R --no-restore --no-save -e 'library(styler); style_pkg()'

# 4. Update documentation if documentation was changed (5-15 seconds)
R --no-restore --no-save -e 'roxygen2::document()'

# 5. Build (19 seconds)
R CMD build .

# 6. Install  
R CMD INSTALL rempsyc_*.tar.gz

# 7. Test (11 seconds) 
R --no-restore --no-save -e 'library(testthat); library(rempsyc); test_local()'

# 8. Final R CMD check for all issues (~30 seconds) - REQUIRED before PR submission
_R_CHECK_FORCE_SUGGESTS_=FALSE R CMD check rempsyc_*.tar.gz --no-manual --no-vignettes

# 9. Look specifically for critical warnings that fail CI:
# - "no visible binding for global variable"
# - "Codoc mismatches from Rd file"
# - Fix these issues before submitting your PR
```

### Pull Request Requirements
**CRITICAL**: When creating pull requests, you MUST include ALL of the following:

1. **Version number bump** in DESCRIPTION file (see Version Management section above)
2. **NEWS.md changelog entry** with your changes (see Version Management section above)  
3. **Reprexes** (minimally reproducible examples) showing the old and new behavior for comparison

**MANDATORY**: Use the actual `reprex` package - NEVER simulate or guess at reprex output. The repository owner needs to see actual function behavior, including plots/images that cannot be simulated.

**VERSION MANAGEMENT IS NOT OPTIONAL**: Every PR must include version updates and changelog entries. PRs without these updates will be rejected.

#### Creating Reprexes for PRs:

1. **Use base R datasets** when possible (e.g., `mtcars`, `iris`, `airquality`) for reproducible examples
2. **Show before/after behavior** with your code changes
3. **ALWAYS use the actual reprex package** for consistent formatting:
   ```bash
   # Ensure reprex is installed and working BEFORE creating PR
   R --no-restore --no-save -e '
   if (!requireNamespace("reprex", quietly = TRUE)) {
     stop("reprex package MUST be installed before creating PRs")
   }
   library(reprex)
   # Test with simple example first
   test_result <- reprex(input = "x <- 1:5\nmean(x)", venue = "gh", advertise = FALSE, show = FALSE)
   if (length(test_result) == 0) {
     stop("reprex package is not working correctly")
   }
   cat("reprex is ready for PR creation\n")
   '
   ```

4. **Generate ACTUAL reprex output** using this workflow:
   ```r
   library(reprex)
   
   # For BEFORE behavior (if modifying existing function):
   before_code <- "
   library(rempsyc)
   data(mtcars)
   # [your code showing current behavior]
   "
   before_reprex <- reprex(input = before_code, venue = "gh", advertise = FALSE)
   
   # For AFTER behavior (with your changes):
   after_code <- "
   library(rempsyc)
   data(mtcars)
   # [your code showing improved behavior]
   "
   after_reprex <- reprex(input = after_code, venue = "gh", advertise = FALSE)
   ```

5. **Include both ACTUAL reprex outputs** in your PR description:
   - **Before**: Real reprex output showing the current (problematic) behavior
   - **After**: Real reprex output showing the improved behavior with your changes

#### Quick Reprex Creation Workflow:
**NEVER SKIP**: Always generate actual reprex, never simulate or guess:

```bash
cd /home/runner/work/rempsyc/rempsyc
R --no-restore --no-save -e '
library(reprex)
library(rempsyc)

# Create ACTUAL reprex for your changes
example_code <- "
library(rempsyc)
data(mtcars)

# Example: test the function you modified
result <- nice_t_test(data = mtcars, response = \"mpg\", group = \"am\")
print(result)

# If working with plots, include them:
if (requireNamespace(\"ggplot2\", quietly = TRUE)) {
  plot_result <- nice_scatter(data = mtcars, response = \"mpg\", predictor = \"wt\")
  print(plot_result)
}
"

# Generate actual reprex
actual_reprex <- reprex(input = example_code, venue = "gh", advertise = FALSE)

# Verify it worked
if (length(actual_reprex) > 0) {
  cat("SUCCESS: Generated actual reprex for PR\n")
  cat("Copy this output to your PR description:\n")
  cat("========================================\n")
  cat(paste(actual_reprex, collapse = "\n"))
  cat("\n========================================\n")
} else {
  stop("FAILED: Could not generate reprex - fix reprex installation first")
}
'
```

**RStudio Users**: Use the reprex addin for faster creation:
- Install reprex: `install.packages("reprex")`
- Go to `Addins` → Search "reprex" → Select "Render reprex..."
- Copy code → Use addin → Check "Append session info" → Render

**Workflow Logic**: 
- Lint first to identify all style issues
- Style second to automatically fix what can be fixed
- Update documentation third if any roxygen2 comments were changed
- Build and test last to validate everything works together

## Troubleshooting

### "The package installation is taking a long time"
- **Cause**: Installing too many suggested packages instead of only the ones needed for the current function
- **Solution**: Follow the targeted installation approach - only install packages specifically required by the function you're modifying
- **Prevention**: Always use `grep -A2 -B2 "rlang::check_installed" R/[function_file].R` to identify minimal dependencies first

### "Could not find function" Errors
- **Cause**: Package not loaded or installed
- **Solution**: Run `R CMD build . && R CMD INSTALL rempsyc_*.tar.gz` then `library(rempsyc)`

### Missing Package Errors
- **Cause**: Suggested packages not installed
- **Solution**: Install via `sudo apt install r-cran-[package]` or ignore if testing core functionality

### Network/CRAN Access Issues  
- **Cause**: Blocked network access to CRAN mirrors
- **Solution**: Use system packages via apt or skip optional package tests

### Test Snapshot Failures
- **Cause**: Minor precision differences in numerical results (normal)
- **Solution**: Review changes, accept if precision differences are minor: `testthat::snapshot_accept()`

### Build Failures
- **Cause**: Syntax errors, missing dependencies, or file issues
- **Solution**: Check specific error messages, ensure DESCRIPTION is correct, verify all R files have valid syntax

### Styler Not Available
- **Cause**: styler package not installed
- **Solution**: Install via R: `R --no-restore --no-save -e 'install.packages("styler", repos="https://cloud.r-project.org/")'` or skip styling step if not critical

### Roxygen2 Not Available
- **Cause**: roxygen2 package not installed
- **Solution**: Install via R: `R --no-restore --no-save -e 'install.packages("roxygen2", repos="https://cloud.r-project.org/")'` or use devtools: `R --no-restore --no-save -e 'devtools::document()'`

### Documentation Build Failures
- **Cause**: Documentation not updated after changing roxygen2 comments
- **Solution**: Run `R --no-restore --no-save -e 'roxygen2::document()'` before building the package

### Global Variable Binding Warnings ("no visible binding")
- **Cause**: Using bare variable names in dplyr/ggplot2 operations instead of proper notation
- **Solution**: Replace with `.data[[variable_name]]` notation and add proper `@importFrom` statements
- **Example**: Change `group_by(var)` to `group_by(.data[[var]])`
- **DO NOT**: Create `global_variables.R` files with `utils::globalVariables()`

### Documentation Mismatch Warnings ("Codoc mismatches")
- **Cause**: Function parameter names don't match the documentation
- **Solution**: Ensure `@param parameter_name` exactly matches function arguments
- **Prevention**: Always run `roxygen2::document()` after changing function signatures

### CRAN/Network Access Blocked
- **Cause**: Cannot install packages from CRAN mirrors
- **Solutions**: 
  - Use system packages: `sudo apt install r-cran-[package]`
  - Try R-universe: `repos="https://r-universe.dev"`  
  - Use pak package: `pak::pak("[package-name]")`

### reprex Package Issues
- **Cause**: reprex package not installed or not working correctly
- **Solution**: Follow the comprehensive reprex installation steps:
  ```bash
  # Multi-method installation
  R --no-restore --no-save -e '
  if (!requireNamespace("reprex", quietly = TRUE)) {
    tryCatch({
      install.packages("reprex", repos="https://cloud.r-project.org/")
    }, error = function(e1) {
      tryCatch({
        install.packages("reprex", repos="https://r-universe.dev")
      }, error = function(e2) {
        install.packages("pak", repos="https://r-lib.github.io/p/pak/stable/")
        pak::pak("reprex")
      })
    })
  }
  '
  ```
- **Verification**: Always test reprex functionality before creating PRs using the validation scenario

### reprex Not Generating Output
- **Cause**: Code errors, missing packages, or input format issues
- **Solution**: 
  - Test with simple code first: `x <- 1:5; mean(x)`
  - Ensure all required packages are loaded in the reprex code
  - Use `venue = "gh"` for GitHub-formatted output
  - Check for syntax errors in the input code
- **Debug**: Use `reprex(input = your_code, venue = "gh", advertise = FALSE, show = TRUE)` to see detailed output

## Common Reference Information

The following are outputs from frequently used commands. Reference them instead of running bash commands to save time.

### Repository Root Structure
```
ls -la /home/runner/work/rempsyc/rempsyc/

.Rbuildignore       - Files to exclude from package build
.github/            - GitHub workflows and actions
.gitignore          - Git ignore patterns
CITATION.cff        - Citation metadata
DESCRIPTION         - Package metadata and dependencies
LICENSE.md          - Package license (GPL 3+)
NAMESPACE           - Package exports (auto-generated)
NEWS.md             - Change log
R/                  - R source code (34+ files)
README.Rmd          - Source for README (edit this, not README.md)
README.md           - Main repository documentation
TODOS.md            - Development roadmap
cran-comments.md    - CRAN submission notes
docs/               - pkgdown documentation site
inst/               - Package installation files
man/                - Help documentation (auto-generated)
tests/              - Test files (testthat framework)
vignettes/          - R Markdown tutorials
```

### Core R Functions by File
```
R/nice_t_test.R      - t-test analysis
R/nice_table.R       - APA formatted tables  
R/nice_scatter.R     - Scatter plot visualization (uses .data[[var]] notation)
R/nice_violin.R      - Violin plot visualization
R/extract_duplicates.R - Data cleaning utilities
R/nice_na.R          - Missing data analysis
R/format_value.R     - Value formatting (p, r, d values)
R/scale_mad.R        - Robust standardization
R/global_variables.R - DEPRECATED: Do not add to this file
```

### Code Quality Examples

#### CORRECT: Proper Variable Referencing
```r
# In dplyr operations - USE .data[[var]] notation:
data %>%
  group_by(.data[[group]]) %>%
  summarize(mean_val = mean(.data[[response]], na.rm = TRUE))

# In ggplot operations - USE .data[[var]] notation:
ggplot(data, aes(x = .data[[predictor]], y = .data[[response]]))

# Always include proper imports:
#' @importFrom dplyr group_by summarize
#' @importFrom ggplot2 ggplot aes
```

#### INCORRECT: Causes CI Failures  
```r
# DO NOT: Bare variable names (causes binding warnings)
data %>%
  group_by(group) %>%
  summarize(mean_val = mean(response, na.rm = TRUE))

# DO NOT: Add to global_variables.R file
utils::globalVariables(c("group", "response"))
```

## CI/CD Integration

The package uses GitHub Actions with these workflows:
- **R-CMD-check**: Multi-platform testing (Ubuntu, macOS, Windows)  
- **lint**: Code style checking with lintr
- **test-coverage**: Code coverage reporting with covr
- **pkgdown**: Documentation website generation

These workflows run automatically on pushes and pull requests to main/master branches.

### Ensuring CI Workflows Pass on First Try

**CRITICAL**: Follow these guidelines to prevent CI failures:

#### 1. Global Variable Binding Prevention
- **Always** use `.data[[variable_name]]` in dplyr operations
- **Always** add `@importFrom package function` for external functions
- **Never** create `global_variables.R` files with `utils::globalVariables()`
- **Test locally**: `R CMD check` should show no "no visible binding" warnings

#### 2. Documentation Consistency Validation  
- **Always** ensure parameter names in `@param` match function arguments exactly
- **Always** run `roxygen2::document()` after changing function signatures
- **Test locally**: Look for "Codoc mismatches" warnings during build

#### 3. Package Installation Strategy
When packages can't be installed from CRAN:
- **Primary**: Use system packages via `sudo apt install r-cran-[package]`
- **Alternative**: Use R-universe repository: `repos="https://r-universe.dev"`
- **Advanced**: Use pak package for better dependency resolution

#### 4. Pre-Commit Validation Checklist
Before making any PR, verify locally:
```bash
# Must show ZERO "no visible binding" warnings:
R CMD check rempsyc_*.tar.gz 2>&1 | grep -i "binding"

# Must show ZERO "Codoc mismatches" warnings:  
R CMD check rempsyc_*.tar.gz 2>&1 | grep -i "codoc"

# All tests must pass (94+ passing tests expected):
R --no-restore --no-save -e 'library(testthat); library(rempsyc); test_local()'
```

#### 5. PR Description Requirements  
**CRITICAL**: Always include reprexes in PR descriptions to demonstrate code changes:
```r
# Create examples showing before/after behavior:
library(rempsyc)
data(mtcars)

# BEFORE (if modifying existing function):
# [show current behavior]

# AFTER (with your changes):
# [show improved behavior]
```

## Performance Notes

- Package build: ~19 seconds
- Package install: ~3 seconds  
- Test suite: ~11 seconds (99 tests: 94 pass, 5 snapshot failures expected)
- Linting: ~20 seconds (673 style issues - normal for existing codebase)
- Code styling: ~10-30 seconds depending on package size
- Documentation update: ~5-15 seconds (roxygen2)
- R CMD check: ~29 seconds (without suggested packages), 2-5 minutes (full check)
- Function loading after install: Near instant
- **Package installation**: 1-5 seconds per package (targeted) vs 2-10 minutes (batch installation of all suggested packages)

**CRITICAL**: Never cancel builds or tests prematurely. Always wait for completion and set appropriate timeouts (60+ seconds for builds, 30+ seconds for tests, 10+ minutes for R CMD check).

**PACKAGE INSTALLATION**: Use targeted installation (install only what the specific function needs) to avoid "The package installation is taking a long time" messages. Installing all 22+ suggested packages takes 2-10 minutes; installing 1-3 specific packages takes 1-5 seconds each.