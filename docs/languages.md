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
|Python|✔|✔|✔|I/Python3 | |+Interactive|
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
|\*Arduino|✔|✔| | |Not really a language|

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

|Language|LSP|Preview
|-|-|-|
|Markdown|✔|✔|
|Org Mode|✔| |
|Neorg| | |
|Typst|✔|✔|
|LaTeX|✔| |

## Misc (DSLs + configuration)

|Language|LSP|Linter|
|-|-|-|
|Nix|✔|✔|
|justfile|✔| |
|makefile| |✔|
|cmake|✔| |
|Toml|✔| |
|Yaml|✔| |
|Jinja|✔| |
|JSON|✔| |
|QML|✔| |
|XML|✔| |
|SQL|✔| |
|SCAD|✔| |
|build123d|✔|✔|
|HCL|✔| |
|HTTP|✔| |

---

#### Note: This Table Is Incomplete
