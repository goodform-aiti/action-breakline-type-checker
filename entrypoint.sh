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
    CRLF_COUNT=$(find $FILE -not -type d  -exec file "{}" ";" | grep " CRLF " | cut -d " " -f 1 | cut -d ":" -f 1 | wc -l)
    CR_COUNT=$(find $FILE -not -type d  -exec file "{}" ";" | grep " CR " | cut -d " " -f 1 | cut -d ":" -f 1 | wc -l)
    
    echo $(find $FILE -not -type d  -exec file "{}" ";")
    #echo "CRLF ${CRLF_COUNT} in ${FILE}"
    #echo "CR ${CR_COUNT} in ${FILE}"
    
    if [[ $CRLF_COUNT == 1 ]]
    then
      ERROR=101
      echo "CRLF break-line format is exists in $FILE"
    fi
    if [[ $CR_COUNT == 1 ]]
    then
      ERROR=101
      echo "CR break-line format is exists in $FILE"
    fi
done

exit ${ERROR}
