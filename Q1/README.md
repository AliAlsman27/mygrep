# MyGrep

A simple Bash script that searches inside a file for a given word, similar to `grep`.  
Supports:
- `-n` option to show line numbers.
- `-v` option to invert the match.
- Combined options like `-vn` or `-nv`.

## Usage

```bash
./mygrep.sh [-n] [-v] search_string filename
