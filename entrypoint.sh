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
    CRLF_COUNT=$(grep -U $'\015' $FILE | wc -l)
    CR_COUNT=$(grep -U $'\x0D' $FILE | wc -l)
    if [[ $CRLF_COUNT > 0 ]]
    then
      ERROR=101
      echo "CRLF break-line format is exists in $FILE"
    fi
    if [[ $CR_COUNT > 0 ]]
    then
      ERROR=101
      echo "CR break-line format is exists in $FILE"
    fi
done

exit ${ERROR}
