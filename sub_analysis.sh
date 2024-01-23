#!/bin/bash
set -e

### para_pre
# arg_i 
# arg_s
# arg_o
### para

while getopts "i:s:o" opt; do
  case $opt in
    i)
      arg_i="$OPTARG"
      echo "Option -a with argument: $arg_i"
      ;;
    s)
      arg_s="$OPTARG"
      echo "Option -b with argument: $arg_s"
      ;;
    s)
      arg_o="$OPTARG"
      echo "Option -b with argument: $arg_o"
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

echo $arg_i
echo $arg_o
echo $arg_s