# Language Support

## Systems / Linux

|Language|LSP|Linter|DAP|Compiler / Interpreter|Injections|Notes|
|-|-|-|-|-|-|-|
|C|✔|✔|✔|GCC + Clang + zig-cc| | |
|C++|✔|✔|✔|GCC + Clang + zig-cpp| | |
|Zig|✔|✔|✔|Zig-unstable| | |
|Rust|✔|✔|✔|Nightly Cargo + Rustc| | |
|Clojure|✔| | |Clojure + Lein| | |
|Haskell|✔| |✔| | | |
|Python|✔|✔| | | | |
|Go|✔| | | | | |
|Lua|✔|✔| | | | |
|Odin|✔| | | | | |
|Assembly|✔| | | | | |

## Shells

|Language|LSP|Linter|
|-|-|-|
|Bash|✔|✔|
|Fish|✔|✔|
|NuShell|✔|✔|

## Embedded / BareMetal

|Language|LSP|Linter|DAP|Compiler / Interpreter|Notes|
|-|-|-|-|-|-|
|C|✔|✔|✔|GCC + Clang + zig-cc| |
|C++|✔|✔|✔|GCC + Clang + zig-cpp| |
|Zig|✔|✔| |Zig-unstable|No Xtensa support yet|
|Rust|✔|✔|✔|Nightly Cargo + Rustc|Xtensa requires patched compiler|

## Hardware Definition (HDL)

|Language|LSP|Linter|Simulator|Compiler|Notes|
|-|-|-|-|-|-|
|VHDL|✔| | | | |
|Verilog|✔|✔| | | |
|SystemVerilog|✔|✔| | | |
|XDC| | | | |TCL-based|

## Web

|Language|LSP|
|-|-|
|HTML|✔|
|CSS|✔|
|JavaScript|✔|
|TypeScript|✔|

## Markup / Typesetting

|Language|LSP|
|-|-|
|Markdown|✔|
|Typst|✔|
|LaTeX|✔|

## Misc (DSLs + configuration)

|Language|LSP|Linter
|-|-|-|
|Nix|✔|✔|
|justfile|✔| |
|makefile| |✔|
|cmake|✔| |
|Toml|✔| |
|Yaml|✔| |
|JSON|✔| |
|XML|✔| |
|SQL|✔| |
|SCAD|✔| |
|HCL|✔| |

---

#### Note: This Table Is Incomplete
