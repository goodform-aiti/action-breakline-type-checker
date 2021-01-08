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
    
    
    CR_FOUND=$(find $FILE -not -type d  -exec file "{}" ";" | grep " CR\(LF\)\? line terminators" | cut -d " " -f 1 | cut -d ":" -f 1 | wc -l)
    CR_LINE_DETECTOR=$(find $FILE -not -type d  -exec file "{}" ";" | grep ", with CR\(LF\)\?," | cut -d " " -f 1 | cut -d ":" -f 1 | wc -l)
    BREAKLINE_TYPE=$(find crlf.php -not -type d  -exec file "{}" ";" | grep -o "CR\(LF\)\?")
    
    
    
    if [[ $CR_FOUND == 1 ]]
    then
      echo "Whole file( $FILE ) breakline format is $BREAKLINE_TYPE , it should be LF"
      echo "**********************************************"
      exit 101
    fi
    
    
    
    
    
    if [[ $CR_LINE_DETECTOR == 1 ]]
    then
      echo "$BREAKLINE_TYPE line breaker found in $FILE:"
      cat -en $FILE | grep "\^M" | sed 's/\^M\$//g'
      echo "**********************************************"
      exit 101
    fi
done
