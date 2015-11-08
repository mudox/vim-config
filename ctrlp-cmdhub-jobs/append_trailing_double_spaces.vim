" cmdhub: Append trailing double spaces

if expand('%:p:t') == 'english_vocabulary_confusion.md'
  g/\* \* \*/,$s/[^ *]$/  /
else
  echohl WarningMsg
  echo "only apply in file: english_vocabulary_confusion.md"
  echohl None
endif
