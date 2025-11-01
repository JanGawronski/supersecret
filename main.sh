#!/bin/bash

git pull --quiet

if [ -f encrypted ]; then
    decrypted=$(base64 -d < encrypted | gpg --decrypt --quiet --batch --passphrase-file passphrase --pinentry-mode loopback -)
fi

if [ -z "${1-}" ]; then
    printf '%s' "$decrypted"
else
    printf '%s\n%s' "$decrypted" "$1" | gpg --quiet --symmetric --cipher-algo AES256 --batch --passphrase-file passphrase --pinentry-mode loopback -o - | base64 > encrypted.new && mv encrypted.new encrypted
fi
