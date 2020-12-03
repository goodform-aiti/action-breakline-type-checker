#!/bin/bash


ERROR=0


echo " ************** MODIFIED FILES"

printf ${MODIFIED_FILES}

printf "\n*****************************\n"

PATHS=$(printf ${MODIFIED_FILES} | tr \\n '\n')
CSV_FILES=$(grep -P '.+\.csv$' <<< $PATHS)


echo "$CSV_FILES" | while read FILE ; do
    if [[ ! -f $FILE ]]
    then
      # skip deleted files
      continue
    fi
    CRLF_COUNT=$(grep -U $'\015' /var/www/html/includes/text | wc -l)
    CR_COUNT=$(grep -U $'\x0D' /var/www/html/includes/text | wc -l)
    if [[ $CRLF_COUNT > 0 ]]
    then
      ERROR=101
      echo "CSRF break-line format is exists in $FILE"
    fi
    if [[ $CR_COUNT > 0 ]]
    then
      ERROR=101
      echo "CSRF break-line format is exists in $FILE"
    fi
done

exit ${ERROR}
