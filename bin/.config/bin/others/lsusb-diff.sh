#!/bin/bash

TMP_FILE="$HOME/.lsusb_prev"

# If no previous file exists, create it
if [ ! -f "$TMP_FILE" ]; then
    lsusb > "$TMP_FILE"
    echo "Initial lsusb snapshot saved."
    exit 0
fi

# Show current and diff
CURRENT=$(mktemp)
lsusb > "$CURRENT"

echo "=== Added ==="
diff "$TMP_FILE" "$CURRENT" | grep "^>" | sed 's/^> //'

echo
echo "=== Removed ==="
diff "$TMP_FILE" "$CURRENT" | grep "^<" | sed 's/^< //'

# Update snapshot
mv "$CURRENT" "$TMP_FILE"

