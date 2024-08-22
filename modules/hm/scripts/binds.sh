hyprctl binds -j | jq 'pick(.[].modmask,.[].key,.[].description)' | jq -r '(.[0]|keys_unsorted|(.,map(length*"-"))),.[]|map(.)|@tsv'|column -ts $'\t'
