#!/usr/bin/env bash 

FILE="/urls.txt"

# I added this in case we need to use a file other than the default. 
# If it's not needed, we can just check that the /urls.txt file exists and it's readable.
if [[ -n "${1}" && -f "${1}" ]]; then
  echo "Using file "${1}""
  FILE="${1}"
elif [[ -f "${FILE}" && -r "${FILE}" ]]; then
  echo "A custom file was not provided or does not exist, using default file /urls.txt"
else
  echo -e "Error: File /urls.txt does not exist or you do not have permission to read it"
  exit 1
fi


function check_urls {
  while read -r line; do
# Check for empty string
    if [[ -z "${line}" ]]; then
      continue
    fi
# Get HTTP response code
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${line}")
# Check HTTP response code
    if [[ "${HTTP_CODE}" =~ ^[45][0-9]{2}$ ]]; then
      echo "URL: ${line} is unavailable (HTTP ${HTTP_CODE})"
      exit 1 
    else
      echo "URL: ${line} is available (HTTP ${HTTP_CODE})"
    fi
  done <"${1}"
}

check_urls "${FILE}" 
