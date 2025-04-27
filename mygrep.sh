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


# Initialize variables
show_line_numbers=false
invert_match=false


# Use getopts to parse options
while getopts ":nv" opt; do
  case "$opt" in
    n) show_line_numbers=true ;;
    v) invert_match=true ;;
    \?) 
      echo "Invalid option: -$OPTARG" 
      print_usage
      exit 1
      ;;
  esac
done

# Shift the processed options
shift $((OPTIND -1))

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

