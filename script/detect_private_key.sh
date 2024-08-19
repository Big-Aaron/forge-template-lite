#!/bin/bash

# https://gist.github.com/suhailkakar/1f29265dbe843bfa85227c34ed063e86
# https://x.com/SuhailKakar/status/1825142639085109397

chmod +x script/detect_private_key.sh

# Define patterns for Ethereum and Solana private keys
ETH_PATTERN="(0x)?[A-Fa-f0-9]{64}"
SOL_PATTERN="^[1-9A-HJ-NP-Za-km-z]{88}$"

# Check for private keys in staged files
FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(js|ts|sol|py|sh|txt|json)$')
if [ -z "$FILES" ]; then
  exit 0
fi

for FILE in $FILES; do
  if grep -Eq "$ETH_PATTERN" "$FILE" || grep -Eq "$SOL_PATTERN" "$FILE"; then
    echo "Error: Detected a potential private key in $FILE"
    exit 1
  fi
done

exit 0