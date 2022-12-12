#!/bin/bash

ERROR=0
PATHS=$(printf ${MODIFIED_FILES} | tr \\n '\n')


printf "\n******************************** MODIFIED FILES ****************************************************************"
printf ${MODIFIED_FILES}
printf "\n******************************** ERRORS FOUND ****************************************************************"

while read FILE ; do

    if [[ ! -f $FILE ]]; then
      continue # skip deleted files
    fi

    IS_FILE_BINARY=$(find $FILE -type f | perl -lne 'print if -B' | wc -l)
    if [[ $IS_FILE_BINARY == 1 ]]; then
      continue # skip binary files
    fi

    CR_FOUND=$(find $FILE -not -type d  -exec file "{}" ";" | grep " CR\(LF\)\? line terminators" | cut -d " " -f 1 | cut -d ":" -f 1 | wc -l)
    CR_LINE_DETECTOR=$(find $FILE -not -type d  -exec file "{}" ";" | grep ", with CR\(LF\)\?," | cut -d " " -f 1 | cut -d ":" -f 1 | wc -l)
    BREAKLINE_TYPE=$(find $FILE -not -type d  -exec file "{}" ";" | grep -o "CR\(LF\)\?")

    if [[ $CR_FOUND == 1 ]]; then
      printf "\n* Whole file( $FILE ) breakline format is $BREAKLINE_TYPE , it should be LF"
      ERROR=1
    fi

    if [[ $CR_LINE_DETECTOR == 1 ]]; then
      printf "\n* $BREAKLINE_TYPE line breaker found in $FILE:"
      cat -en $FILE | grep "\^M" | sed 's/\^M\$//g'
    fi
done <<< "$PATHS"

if [[ $ERROR == 0 ]]; then
  printf "\n* No files with wrong breakline format found in changed files"
  exit 0
else
  printf "\n* There are files with wrong breakline format, please fix them (see above)"
  exit 101
fi
