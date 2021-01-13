#!/bin/bash -e

find definitions -type f  | while read def_file; do
  if [ "$def_file" = "definitions/common/mopm-bash-test-a" ] \
  || [ "$def_file" = "definitions/common/mopm-bash-test-failed" ]; then
    continue
  fi
  error_message=""
  if ! grep -q -E "^# mopm-url: https?://" "$def_file" ; then
    error_message="$def_file:  The line 'mopm-url' is not found or invalid..\n"
  fi
  if ! grep -q -E "^# mopm-description: " "$def_file" ; then
    error_message+="$def_file:  The line 'mopm-description' is not found\n"
  fi
  if ! grep -q -E "^# mopm-dependencies: (([a-z0-9-]+, )*[a-z0-9-]+)?$" "$def_file" ; then
    error_message+="$def_file:  The line 'mopm-dependencies' is not found or invalid..\n"
  fi
  if ! grep -q -E "^# mopm-verification: " "$def_file" ; then
    error_message+="$def_file:  The line 'mopm-verification' is not found\n"
  fi

  if [ -n "$error_message" ]; then
    echo -e "$error_message"
    exit 1
  fi
done
