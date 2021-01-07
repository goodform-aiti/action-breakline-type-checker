#!/bin/bash


ERROR=0


echo " ************** MODIFIED FILES"

printf ${MODIFIED_FILES}

printf "\n*****************************\n"

PATHS=$(printf ${MODIFIED_FILES} | tr \\n '\n')


echo "$PATHS" | while read FILE ; do
    if [[ ! -f $FILE ]]
    then
      # skip deleted files
      continue
    fi
    
    IS_FILE_BINARY=$(find $FILE -type f | perl -lne 'print if -B' | wc -l)
    if [[ $IS_FILE_BINARY == 1 ]]
    then
      continue
    fi
    
    
    CRLF_COUNT=$(find $FILE -not -type d  -exec file "{}" ";" | grep " CRLF" | cut -d " " -f 1 | cut -d ":" -f 1 | wc -l)
    CR_COUNT=$(find $FILE -not -type d  -exec file "{}" ";" | grep " CR" | cut -d " " -f 1 | cut -d ":" -f 1 | wc -l)
    
    
    if [[ $CRLF_COUNT == 1 ]]
    then
      echo "CRLF break-line format is exists in $FILE"
      exit 101
    fi
    if [[ $CR_COUNT == 1 ]]
    then
      echo "CR break-line format is exists in $FILE"
      exit 101
    fi
done
