#!/usr/bin/env bash

declare -F is_array >/dev/null 2>/dev/null || {

  # append item(s) to end of array
  # @usage: array_push MYARRAY item-0 [,...item-n]
  array_push(){ declare -n v=$1 && shift; [ $# == 0 ] || v=("${v[@]}" "$@"); }
  
  # remove item(s) from end of array
  # @usage: array_pop MYARRAY [amount] => ARRAY_ITEM contains popped items and array length reduced by amount
  array_pop(){ declare -agx ARRAY_ITEM=(); declare -n v=$1 && declare -ir count=${2:-1}; [[ $count -gt 0 ]] && { ARRAY_ITEM=("${v[@]:((0-$count))}"); v=("${v[@]:0:((${#v[@]}-count))}"); }; }
  
  # prepend item(s) to beginning of array
  # @usage: array_unshift MYARRAY item-0 [,...item-n]
  array_unshift(){ declare -n v=$1 && shift; [ $# == 0 ] || v=("$@" "${v[@]}"); }
  
  # remove item(s) from beginning of array
  # @usage: array_shift MYARRAY [amount] => ARRAY_ITEM contains shifted items and array length reduced by amount
  array_shift(){ declare -agx ARRAY_ITEM=(); declare -n v=$1 && declare -ir count=${2:-1}; [[ $count -gt 0 ]] && { ARRAY_ITEM=("${v[@]:0:$count}"); v=("${v[@]:$count:((${#v[@]}-count))}"); }; }
  
  # print array contents
  # @usage: array_print MYARRAY => prints contents to stdout
  array_print(){ is_array $1 || { echo "${!1}" && return; }; declare -n v=$1 && shift; declare k; for k in "${!v[@]}"; do echo "[$k]: ${v["$k"]}"; done; }
  
  # return error if not an array variable (either hashmap or indexed)
  # @usage:   is_array FOO && echo "the array $_ has ${#FOO[@]} item(s) " || echo "variable value is";
  # @see typeof
  is_array(){ declare -n v=$1; [[ "${#v[@]}" -gt 1 ]] && return 0; declare tmp=() && readarray -d " " -t "$_" < <( declare -p $1 ); [[ ${tmp[1],,} == *a* ]]; }
  
  # empty an array
  # @usage: array_clear MYARRAY
  array_clear(){ declare -n v=$1 && v=(); }
  
  # empty an array
  # @usage: array_join MYARRAY
  array_join(){ declare -n v=$1 && declare d="${2:-" "}"; printf '%s' "${v[@]/#/$d}"; }
  
  # todo:  array_contains
  # todo:  array_unique
  
}
