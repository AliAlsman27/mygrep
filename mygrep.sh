#!/bin/bash

# Function to print usage
print_usage() {
  echo "Usage: $0 [-n] [-v] search_string filename"
  echo "Options:"
  echo "  -n    Show line numbers"
  echo "  -v    Invert match (show non-matching lines)"
  echo "  --help  Show this help message"
}

# Handle --help
if [ "$1" == "--help" ]; then
  print_usage
  exit 0
fi

# Check for minimum arguments
if [ "$#" -lt 2 ]; then
  echo "Error: Missing arguments."
  print_usage
  exit 1
fi

# Initialize variables
show_line_numbers=false
invert_match=false

# Process option

while [[ "$1" == -* ]]; do
  case "$1" in
    -n) show_line_numbers=true ;;
    -v) invert_match=true ;;
    -vn|-nv)
        show_line_numbers=true
        invert_match=true
        ;;
    --help) print_usage; exit 0 ;;
    *) echo "Unknown option: $1"; print_usage; exit 1 ;;
  esac
  shift
done
# $1 is search string, $2 is filename
search_string="$1"
file="$2"

# Validate file exists
if [ ! -f "$file" ]; then
  echo "Error: File '$file' not found."
  exit 1
fi

# Do the search
line_number=0
while IFS= read -r line; do
  ((line_number++))
  
  if echo "$line" | grep -iq "$search_string"; then
    match=true
  else
    match=false
  fi

  # Invert match if needed
  if $invert_match; then
    match=$(! $match && echo true || echo false)
  fi

  if $match; then
    if $show_line_numbers; then
      echo "${line_number}:$line"
    else
      echo "$line"
    fi
  fi

done < "$file"

